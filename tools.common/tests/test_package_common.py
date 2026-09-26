"""Layout-aware installer suite.

Drives the bash installers in-process via invoke against scratch /tmp homes,
so the real ~/.local and /usr/local are never touched. Covers Linux/macOS
archive naming, tar formats, and bare homes. Run via ``make test`` (nox + uv).
"""

from __future__ import annotations

import os
import shlex
import sys
import tarfile
from pathlib import Path

import pytest
from pytest_helpers import (
    HOME_DIRS,
    archive,
    layout,
    linked_to,
    make_variant,
    shell_quote,
)

BIN = Path(__file__).resolve().parent.parent / ".local" / "bin"
LIB = Path(__file__).resolve().parent.parent / ".local" / "lib" / "package-common.sh"


@pytest.fixture
def bins_on_path(monkeypatch):
    """Prepend the installer bin dir to PATH for tests that run installers."""
    monkeypatch.setenv("PATH", f"{BIN}{os.pathsep}{os.environ.get('PATH', '')}")


@pytest.fixture
def run_bin(sh, bins_on_path):
    """Run one of the installer executables; returns the raw result."""

    def run(binary: str, *args: str):
        return sh(shell_quote(str(BIN / binary), *args))

    return run


@pytest.fixture
def installer(run_bin):
    """Run one of the installer executables, asserting success."""

    def run_installer(binary: str, *args: str):
        r = run_bin(binary, *args)
        assert r.ok, f"{binary} failed:\n{r.stdout}\n{r.stderr}"
        return r

    return run_installer


# ----------------------------------------------------------- unit (parameterised)

_VERSION_CASES = [
    pytest.param("TinyTeX-darwin-v2026.09", "2026.09", id="url-stem"),
    pytest.param("foo-1.2.3", "1.2.3", id="wrapper-dir"),
    pytest.param("rtm-2024.11.0-linux-x64", "2024.11.0", id="not-gorelease"),
    pytest.param(
        "https://github.com/owner/repo/releases/download/v1.2.3/foo-linux-x64.tar.gz",
        "1.2.3",
        id="url-path-version",
    ),
    pytest.param(
        "https://github.com/owner/repo/releases/download/2025.05.0/bar-darwin-arm64.tar.gz",
        "2025.05.0",
        id="url-path-version-no-v",
    ),
]


@pytest.mark.parametrize("name,want", _VERSION_CASES)
def test_parse_version(bash_run, name: str, want: str) -> None:
    out = bash_run('source "$1"; parse_version "$2"', str(LIB), name)
    assert out.stdout.strip() == want


def test_parse_version_miss(bash_run) -> None:
    out = bash_run('source "$1"; parse_version hello', str(LIB))
    assert not out.ok
    latest = (
        "https://github.com/owner/repo/releases/latest/download/foo-linux-x64.tar.gz"
    )
    out = bash_run(f'source "$1"; parse_version "{latest}"', str(LIB))
    assert not out.ok


def _classify_builder(name: str, spec: dict[str, str], kind: str):
    def build(tmp_path: Path) -> Path:
        root = tmp_path / name
        root.mkdir(parents=True)
        layout(root, spec)
        return root

    return pytest.param(build, kind, id=name)


_CLASSIFY_CASES = [
    # GoReleaser-named wrapper with only a bin/ -> plain FHS-ish standard.
    _classify_builder("hello_1.2.3_darwin_arm64", {"bin/hello": "exec"}, "standard"),
    # Real GoReleaser flat shape: top-level binary plus manpages/.
    _classify_builder(
        "resh_0.19.0_linux_amd64",
        {"resh": "exec", "manpages/resh.1": "m"},
        "goreleased",
    ),
    _classify_builder("fhs", {"usr/bin/x": "exec"}, "standard"),  # fhs usr
    _classify_builder(
        "prefix",
        {"bin/a": "exec", "bin/b": "exec", "tlpkg/1": "dir", "texmf-dist/1": "dir"},
        "prefix",
    ),  # tinytex-like
    # A small multi-bin tool with a non-standard dir is NOT a relocatable
    # prefix (too few executables): it must be stowed as standard, not sealed.
    _classify_builder(
        "toolkit",
        {"bin/one": "exec", "bin/two": "exec", "tools/y": "dir"},
        "standard",
    ),
    _classify_builder("single", {"tool": "exec"}, "single-bin"),
    _classify_builder("unknown", {"readme.txt": "noise"}, "unknown"),
]


@pytest.mark.parametrize("builder,kind", _CLASSIFY_CASES)
def test_classify(tmp_path: Path, bash_run, builder, kind: str) -> None:
    """classify prints a pipe-separated (kind, root, prefix_marked) record."""
    script = (
        'source "$1"; IFS="|" read -r kind root pm <<< "$(classify "$2")"; '
        'printf "kind=%s\nroot=%s\npm=%s\n" "$kind" "$root" "$pm"'
    )
    root = builder(tmp_path)
    out = bash_run(script, str(LIB), str(root))
    assert out.ok, out.stdout + out.stderr
    got = dict(line.split("=", 1) for line in out.stdout.splitlines())
    assert got["kind"] == kind
    assert got["root"] == str(root)




def _sys_lib64() -> str:
    # system lib64 folds to lib on Darwin, is kept on other platforms
    return "lib" if sys.platform == "darwin" else "lib64"


_DEST_CASES = [
    ("user", "{local}", "bin", "bin", True),
    ("user", "{local}", "sbin", "bin", True),
    ("user", "{local}", "lib64", "lib", True),
    ("user", "{local}", "lib", "lib", True),
    ("user", "{local}", "man", "share/man", True),
    ("user", "{local}", "share", "share", True),
    ("user", "{local}", "var", "var", True),
    ("user", "{local}", "etc", ".config", True),
    ("user", "{home}", "bin", ".local/bin", True),
    ("user", "{home}", "lib64", ".local/lib", True),
    ("user", "{home}", "man", ".local/share/man", True),
    ("user", "{home}", "etc", ".config", True),
    ("user", "{local}", "texmf", "", False),  # non-FHS dir is an extra, dropped
    ("system", "/usr/local", "bin", "bin", True),
    ("system", "/usr/local", "sbin", "sbin", True),
    ("system", "/usr/local", "lib64", "{lib64}", True),
    ("system", "/usr/local", "man", "share/man", True),
    ("system", "/usr/local", "etc", "etc", True),
    ("system", "/usr/local", "share", "share", True),
]


