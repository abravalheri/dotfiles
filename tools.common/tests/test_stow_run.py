"""stow-run parsing suite.

Runs stow-run against a fake `stow` that records one line of space-joined
args per invocation, so we assert exactly what GNU stow receives: forwarding
order, marker injection, and option/value handling, without touching the real
stow or any real home.
"""

from __future__ import annotations

from pathlib import Path

import pytest
from pytest_helpers import shell_quote

BIN = Path(__file__).resolve().parent.parent / ".local" / "bin"

IGN = ["--ignore=^\\.stow-target$", "--ignore=^\\.orig$"]


@pytest.fixture
def stow_run(sh, fake_stow):
    """Run stow-run against the fake stow; return each invocation's arg list."""

    def run(*args: str) -> list[list[str]]:
        r = sh(shell_quote(str(BIN / "stow-run"), *args))
        assert r.ok, r.stdout + r.stderr
        _bindir, log = fake_stow
        return [line.split() for line in log.read_text().splitlines()]

    return run


def test_explicit_target_forwards_verbatim(stow_run) -> None:
    args = ("--target", "/x", "-d", "opt", "-D", "alpha", "beta")
    # Any explicit -t/--target short-circuits: everything forwards as-is in a
    # single invocation; markers are not consulted.
    assert stow_run(*args) == [list(args)]


def test_explicit_short_target_forwards_verbatim(stow_run) -> None:
    args = ("-t/x", "-d", "opt", "alpha")
    assert stow_run(*args) == [list(args)]


@pytest.mark.parametrize(
    "make_form",
    [
        lambda opt: ("-d", str(opt)),
        lambda opt: ("--dir", str(opt)),
        lambda opt: (f"-d{opt}",),
        lambda opt: (f"--dir={opt}",),
    ],
    ids=["-d space", "--dir space", "-d attached", "--dir= attached"],
)
def test_dir_forms_and_marker(stow_run, HOME, make_form) -> None:
    local_opt = HOME / ".local" / "opt"
    pkg = local_opt / "tool"
    (pkg / "bin").mkdir(parents=True)
    (pkg / ".stow-target").write_text("~/.local\n")
    form = make_form(local_opt)
    assert stow_run(*form, "tool") == [
        ["-t", str(HOME / ".local"), *IGN, *form, "tool"]
    ]


def test_tilde_marker_expands_to_home(stow_run, HOME) -> None:
    local_opt = HOME / ".local" / "opt"
    pkg = local_opt / "tool"
    (pkg / "bin").mkdir(parents=True)
    (pkg / ".stow-target").write_text("~\n")
    assert stow_run("-d", str(local_opt), "tool") == [
        ["-t", str(HOME), *IGN, "-d", str(local_opt), "tool"]
    ]


def test_no_marker_no_target(stow_run) -> None:
    # Plain package: no -t, no ignores.
    assert stow_run("tool") == [["tool"]]


def test_no_value_long_option_keeps_packages(stow_run) -> None:
    # --stow takes no value, so alpha and beta are both packages, one stow run
    # each with the mode forwarded before the package.
    assert stow_run("-d", "opt", "--stow", "alpha", "beta") == [
        ["-d", "opt", "--stow", "alpha"],
        ["-d", "opt", "--stow", "beta"],
    ]


def test_space_valued_long_consumes_value(stow_run) -> None:
    # --ignore takes a value: it must not be mistaken for, nor swallow, a
    # package. A single forward run carries the value into both invocations.
    assert stow_run("-d", "opt", "--ignore", r"\.zst$", "alpha", "beta") == [
        ["-d", "opt", "--ignore", r"\.zst$", "alpha"],
        ["-d", "opt", "--ignore", r"\.zst$", "beta"],
    ]


def test_multiple_packages_different_markers(stow_run, HOME) -> None:
    local_opt = HOME / ".local" / "opt"
    alpha = local_opt / "alpha"
    (alpha / "bin").mkdir(parents=True)
    beta = local_opt / "beta"
    (beta / ".config").mkdir(parents=True)
    (alpha / ".stow-target").write_text("~/.local\n")
    (beta / ".stow-target").write_text("~\n")
    assert stow_run("-d", str(local_opt), "alpha", "beta") == [
        ["-t", str(HOME / ".local"), *IGN, "-d", str(local_opt), "alpha"],
        ["-t", str(HOME), *IGN, "-d", str(local_opt), "beta"],
    ]
