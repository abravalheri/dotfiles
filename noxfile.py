#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.9"
# dependencies = ["nox"]
# ///
"""Run the installer and stow-run suites with pytest from the repo root."""

import nox


@nox.session
def test(session: nox.Session) -> None:
    session.install(
        "pytest",
        "invoke",
        "pytest-xdist",
        'backports.zstd; python_version < "3.14"',
    )
    session.run("pytest", "tools.common/tests", "-n", "auto")


if __name__ == "__main__":
    from nox.__main__ import main

    main()