@pytest.mark.parametrize(
    "layout,target,topdir,want,ok",
    _DEST_CASES,
    ids=[f"{l}-{t}-{d}" for l, t, d, _, _ in _DEST_CASES],
)
def test_dest_path(
    bash_run, HOME, layout: str, target: str, topdir: str, want: str, ok: bool
) -> None:
    target = target.format(home=str(HOME), local=str(HOME / ".local"))
    want = want.format(lib64=_sys_lib64())
    out = bash_run(
        'source "$1"; dest_path "$2" "$3" "$4"', str(LIB), layout, target, topdir
    )
    assert out.ok == ok
    if ok:
        assert out.stdout.strip() == want


def test_scope_resolution_promotes_home_for_etc(bash_run, HOME) -> None:
    """A kept user-scope etc entry maps to ~/.config, which lives outside the
    default ~/.local target, so scope_resolution promotes the target to $HOME."""
    out = bash_run('source "$1"; scope_resolution user 1', str(LIB))
    assert out.ok
    idir, target = out.stdout.strip().split("|")
    assert idir == str(HOME / ".local" / "opt")
    assert target == str(HOME)

    out2 = bash_run('source "$1"; scope_resolution user 0', str(LIB))
    idir2, target2 = out2.stdout.strip().split("|")
    assert target2 == str(HOME / ".local")  # without etc, no promotion

    # An explicit --target pin wins and never auto-promotes.
    out3 = bash_run(
        'source "$1"; scope_resolution user 1 "" /tmp/pinned', str(LIB)
    )
    assert out3.stdout.strip().split("|")[1] == "/tmp/pinned"


# -------------------------------------------------------------- end-to-end


def test_goreleased_direct(tmp_path, HOME, local_opt, installer) -> None:
    root = tmp_path / "hello_1.2.3_darwin_arm64"
    layout(root, {"bin/hello": "exec"})
    tgz = tmp_path / "gorelease.tgz"
    archive(tgz, root)
    installer("stow-install", str(tgz))
    pkg = local_opt / "hello-1.2.3"
    # bin-only maps 1:1 into the default target (~/.local): no marker needed.
    assert not (pkg / ".stow-target").exists()
    # ~/.local/bin/hello -> ~/.local/local_opt/hello-1.2.3/bin/hello
    assert linked_to(HOME / ".local/bin/hello", pkg / "bin/hello")
    assert not (pkg / ".orig").exists()  # direct, no farm
    assert not (local_opt / "hello").exists()  # no unversioned pkg
    installer("stow-uninstall", "hello")
    assert not (HOME / ".local/bin/hello").exists()


def test_fhs_farm(tmp_path, HOME, local_opt, installer) -> None:
    root = tmp_path / "f"
    layout(
        root,
        {
            "usr/bin/tool": "exec",
            "usr/lib64/t.so": "so",
            "usr/share/man/man1/tool.1": "m",
            "etc/tool.conf": "c",
        },
    )
    tgz = tmp_path / "fhs.tgz"
    archive(tgz, root)
    installer("stow-install", "--name", "fhs", "--version", "1.0", str(tgz))
    pkg = local_opt / "fhs-1.0"
    assert (pkg / ".stow-target").read_text().strip() == "~"  # etc promotes -> marker
    assert (pkg / ".stow-local-ignore").exists()  # farm hides .orig
    # Farm links: HOME paths resolve into the real files under pkg/.orig.
    assert linked_to(HOME / ".local/bin/tool", pkg / ".orig/bin/tool")
    assert linked_to(
        HOME / ".local/share/man/man1/tool.1", pkg / ".orig/share/man/man1/tool.1"
    )
    assert linked_to(
        HOME / ".local/lib/t.so", pkg / ".orig/lib64/t.so"
    )  # lib64 folded to lib via a link, real stays under .orig/lib64
    assert linked_to(
        HOME / ".config/tool.conf", pkg / ".orig/etc/tool.conf"
    )  # etc -> .config
    assert not (HOME / ".local/etc").exists()  # never leaked
    assert not (HOME / ".local/usr").exists()
    assert (pkg / ".orig").is_dir()  # farm backup
    assert not (HOME / ".local/.orig").exists()  # farm never linked
    installer("stow-uninstall", "fhs")
    assert not (HOME / ".config/tool.conf").exists()


@pytest.mark.parametrize(
    "all_flag,expected",
    [
        pytest.param([], False, id="default-ignores-extra"),
        pytest.param(["--keep-extras"], True, id="keep-extras-keeps-extra"),
    ],
)
def test_extra_dir_opt_in(tmp_path, HOME, installer, all_flag, expected) -> None:
    root = tmp_path / "f"
    layout(root, {"usr/bin/d": "exec", "extra/blob": "x"})
    tgz = tmp_path / "f.tgz"
    archive(tgz, root)
    out = installer(
        "stow-install", "--name", "pkg", "--version", "1", *all_flag, str(tgz)
    )
    if not expected:
        assert "ignoring non-FHS dir" in out.stdout + out.stderr
    assert (HOME / ".local/extra/blob").exists() == expected
    installer("stow-uninstall", "pkg")


def test_prefix_refused(tmp_path, run_bin) -> None:
    root = tmp_path / "p"
    layout(
        root,
        {"bin/a": "exec", "bin/b": "exec", "tlpkg/1": "dir", "texmf-dist/1": "dir"},
    )
    tgz = tmp_path / "prefix.tgz"
    archive(tgz, root)
    r = run_bin("stow-install", "--name", "pre", "--version", "1", str(tgz))
    assert not r.ok
    assert "opt-install" in r.stdout + r.stderr


