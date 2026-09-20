"""Shared generic helpers for the test suites."""

from __future__ import annotations

import shlex
import sys
from pathlib import Path

# backports.zstd ships a drop-in tarfile that adds zst to the stdlib formats
# (gz/xz/bz2); on Python 3.14+ the stdlib tarfile already supports zst.
if sys.version_info >= (3, 14):
    import tarfile
else:
    from backports.zstd import tarfile

HOME_DIRS = (
    ".local/bin",
    ".local/lib",
    ".local/share",
    ".local/share/man",
    ".local/var",
    ".config",
    ".config/zshrc.d",
)


def shell_quote(*parts: str) -> str:
    return " ".join(shlex.quote(p) for p in parts)


def linked_to(link: Path, real: Path) -> bool:
    """True when `link` resolves to `real` (same file or dir)."""
    return link.resolve() == real.resolve()


def layout(root: Path, spec: dict[str, str]) -> None:
    """Populate root; spec maps a rel path to dir|exec|<content>."""
    for rel, kind in spec.items():
        p = root / rel
        if kind == "dir":
            p.mkdir(parents=True, exist_ok=True)
        elif kind == "exec":
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text("#!/bin/sh\n")
            p.chmod(0o755)
        else:
            p.parent.mkdir(parents=True, exist_ok=True)
            p.write_text(kind)


def archive(tgz: Path, root: Path, comp: str = "gz") -> None:
    # Real release tarballs ship a single wrapper/version dir at the top
    # (name_version_os_arch, TinyTeX-2026.09, ...): preserve root as that entry
    # so the classifier/peeler and the name/version resolution see it.
    with tarfile.open(tgz, f"w:{comp}") as tf:
        tf.add(root, arcname=root.name)


def make_variant(tgz: Path, root: Path, ext: str) -> None:
    """Build tgz in the given format (gz, xz, bz2 or zst)."""
    comp = {"tar.gz": "gz", "tar.xz": "xz", "tar.bz2": "bz2", "tar.zst": "zst"}[ext]
    archive(tgz, root, comp=comp)
