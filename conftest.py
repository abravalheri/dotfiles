"""Shared fixtures for the test suites.

Exposed from this directory so pytest applies them to every test file under
tools.common. The HOME fixture monkeypatches HOME, STOW_INSTALL_ROOT and the
XDG_* vars for the duration of each test; anything installer-specific (bin
dirs, binaries) is injected by per-test fixtures, not here.
"""

from __future__ import annotations

import os
import shlex
import sys
from pathlib import Path

import invoke
import pytest

# Make the repo's shared +lib importable before pulling in pytest_helpers.
sys.path.insert(0, str(Path(__file__).resolve().parent / "+lib"))

from pytest_helpers import HOME_DIRS, shell_quote


@pytest.fixture
def ctx() -> invoke.Context:
    return invoke.Context()


@pytest.fixture
def sh(ctx: invoke.Context):
    """Run a shell command; non-zero exit is reported (never raised)."""

    def run(cmd: str, env: dict[str, str] | None = None) -> invoke.Result:
        # warn=True lets us inspect `ok`; in_stream=False keeps invoke's stdin
        # thread away from pytest's output capture.
        return ctx.run(cmd, env=env, hide=True, warn=True, in_stream=False)

    return run


@pytest.fixture
def HOME(tmp_path: Path, monkeypatch) -> Path:
    """Scratch $HOME under /tmp with a real-home layout; monkeypatches HOME,
    STOW_OPT_ROOT and the XDG_* vars and chdirs into it for the duration of
    the test (all restored after), so the test is hermetic wherever pytest
    was launched. os.path.expanduser reads $HOME on POSIX, so no separate
    patch of it is needed.
    """
    h = tmp_path / "home"
    for d in HOME_DIRS:
        (h / d).mkdir(parents=True, exist_ok=True)
    monkeypatch.setenv("HOME", str(h))
    monkeypatch.setenv("STOW_INSTALL_ROOT", str(h / ".local" / "opt"))
    monkeypatch.setenv("XDG_CONFIG_HOME", str(h / ".config"))
    monkeypatch.setenv("XDG_DATA_HOME", str(h / ".local" / "share"))
    monkeypatch.setenv("XDG_CACHE_HOME", str(h / ".cache"))
    monkeypatch.setenv("XDG_STATE_HOME", str(h / ".local" / "state"))
    monkeypatch.chdir(h)
    return h


@pytest.fixture
def local_opt(HOME: Path) -> Path:
    """Scratch $opt root under the fixture HOME: ~/.local/opt."""
    return HOME / ".local" / "opt"


@pytest.fixture
def bash_run(sh):
    return lambda script, *pos: sh(f"bash -c {shell_quote(script, '_', *pos)}")


@pytest.fixture
def fake_stow(tmp_path: Path, monkeypatch) -> tuple[Path, Path]:
    """A fake `stow` that records each invocation, put first on PATH.

    Returns (bindir, log). The log gains one line of space-joined args per
    call, so forwarding order and per-package runs can be asserted without
    invoking real GNU stow.
    """
    bindir = tmp_path / "fakestow"
    bindir.mkdir()
    log = tmp_path / "stow.log"
    (bindir / "stow").write_text(
        f'#!/usr/bin/env bash\nprintf "%s\\n" "$*" >> {shlex.quote(str(log))}\n'
    )
    (bindir / "stow").chmod(0o755)
    monkeypatch.setenv("PATH", f"{bindir}{os.pathsep}{os.environ.get('PATH', '')}")
    return bindir, log