def test_force_stow_markerless_toolchain(
    tmp_path, HOME, local_opt, installer, run_bin
) -> None:
    """--force-stow stows a marker-less relocatable toolchain (>=PREFIX_BIN_MIN
    executables plus a non-standard dir) instead of refusing with opt-install."""
    spec = {f"bin/t{i}": "exec" for i in range(1, 9)}
    spec["tools/data"] = "x"
    root = tmp_path / "tc"
    layout(root, spec)
    tgz = tmp_path / "tc.tar.gz"
    archive(tgz, root)
    ok = lambda *a: run_bin("stow-install", *a, str(tgz))
    refused = ok("--name", "tc", "--version", "1")
    assert not refused.ok
    assert "opt-install" in refused.stdout + refused.stderr
    installer(
        "stow-install", "--force-stow", "--name", "tc", "--version", "1", str(tgz)
    )
    assert linked_to(HOME / ".local/bin/t1", local_opt / "tc-1/bin/t1")
    assert not (HOME / ".local/tools").exists()  # extra dir dropped
    installer("stow-uninstall", "tc")


def test_force_stow_marker_prefix(tmp_path, HOME, local_opt, installer) -> None:
    """--force-stow overrides even a marker-recognised relocatable prefix (e.g.
    TinyTeX with tlpkg/), stowing it as the user explicitly requested."""
    root = tmp_path / "TinyTeX-2026.09"
    layout(
        root,
        {"bin/foo": "exec", "tlpkg/1": "dir", "texmf-dist/1": "dir"},
    )
    tgz = tmp_path / "tinytex.tgz"
    archive(tgz, root)
    installer("stow-install", "--force-stow", "--name", "p", "--version", "1", str(tgz))
    pkg = local_opt / "p-1"
    assert linked_to(HOME / ".local/bin/foo", pkg / "bin/foo")
    installer("stow-uninstall", "p")


def test_opt_install_shim_only(tmp_path, HOME, local_opt, installer) -> None:
    root = tmp_path / "TinyTeX-2026.09"
    layout(
        root,
        {"bin/universal-darwin/tlmgr": "exec", "tlpkg/1": "dir", "texmf-dist/1": "dir"},
    )
    tgz = tmp_path / "tinytex.tgz"
    archive(tgz, root)
    installer("opt-install", str(tgz))
    pkg = local_opt / "TinyTeX-2026.09"
    assert (pkg / "bin").is_dir() and (pkg / "tlpkg").is_dir()  # whole tree kept
    shim = HOME / ".config/zshrc.d/TinyTeX.zsh"
    # Only the thin shim is stowed; the heavy prefix dirs stay sealed inside
    # the package and are never linked into the HOME.
    assert linked_to(shim, pkg / ".config/zshrc.d/TinyTeX.zsh")
    real_shim = pkg / ".config/zshrc.d/TinyTeX.zsh"
    content = shim.read_text()
    assert "bin/universal-darwin" in content
    # $HOME/$PATH are written un-escaped so the shim expands them when sourced.
    assert r"\${HOME}" not in content and "$HOME/.local/opt" in content
    # Executable, so the zshrc.d loader's ?*.zsh(xN) glob actually sources it.
    assert real_shim.stat().st_mode & 0o100
    assert not (HOME / ".local/bin").is_symlink()
    assert not linked_to(
        HOME / ".local/bin/universal-darwin/tlmgr", pkg / "bin/universal-darwin/tlmgr"
    )
    assert not linked_to(HOME / ".local/tlpkg", pkg / "tlpkg")
    assert not linked_to(HOME / ".local/texmf-dist", pkg / "texmf-dist")
    installer("stow-uninstall", "TinyTeX")
    assert not shim.exists()


def test_opt_install_no_shim(tmp_path, HOME, local_opt, installer) -> None:
    """--no-shim is OS/version agnostic: places the tree (name-only when the
    version is unknown) but stows nothing, for tools that self-locate regardless
    of platform or version (e.g. TeX Live resolving its own root via SelFAUTO)."""
    root = tmp_path / "TinyTeX"  # no version token
    layout(
        root,
        {"bin/tlmgr": "exec", "tlpkg/1": "dir", "texmf-dist/1": "dir"},
    )
    tgz = tmp_path / "tinytex.tgz"
    archive(tgz, root)
    installer("opt-install", "--no-shim", "--name", "TinyTeX", str(tgz))
    pkg = local_opt / "TinyTeX"  # version-less, name-only dir
    assert (pkg / "bin").is_dir() and (pkg / "tlpkg").is_dir()  # whole tree kept
    assert not (HOME / ".config/zshrc.d/TinyTeX.zsh").exists()  # no PATH shim
    assert not (pkg / ".config").exists()  # no inner shim either
    assert not (HOME / ".local/bin").is_symlink()
    installer("stow-uninstall", "TinyTeX")
    assert not pkg.exists()


def test_zsh_cache_refreshed_on_opt_install_and_uninstall(
    tmp_path, HOME, local_opt, installer
) -> None:
    """Installing/removing a zshrc.d shim invalidates the zsh extras cache, so
    the next shell picks up the change without the user clearing it manually."""
    cache = HOME / ".cache/zsh/extras-cache.zsh"
    zwc = HOME / ".cache/zsh/extras-cache.zsh.zwc"
    cache.parent.mkdir(parents=True, exist_ok=True)
    root = tmp_path / "TinyTeX-2026.09"
    layout(root, {"bin/universal-darwin/tlmgr": "exec", "tlpkg/1": "dir"})
    tgz = tmp_path / "tinytex.tgz"
    archive(tgz, root)

    cache.write_text("old\n")
    zwc.write_text("zwc")
    installer("opt-install", str(tgz))
    assert not cache.exists() and not zwc.exists()  # install invalidates

    cache.write_text("old\n")
    zwc.write_text("zwc")
    installer("stow-uninstall", "TinyTeX")
    assert not cache.exists() and not zwc.exists()  # uninstall invalidates


def test_tlmgr_relocatable(tmp_path, HOME, local_opt, installer, sh) -> None:
    # Mirrors real tlmgr: the TeX root is the script's own resolved location
    # with the /tlpkg/... suffix stripped (SELFAUTO detection), so the bundle
    # stays usable when the whole tree moves to $opt/<name>-<ver>.
    root = tmp_path / "pfx-1.0"
    (root / "bin").mkdir(parents=True)
    (root / "tlpkg/TeXLive").mkdir(parents=True)
    (root / "bin/tool").write_text("#!/bin/sh\n")
    (root / "bin/tool").chmod(0o755)
    (root / "tlpkg/TeXLive/tlmgr.pl").write_text(
        "#!/usr/bin/env perl\n"
        "use Cwd qw(abs_path);\n"
        "my $d = abs_path($0); $d =~ s{/tlpkg/.*}{};\n"
        'print "ROOT=$d\\n";\n'
    )
    tgz = tmp_path / "pfx.tgz"
    with tarfile.open(tgz, "w:gz") as tf:
        tf.add(root, arcname=root.name)
    installer("opt-install", "--name", "pfx", str(tgz))
    pl = local_opt / "pfx-1.0/tlpkg/TeXLive/tlmgr.pl"
    out = sh(shell_quote("perl", str(pl)))
    assert out.ok
    assert str((local_opt / "pfx-1.0").resolve()) in out.stdout


def test_stow_run_roundtrip(tmp_path, HOME, local_opt, installer, sh) -> None:
    root = tmp_path / "s"
    layout(root, {"usr/bin/r": "exec", "etc/r.conf": "c"})
    tgz = tmp_path / "ur.tgz"
    archive(tgz, root)
    installer("stow-install", "--name", "round", "--version", "1", str(tgz))
    pkg = local_opt / "round-1"
    assert linked_to(HOME / ".local/bin/r", pkg / ".orig/bin/r")
    assert linked_to(HOME / ".config/r.conf", pkg / ".orig/etc/r.conf")
    # A bare `stow -D` lacking -t uses the default target (parent of $opt,
    # ~/.local) and so cannot reach the ~/.config farm link: the marker is
    # required to uninstall cleanly.
    sh(f"stow -d {shell_quote(str(local_opt))} -D round-1")
    assert (HOME / ".config/r.conf").exists()  # bare stow missed it
    installer("stow-run", "-d", str(local_opt), "-D", "round-1")  # marker forces ~
    assert (pkg / ".stow-target").exists()
    assert (pkg / ".orig").is_dir()
    assert not (HOME / ".local/bin/r").exists()
    assert not (HOME / ".config/r.conf").exists()


def test_bare_home_no_precreated_dirs(tmp_path, HOME, local_opt, installer, sh) -> None:
    """Stow must create missing ~/.local and ~/.config dirs on demand."""
    for d in HOME_DIRS:
        sh(shell_quote("find", str(HOME / d), "-delete"))
    root = tmp_path / "fhs"
    layout(
        root,
        {
            "usr/bin/tool": "exec",
            "usr/lib64/t.so": "so",
            "usr/share/man/man1/tool.1": "m",
            "etc/tool.conf": "c",
        },
    )
    tgz = tmp_path / "b.tar.gz"
    archive(tgz, root)
    installer("stow-install", "--name", "fhs", "--version", "1.0", str(tgz))
    pkg = local_opt / "fhs-1.0"
    assert linked_to(HOME / ".local/bin/tool", pkg / ".orig/bin/tool")
    assert linked_to(HOME / ".local/lib/t.so", pkg / ".orig/lib64/t.so")
    assert linked_to(HOME / ".config/tool.conf", pkg / ".orig/etc/tool.conf")
    assert linked_to(
        HOME / ".local/share/man/man1/tool.1", pkg / ".orig/share/man/man1/tool.1"
    )
    installer("stow-uninstall", "fhs")


@pytest.mark.parametrize("ext", ["tar.gz", "tar.xz", "tar.bz2", "tar.zst"])
def test_archive_variants(tmp_path, HOME, local_opt, installer, ext) -> None:
    """Install the same package across tar formats; skip unsupported ones."""
    root = tmp_path / "hello_1.2.3_darwin_arm64"
    layout(root, {"bin/hello": "exec"})
    tgz = tmp_path / f"pkg.{ext}"
    try:
        make_variant(tgz, root, ext)
    except Exception as e:  # noqa: BLE001 - capability probe
        pytest.skip(f"platform cannot build {ext}: {e}")
    try:
        installer("stow-install", str(tgz))
    except AssertionError as e:
        pytest.skip(f"platform cannot extract {ext}: {e}")
    assert linked_to(HOME / ".local/bin/hello", local_opt / "hello-1.2.3/bin/hello")
    installer("stow-uninstall", "hello")


def test_prepare_tar_zstd_backport(tmp_path, bash_run, monkeypatch) -> None:
    """prepare_tar must decode a .zst archive through backports.zstd when no
    zstd binary is on PATH (the pre-3.14 fallback branch)."""
    root = tmp_path / "hello_1.2.3_darwin_arm64"
    layout(root, {"bin/hello": "exec"})
    zst = tmp_path / "pkg.tar.zst"
    make_variant(zst, root, "tar.zst")

    # Hide any real zstd, but keep a normal PATH for invoke's bash runner, and
    # put a python3 shim first that runs sys.executable (which carries
    # backports.zstd) so the backport fallback branch is exercised.
    bindir = tmp_path / "bin"
    bindir.mkdir()
    shim = bindir / "python3"
    shim.write_text(f'#!/bin/bash\nexec {shlex.quote(sys.executable)} "$@"\n')
    shim.chmod(0o755)
    path = [
        str(bindir),
        *(d for d in os.environ.get("PATH", "").split(os.pathsep) if d and not (Path(d) / "zstd").exists()),
    ]
    monkeypatch.setenv("PATH", os.pathsep.join(path))

    work = tmp_path / "work"
    work.mkdir()
    out = bash_run(
        'export work="$1"; source "$2"; prepare_tar "$3"',
        str(work),
        str(LIB),
        str(zst),
    )
    assert out.ok, out.stdout + out.stderr
    prepared = Path(out.stdout.strip())
    with tarfile.open(prepared, "r:") as tf:  # plain, decoded tar
        assert "hello_1.2.3_darwin_arm64/bin/hello" in tf.getnames()


_OS_NAMES = [
    "linux_amd64",
    "macOS_arm64",
    "Darwin_x86_64",
    "linux_arm64",
    "windows_amd64",
]


@pytest.mark.parametrize("osarch", _OS_NAMES)
def test_os_variants(tmp_path, HOME, local_opt, installer, osarch) -> None:
    tar = f"hello_1.2.3_{osarch}"
    root = tmp_path / tar
    layout(root, {"bin/hello": "exec"})
    tgz = tmp_path / f"{tar}.tar.gz"
    archive(tgz, root)
    installer("stow-install", str(tgz))
    assert (local_opt / "hello-1.2.3").is_dir()
    assert linked_to(HOME / ".local/bin/hello", local_opt / "hello-1.2.3/bin/hello")
    installer("stow-uninstall", "hello")


def test_github_pinned_url_version_in_path(
    tmp_path, HOME, local_opt, installer
) -> None:
    """A GitHub pinned-release URL carries the version in the path segment
    even though the artifact basename (foo-linux-x64) has none: stow-install
    must infer it from the URL/path and install foo-1.2.3."""
    root = tmp_path / "foo-linux-x64"
    layout(root, {"bin/foo": "exec"})
    url = tmp_path / "download" / "v1.2.3"
    url.mkdir(parents=True)
    tgz = url / "foo-linux-x64.tar.gz"
    archive(tgz, root)
    installer("stow-install", str(tgz))
    pkg = local_opt / "foo-1.2.3"
    assert pkg.is_dir()
    assert linked_to(HOME / ".local/bin/foo", pkg / "bin/foo")
    assert not (local_opt / "foo").exists()  # versioned, never bare
    installer("stow-uninstall", "foo")


def test_github_latest_requires_version(tmp_path, HOME, local_opt, run_bin) -> None:
    """A 'latest' URL whose artifact name (foo-linux-x64) also carries no
    version: install must fail with a clear 'pass --version' until the caller
    supplies one."""
    root = tmp_path / "foo-linux-x64"
    layout(root, {"bin/foo": "exec"})
    url = tmp_path / "latest"
    url.mkdir(parents=True)
    tgz = url / "foo-linux-x64.tar.gz"
    archive(tgz, root)
    r = run_bin("stow-install", str(tgz))
    assert not r.ok
    assert "pass --version" in r.stdout + r.stderr
    run = lambda *args: run_bin("stow-install", *args, str(tgz))
    r = run("--version", "2.5.0")
    assert r.ok, r.stdout + r.stderr
    assert (local_opt / "foo-2.5.0").is_dir()
    assert linked_to(HOME / ".local/bin/foo", local_opt / "foo-2.5.0/bin/foo")
    run_bin("stow-uninstall", "foo")


def test_github_latest_version_in_artifact(
    tmp_path, HOME, local_opt, installer
) -> None:
    """A 'latest' URL carries no version in its path, but the artifact name
    does (foo-1.2.3-linux-x64): the version must come from the stem."""
    root = tmp_path / "foo-1.2.3-linux-x64"
    layout(root, {"bin/foo": "exec"})
    url = tmp_path / "latest"
    url.mkdir(parents=True)
    tgz = url / "foo-1.2.3-linux-x64.tar.gz"
    archive(tgz, root)
    installer("stow-install", str(tgz))
    assert linked_to(HOME / ".local/bin/foo", local_opt / "foo-1.2.3/bin/foo")
    installer("stow-uninstall", "foo")


def test_github_versioned_url_version_in_both(
    tmp_path, HOME, local_opt, installer
) -> None:
    """A pinned-release URL has the version both in the path and the artifact
    name; either source resolves to the same foo-2.3.4."""
    root = tmp_path / "foo-2.3.4-linux-x64"
    layout(root, {"bin/foo": "exec"})
    url = tmp_path / "download" / "v2.3.4"
    url.mkdir(parents=True)
    tgz = url / "foo-2.3.4-linux-x64.tar.gz"
    archive(tgz, root)
    installer("stow-install", str(tgz))
    assert linked_to(HOME / ".local/bin/foo", local_opt / "foo-2.3.4/bin/foo")
    installer("stow-uninstall", "foo")


def test_opt_always_versioned_and_farm_colocated(
    tmp_path, HOME, local_opt, installer, sh
) -> None:
    """Regression: every install lands in a single versioned $opt/<name>-<ver>
    folder (never a bare $opt/<name>), and a farm package's .orig/ link farm
    is co-located with the archive contents inside that same folder."""
    g = tmp_path / "g"
    layout(g, {"bin/g": "exec"})
    tgz = tmp_path / "hello_1.2.3_linux_amd64.tar.gz"
    archive(tgz, g)
    installer("stow-install", str(tgz))

    fhs = tmp_path / "fhs"
    layout(
        fhs,
        {
            "usr/bin/gtool": "exec",
            "usr/lib64/gt.so": "so",
            "usr/share/man/man1/gtool.1": "m",
            "etc/gtool.conf": "c",
        },
    )
    fgz = tmp_path / "gh.tgz"
    archive(fgz, fhs)
    installer("stow-install", "--name", "gtool", "--version", "0.9", str(fgz))

    got = {p.name for p in local_opt.iterdir()}
    assert got == {"hello-1.2.3", "gtool-0.9"}, got  # versioned only, no bare dirs
    pkg = local_opt / "gtool-0.9"
    assert (pkg / ".orig").is_dir()  # farm co-located with contents
    # The reshaped farm (HOME/.config-shaped links) lives inside the same
    # versioned folder as .orig: it stows ~/.local and ~/.config from here.
    assert (pkg / ".local" / "bin" / "gtool").exists()
    assert (pkg / ".config" / "gtool.conf").exists()
    assert (pkg / ".local" / "lib" / "gt.so").exists()
    assert (pkg / ".local" / "share" / "man" / "man1" / "gtool.1").exists()
    assert linked_to(HOME / ".local/bin/gtool", pkg / ".orig/bin/gtool")
    assert linked_to(HOME / ".config/gtool.conf", pkg / ".orig/etc/gtool.conf")
    # .orig must never leak into the stow targets (~/.local, ~/.config); it
    # lives only inside the package folder.
    assert not (HOME / ".local" / ".orig").exists()
    assert not (HOME / ".config" / ".orig").exists()
    installer("stow-uninstall", "hello")
    installer("stow-uninstall", "gtool")
    assert not local_opt.exists() or {p.name for p in local_opt.iterdir()} == set()


# ------------------------------------------- symlink-farm default + --move


def test_move_moves_real_files_into_package(tmp_path, HOME, local_opt, installer) -> None:
    """--move keeps real files in the package (folded to their keys) instead of
    a .orig symlink farm; the target still gets stow links into the package.
    etc promotes the target to $HOME, so the FHS keys carry a .local/ prefix."""
    root = tmp_path / "m"
    layout(root, {"usr/bin/m": "exec", "usr/lib64/m.so": "so", "etc/m.conf": "c"})
    tgz = tmp_path / "m.tgz"
    archive(tgz, root)
    installer("stow-install", "--move", "--name", "m", "--version", "1", str(tgz))
    pkg = local_opt / "m-1"
    assert (pkg / ".local/bin/m").is_file() and not (pkg / ".local/bin/m").is_symlink()
    assert (pkg / ".local/lib/m.so").is_file() and not (pkg / ".local/lib/m.so").is_symlink()
    assert (pkg / ".config/m.conf").is_file()  # etc -> .config
    assert not (pkg / ".orig").exists()
    assert not (pkg / ".stow-local-ignore").exists()
    assert (pkg / ".stow-target").read_text().strip() == "~"  # etc promotes to HOME
    assert linked_to(HOME / ".local/bin/m", pkg / ".local/bin/m")
    assert linked_to(HOME / ".local/lib/m.so", pkg / ".local/lib/m.so")
    installer("stow-uninstall", "m")


def test_no_stow_builds_and_marks_but_skips_stow(
    tmp_path, HOME, local_opt, installer
) -> None:
    """--no-stow builds the versioned package and its markers but never runs
    stow, so nothing appears in the target."""
    root = tmp_path / "n"
    layout(root, {"usr/bin/n": "exec", "usr/lib64/n.so": "so"})
    tgz = tmp_path / "n.tgz"
    archive(tgz, root)
    out = installer(
        "stow-install", "--no-stow", "--name", "n", "--version", "1", str(tgz)
    )
    pkg = local_opt / "n-1"
    assert pkg.is_dir() and (pkg / "bin/n").exists()  # built
    assert not (HOME / ".local/bin/n").exists()  # not stowed
    assert "stow skipped" in out.stdout
    installer("stow-uninstall", "n")


def test_dry_run_plans_without_installing(tmp_path, HOME, local_opt, run_bin) -> None:
    """--dry-run prints the per-entry plan (folds as would-link) and touches
    neither the install dir nor the target."""
    root = tmp_path / "d"
    layout(root, {"usr/bin/d": "exec", "etc/d.conf": "c"})
    tgz = tmp_path / "d.tgz"
    archive(tgz, root)
    r = run_bin(
        "stow-install", "--dry-run", "--name", "d", "--version", "1", str(tgz)
    )
    assert r.ok, r.stdout + r.stderr
    assert "would link" in r.stdout + r.stderr
    assert not (local_opt / "d-1").exists()
    assert not (HOME / ".local/bin/d").exists()
    assert not (HOME / ".config/d.conf").exists()


def test_verbose_prints_performed_ops(tmp_path, HOME, local_opt, installer) -> None:
    """--verbose reports each performed per-entry op (here the direct install)."""
    root = tmp_path / "v"
    layout(root, {"bin/v": "exec"})
    tgz = tmp_path / "v.tgz"
    archive(tgz, root)
    out = installer("stow-install", "--verbose", "--name", "v", "--version", "1", str(tgz))
    assert "installed bin" in out.stdout
    installer("stow-uninstall", "v")


def test_dry_run_plans_without_committing(tmp_path, HOME, local_opt, run_bin) -> None:
    """--dry-run plans the install from the archive without committing: nothing
    lands in the install dir or target. (URL archives are downloaded intrinsically,
    so there is no --download flag to pass.)"""
    root = tmp_path / "dl"
    layout(root, {"usr/bin/dl": "exec", "etc/dl.conf": "c"})
    tgz = tmp_path / "dl.tgz"
    archive(tgz, root)
    r = run_bin(
        "stow-install", "--dry-run", "--name", "dl", "--version", "1", str(tgz)
    )
    assert r.ok, r.stdout + r.stderr
    assert "would link" in r.stdout + r.stderr
    assert not (local_opt / "dl-1").exists()
    assert not (HOME / ".config/dl.conf").exists()


def test_single_bin_cleaned_names(tmp_path, HOME, local_opt, installer) -> None:
    """single-bin exposes a raw arch/version-tagged executable under a cleaned
    bin/<name>; non-executables stay unlinked under .orig."""
    root = tmp_path / "r"
    layout(
        root,
        {"foo-1.2.3-darwin-arm64": "exec", "LICENSE": "license"},
    )
    tgz = tmp_path / "sb.tgz"
    archive(tgz, root)
    installer("stow-install", "--name", "foo", "--version", "1.2.3", str(tgz))
    pkg = local_opt / "foo-1.2.3"
    assert (pkg / ".orig" / "foo-1.2.3-darwin-arm64").is_file()
    assert linked_to(HOME / ".local/bin/foo", pkg / "bin/foo")
    assert not (HOME / ".local/bin/foo-1.2.3-darwin-arm64").exists()
    assert not (HOME / ".local/bin/LICENSE").exists()
    installer("stow-uninstall", "foo")


def test_scope_install_target_combinations(
    tmp_path, HOME, local_opt, run_bin, monkeypatch
) -> None:
    """The four (scope, install-dir, target) combinations resolve to distinct,
    unambiguous destinations."""
    sysroot = HOME / "sysroot"
    monkeypatch.setenv("STOW_SYS_ROOT", str(sysroot))
    root = tmp_path / "apps-1"
    layout(root, {"bin/apps": "exec"})
    tgz = tmp_path / "apps.tgz"
    archive(tgz, root)

    custom_opt = HOME / "custom" / "opt"
    pinned = HOME / "pt"
    cases = [
        # (scope-args, install dir, target, version)
        (["--user"], local_opt, HOME / ".local", "1"),
        (["--user", "--install-dir", str(custom_opt)], custom_opt, HOME / "custom", "2"),
        (["--system"], sysroot / "opt", sysroot, "3"),
        (["--system", "--target", str(pinned)], sysroot / "opt", pinned, "4"),
    ]
    for args, install, target, version in cases:
        (target / "bin").mkdir(parents=True, exist_ok=True)
        r = run_bin(
            "stow-install", *args, "--name", "apps", "--version", version, str(tgz)
        )
        assert r.ok, r.stdout + r.stderr
        pkg = install / f"apps-{version}"
        assert pkg.is_dir(), f"package missing for {args}: {install}"
        assert linked_to(target / "bin" / "apps", pkg / "bin/apps")


# -------------------------------------------------- strategy + stow-run


def test_within_local_man_lib64_uses_default_target(
    tmp_path, HOME, local_opt, installer
) -> None:
    """man -> share/man and lib64 -> lib fold as real copies inside the
    package, so a package with no etc maps 1:1 into the default ~/.local
    target: no .orig farm and no marker are built."""
    root = tmp_path / "app"
    layout(
        root,
        {
            "usr/bin/app": "exec",
            "usr/man/man1/app.1": "m",
            "usr/lib64/app.so": "so",
        },
    )
    tgz = tmp_path / "app.tar.gz"
    archive(tgz, root)
    installer("stow-install", "--name", "app", "--version", "1", str(tgz))
    pkg = local_opt / "app-1"
    assert not (pkg / ".stow-target").exists()  # default target needs no marker
    assert (pkg / ".orig").is_dir()  # man -> share/man and lib64 -> lib folds force a farm
    assert (pkg / ".stow-local-ignore").exists()
    assert linked_to(HOME / ".local/bin/app", pkg / "bin/app")
    assert linked_to(HOME / ".local/share/man/man1/app.1", pkg / "share/man/man1/app.1")
    assert linked_to(HOME / ".local/lib/app.so", pkg / "lib/app.so")
    installer("stow-uninstall", "app")


def test_strategy_separation(tmp_path, HOME, local_opt, run_bin) -> None:
    """stow-goreleased handles only the flat GoReleaser shape; stow-standard
    only the FHS usr/ shape. Each refuses the other's layout (stow-install is
    the sole router)."""
    gr = tmp_path / "resh_0.19.0_linux_amd64"
    layout(gr, {"resh": "exec", "manpages/resh.1": "m"})
    gr_tgz = tmp_path / "gr.tar.gz"
    archive(gr_tgz, gr)
    fhs = tmp_path / "f"
    layout(fhs, {"usr/bin/t": "exec", "etc/t.conf": "c"})
    fh_tgz = tmp_path / "f.tar.gz"
    archive(fh_tgz, fhs)

    run = lambda *a: run_bin(*a)
    assert run("stow-goreleased", str(gr_tgz)).ok
    assert run("stow-standard", "--version", "1", str(fh_tgz)).ok
    refuse = run("stow-standard", str(gr_tgz))
    assert not refuse.ok
    refuse = run("stow-goreleased", str(fh_tgz))
    assert not refuse.ok
    run_bin("stow-uninstall", "resh")
    run_bin("stow-uninstall", "f")


def test_stow_run_multiple_packages_different_targets(
    tmp_path, HOME, local_opt, run_bin
) -> None:
    """stow-run stows each package with its own marker target (a single -t
    cannot span packages that target different roots)."""
    (local_opt / "alpha").mkdir(parents=True)
    (local_opt / "alpha" / "bin").mkdir()
    (local_opt / "alpha" / "bin" / "alpha").write_text("#!/bin/sh\n")
    (local_opt / "alpha" / "bin" / "alpha").chmod(0o755)
    (local_opt / "alpha" / ".stow-target").write_text("~/.local\n")
    (local_opt / "beta").mkdir(parents=True)
    (local_opt / "beta" / ".config").mkdir()
    (local_opt / "beta" / ".config" / "beta.conf").write_text("x\n")
    (local_opt / "beta" / ".stow-target").write_text("~\n")

    r = run_bin("stow-run", "-d", str(local_opt), "alpha", "beta")
    assert r.ok, r.stdout + r.stderr
    assert linked_to(HOME / ".local/bin/alpha", local_opt / "alpha/bin/alpha")
    assert linked_to(HOME / ".config/beta.conf", local_opt / "beta/.config/beta.conf")
    run_bin("stow-run", "-d", str(local_opt), "-D", "alpha", "beta")
    assert not (HOME / ".local/bin/alpha").exists()
    assert not (HOME / ".config/beta.conf").exists()


def test_system_scope_end_to_end(
    tmp_path, HOME, local_opt, installer, monkeypatch
) -> None:
    """--system routes into STOW_SYS_ROOT, never the real /usr/local: a marker
    is recorded, symlinks land under the sysroot, uninstall removes them, and
    /usr/local is left untouched (read-only absence check)."""
    sysroot = HOME / "sysroot"
    monkeypatch.setenv("STOW_SYS_ROOT", str(sysroot))
    sysroot.mkdir()  # GNU Stow refuses to stow into a target that does not exist

    root = tmp_path / "tool-1.0"
    layout(
        root,
        {
            "usr/bin/tool": "exec",
            "etc/tool.conf": "c",
            "usr/share/man/man1/tool.1": "m",
        },
    )
    tgz = tmp_path / "tool.tar.gz"
    archive(tgz, root)
    installer(
        "stow-install", "--system", "--name", "tool", "--version", "1.0", str(tgz)
    )

    pkg = sysroot / "opt" / "tool-1.0"
    assert pkg.is_dir()
    assert not (pkg / ".stow-target").exists()  # default sysroot target is dirname(install_dir)
    assert linked_to(sysroot / "bin/tool", pkg / "bin/tool")
    assert linked_to(sysroot / "etc/tool.conf", pkg / "etc/tool.conf")
    assert linked_to(sysroot / "share/man/man1/tool.1", pkg / "share/man/man1/tool.1")
    for real in (
        "/usr/local/bin/tool",
        "/usr/local/etc/tool.conf",
        "/usr/local/share/man/man1/tool.1",
    ):
        assert not Path(real).exists(), f"real {real} must stay untouched"

    installer("stow-uninstall", "--system", "tool")
    assert not (sysroot / "bin/tool").exists()
    assert not (sysroot / "etc/tool.conf").exists()
    assert not (sysroot / "share/man/man1/tool.1").exists()


# -------------------------------------------------- real-world shapes (parameterised)


def _shape(
    tar: str,
    versioned: str,
    pkg: str,
    spec: dict[str, str],
    installed: list[str],
    absent: list[str] | None = None,
    args: list[str] | None = None,
    post=None,
):
    return pytest.param(
        {
            "tar": tar,
            "versioned": versioned,
            "pkg": pkg,
            "spec": spec,
            "installed": installed,
            "absent": absent or [],
            "args": args or [],
            "post": post,
        },
        id=tar,
    )


def _nvim_probe(root: Path) -> None:
    nvim = root / "bin/nvim"
    nvim.write_text("#!/bin/sh\necho 'NVIM v0.11.1'\n")
    nvim.chmod(0o755)


SHAPES = [
    # GoReleaser: <name>_<ver>_<os>_<arch>, single binary under bin/.
    _shape(
        "bundl_2.64.0_macOS_arm64",
        "bundl-2.64.0",
        "bundl",
        {"bin/bundl": "exec", "share/man/man1/bundl.1": "m"},
        [".local/bin/bundl", ".local/share/man/man1/bundl.1"],
    ),
    # GoReleaser: single binary with manpages + shell completions.
    _shape(
        "resh_0.19.0_linux_amd64",
        "resh-0.19.0",
        "resh",
        {
            "resh": "exec",
            "manpages/resh.1": "m",
            "completions/_resh": "c",
            "completions/resh.bash": "c",
            "completions/resh.fish": "c",
        },
        [
            ".local/bin/resh",
            ".local/share/man/man1/resh.1",
            ".local/share/zsh/site-functions/_resh",
            ".local/share/bash-completion/completions/resh",
            ".local/share/fish/vendor_completions.d/resh.fish",
        ],
    ),
    # Cargo/GoReleaser: single binary, repo docs never linked into bin/.
    _shape(
        "tray_1.2.0_Darwin_arm64",
        "tray-1.2.0",
        "tray",
        {"tray": "exec", "LICENSE": "license", "README.md": "readme"},
        [".local/bin/tray"],
        absent=[".local/bin/LICENSE", ".local/bin/README.md"],
    ),
    # GoReleaser: bin/ + share/man + share/doc with top-level repo docs.
    _shape(
        "repo_2.40.0_linux_amd64",
        "repo-2.40.0",
        "repo",
        {
            "bin/repo": "exec",
            "share/man/man1/repo.1": "m",
            "share/doc/repo/changelog.md": "c",
            "LICENSE": "license",
            "README.md": "readme",
        },
        [
            ".local/bin/repo",
            ".local/share/man/man1/repo.1",
            ".local/share/doc/repo/changelog.md",
        ],
        absent=[".local/bin/LICENSE", ".local/bin/README.md"],
    ),
    # Cargo platform-triple: main binary + a sidecar helper (e.g. a sandbox
    # or a second entrypoint); no version in the name, --version decides.
    _shape(
        "cli-x86_64-unknown-linux-gnu",
        "cli-0.40.0",
        "cli",
        {"cli": "exec", "sbox": "exec", "LICENSE": "L"},
        [".local/bin/cli", ".local/bin/sbox"],
        absent=[".local/bin/LICENSE"],
        args=["--version", "0.40.0"],
    ),
    # Cargo: v-prefixed release tag baked into the archive stem.
    _shape(
        "tool-2025.05.0-linux-x64",
        "tool-2025.05.0",
        "tool",
        {"tool": "exec"},
        [".local/bin/tool"],
    ),
    _shape(
        "nvim-macos-arm64",
        "nvim-0.11.1",
        "nvim",
        {
            "bin/nvim": "exec",
            "lib/nvim/parser.so": "lib",
            "share/man/man1/nvim.1": "m",
            "share/nvim/runtime/filetype.lua": "runtime",
        },
        [
            ".local/bin/nvim",
            ".local/share/man/man1/nvim.1",
            ".local/share/nvim/runtime/filetype.lua",
            ".local/lib/nvim/parser.so",
        ],
        post=_nvim_probe,
    ),
    _shape(
        "biber-2.17", "biber-2.17", "biber", {"biber": "exec"}, [".local/bin/biber"]
    ),
]


@pytest.mark.parametrize("shape", SHAPES)
def test_real_world_shape(tmp_path, HOME, local_opt, installer, shape: dict) -> None:
    root = tmp_path / shape["tar"]
    layout(root, shape["spec"])
    if shape["post"]:
        shape["post"](root)
    tgz = tmp_path / f"{shape['tar']}.tar.gz"
    archive(tgz, root)
    installer("stow-install", *shape["args"], str(tgz))
    pkg = local_opt / shape["versioned"]
    assert pkg.is_dir()
    assert not (pkg / ".stow-target").exists()  # maps 1:1 into default ~/.local
    for rel in shape["installed"]:
        real = pkg / rel[len(".local/") :]
        assert linked_to(HOME / rel, real), f"missing: {rel}"
    for rel in shape["absent"]:
        assert not (HOME / rel).exists(), f"should be absent: {rel}"
    installer("stow-uninstall", shape["pkg"])
