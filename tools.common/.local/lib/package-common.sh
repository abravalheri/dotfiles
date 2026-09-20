#!/usr/bin/env bash
# Shared library for the dotfiles' layout-aware installers. Sourced (not run)
# by stow-install, stow-standard, stow-single-bin, and opt-install. Bash 3.2 /
# BSD + GNU compatible; no associative arrays.

PROG=${PROG:-${0##*/}}

die()    { printf '%s: error: %s\n' "$PROG" "$*" >&2; exit 1; }
inform() { printf '%s: error: %s\n' "$PROG" "$1" >&2; shift
           for l in "$@"; do printf '  %s\n' "$l" >&2; done; exit 1; }


# Portable full-path resolution (BSD readlink lacks -f).
resolve() {
    local target=$1 link dir
    while [ -L "$target" ]; do
        link=$(readlink "$target")
        case "$link" in
            /*) target=$link ;;
            *)  dir=${target%/*}; [ "$dir" = "$target" ] && dir=.
                target="$dir/$link" ;;
        esac
    done
    printf '%s\n' "$target"
}

# Load this library's own directory so sibling bash files can be resolved even
# through the ~/.local/bin symlinks.
LIB_DIR=$(dirname "$(resolve "${BASH_SOURCE[0]}")")

verify_checksum() {  # "$hash" "$file" -> 0 ok, 1 mismatch
    local want=$1 file=$2
    if command -v sha256sum >/dev/null 2>&1; then
        printf '%s  %s\n' "$want" "$file" | sha256sum -c - >/dev/null 2>&1
    elif command -v shasum >/dev/null 2>&1; then
        printf '%s  %s\n' "$want" "$file" | shasum -a 256 -c - >/dev/null 2>&1
    else
        die "sha256sum or shasum required for checksum verification"
    fi
}

auto_checksum() {  # "$url" "$basename" -> hash (or empty)
    local url=$1 base=$2 dir hash out c
    local -a candidates
    dir=${url%/*}
    candidates=("$url.sha256" "$url.sha256sum" "$dir/checksums.txt" "$dir/checksums.sha256")
    for c in "${candidates[@]}"; do
        out=$(curl -fsSL "$c" 2>/dev/null) || continue
        hash=$(printf '%s' "$out" | awk -v b="$base" '
            { for (i=2;i<=NF;i++){ f=$i; sub(/^\*/,"",f); if (f==b){ print $1; exit } } }')
        [ -n "$hash" ] || continue
        printf '%s\n' "$hash"; return 0
    done
    return 1
}

# First version-like token in a name. TinyTeX-darwin-v2026.09 -> 2026.09.
parse_version() {
    local s=$1 tok v
    IFS='-_/' read -ra toks <<< "$s"
    for tok in "${toks[@]}"; do
        v=${tok#[vV]}
        if [[ "$v" =~ ^[0-9]+\.[0-9]+(\.[0-9]+)?([._-][0-9A-Za-z]+)*$ ]]; then
            printf '%s\n' "$v"; return 0
        fi
    done
    return 1
}

# Strip trailing archive suffixes from a file/URL name to its bare stem.
archive_stem() {  # "$name" -> stem
    local s=$1 suf
    for suf in .tar.gz .tar.zst .tar.xz .tar.bz2 .tar .tgz .gz .zst .xz .bz2 .zip; do
        s=${s%"$suf"}
    done
    printf '%s\n' "$s"
}

# First version-like token in the archive/URL string, else in the wrapper dir
# name (a GitHub pinned-release URL carries the version in the path even when
# the artifact basename does not, e.g. .../releases/download/v1.2.3/foo-linux-x64).
infer_version() {  # "$archive_or_url" "$base" -> version (or empty)
    local a=$1 base=$2 s v
    s=$(archive_stem "$a")
    v=$(parse_version "$s" || true)
    [ -n "$v" ] || v=$(parse_version "$(basename "$base")" || true)
    printf '%s\n' "$v"
    [ -n "$v" ]
}

# Package name from the GoReleaser wrapper-dir convention, else the archive
# stem's first token (URL/filename detection only; no filesystem probing).
infer_name() {  # "$archive" "$base" -> prints name; 0 iff non-empty
    local dirname stem
    dirname=$(basename "$2")
    if [[ "$dirname" =~ ^([^_]+)_[0-9]+\.[0-9]+(\.[0-9]+)?_[^_]+_[^_]+$ ]]; then
        printf '%s\n' "${BASH_REMATCH[1]}"; return 0
    fi
    stem=$(archive_stem "$(basename "$1")")
    [ -n "$stem" ] || return 1
    printf '%s\n' "${stem%%[-_]*}"
}

# Read a dotted version from an executable's --version output.
probe_exe_version() {  # "$exe" -> prints version; 0 iff non-empty
    local out
    out=$("$1" --version 2>/dev/null || true)
    printf '%s\n' "$out" | grep -Eo '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n1
}

# First executable at the top level of a tree (GoReleaser / single-bin).
top_exe() {  # "$base" -> path (or empty)
    find "$1" -mindepth 1 -maxdepth 1 -type f -perm -u+x -print -quit 2>/dev/null
}

# First executable anywhere in a tree (single recursive probe).
first_exe() {  # "$base" -> path (or empty)
    find "$1" -type f -perm -u+x -print -quit 2>/dev/null
}

# Resolve a version: from the archive/URL name (shared, layout-independent),
# else from a layout hook that locates an executable whose --version we read.
# Hook is a function name applied to "$base"; defaults to a full-tree probe.
# Pass a layout hook to try something specific that is not derivable from the
# filename, e.g. top_exe for a flat GoReleaser/single-bin tree.
version_from() {  # "$archive" "$base" ["$hook"] -> prints version; 0 iff non-empty
    local archive=$1 base=$2 hook=${3:-first_exe} v exe
    v=$(infer_version "$archive" "$base" || true)
    if [ -z "$v" ] && command -v "$hook" >/dev/null 2>&1; then
        exe=$("$hook" "$base")
        [ -n "$exe" ] && v=$(probe_exe_version "$exe")
    fi
    printf '%s\n' "$v"
    [ -n "$v" ]
}

# Decompress .zst/.tzst into a plain tar when tar lacks zstd support.
prepare_tar() {  # "$archive" -> tar path; requires $work set by caller
    case "$1" in
        *.tar.zst|*.tzst)
            if command -v zstd >/dev/null 2>&1; then
                zstd -q -d -c "$1" > "$work/prepared.tar" 2>/dev/null || return 1
            elif command -v python3 >/dev/null 2>&1 && python3 -c 'import compression.zstd' >/dev/null 2>&1; then
                # stdlib on Python >=3.14
                python3 -c 'import sys, compression.zstd as z
sys.stdout.buffer.write(z.decompress(open(sys.argv[1], "rb").read()))' "$1" > "$work/prepared.tar" 2>/dev/null || return 1
            elif command -v python3 >/dev/null 2>&1 && python3 -c 'import backports.zstd' >/dev/null 2>&1; then
                # backports.zstd on Python <3.14
                python3 -c 'import sys, backports.zstd as z
sys.stdout.buffer.write(z.decompress(open(sys.argv[1], "rb").read()))' "$1" > "$work/prepared.tar" 2>/dev/null || return 1
            elif command -v python3 >/dev/null 2>&1 && python3 -c 'import zstandard' >/dev/null 2>&1; then
                # third-party zstandard package
                python3 -c 'import sys,zstandard
sys.stdout.buffer.write(zstandard.ZstdDecompressor().stream_reader(open(sys.argv[1],"rb")).read())' "$1" > "$work/prepared.tar" 2>/dev/null || return 1
            else
                return 1
            fi
            printf '%s\n' "$work/prepared.tar"
            ;;
        *) printf '%s\n' "$1" ;;
    esac
}

# Resolve an archive arg to a local path, downloading + checksum-verifying URLs.
resolve_archive() {  # "$archive-or-url" [checksum] ["$destdir"] -> prints local path
    local arg=$1 want=${2:-} destdir=${3:-$work} base local auto
    if [[ "$arg" =~ ^https?:// ]]; then
        command -v curl >/dev/null 2>&1 || die "a URL archive requires curl"
        base=$(basename "$arg"); local="$destdir/$base"
        curl -fsSL "$arg" -o "$local" || die "download failed: $arg"
        if [ -n "$want" ]; then
            verify_checksum "$want" "$local" || die "checksum mismatch for $arg"
            printf '%s: checksum verified\n' "$PROG"
        # auto_checksum is a best-effort probe: every candidate URL may 404. The
        # strict ERR trap is scoped off for the probe (in its own subshell) so an
        # expected miss never prints a spurious ERROR, while genuine failures
        # elsewhere in resolve_archive still abort.
        elif auto=$( { trap - ERR; auto_checksum "$arg" "$base"; } ); then
            verify_checksum "$auto" "$local" || die "checksum mismatch for $arg (release checksum)"
            printf '%s: checksum verified from release\n' "$PROG"
        fi
    else
        [ -f "$arg" ] || die "archive not found: $arg"
        local=$arg
    fi
    printf '%s\n' "$local"
}

has_sub() {  # "$dir" "$name"
    [ -d "$1" ] && [ -e "$1/$2" ]
}

count_execs() {  # "$dir" -> prints the number of top-level executables
    local c
    c=$(find "$1" -maxdepth 1 -type f -perm -u+x -print 2>/dev/null | sed -n '$=')
    printf '%s\n' "${c:-0}"
}

# ---------------------------------------------------------------- classifier

# True when a dir name is a structural base dir (never peeled past).
is_structural() {  # "$name"
    local n=$1
    case "$n" in
        bin|sbin|lib|lib64|share|man|var|etc|usr) return 0 ;;
    esac
    case "$n" in
        texmf-*|tlpkg|conda-meta|pkgs|envs) return 0 ;;
    esac
    return 1
}

# Peel single-directory wrappers/version dirs down to the base tree (a base can
# sit at any depth). Stops at any structural dir so bin/usr/etc are never peeled.
peel_base() {  # "$srcdir" -> prints the base tree dir
    local d=$1 sub
    local -a subs
    while :; do
        subs=()
        while IFS= read -r sub; do
            [ -n "$sub" ] && subs+=("$sub")
        done < <(find "$d" -mindepth 1 -maxdepth 1 -print 2>/dev/null)
        if [ "${#subs[@]}" -eq 1 ] && [ -d "${subs[0]}"  ] && ! is_structural "${subs[0]##*/}"; then
            d=${subs[0]}; continue
        fi
        break
    done
    printf '%s\n' "$d"
}

# Well-known dirs that mark a relocatable self-contained prefix (TinyTeX,
# Miniconda, …). Prefer naming these explicitly over guessing from bin size.
prefix_markers() {  # "$base" -> 0 for relocatable self-contained prefix marker dirs
    local b=$1 n
    for n in texmf-* tlpkg conda-meta pkgs envs; do
        [ -d "$b/$n" ] && return 0
    done
    return 1
}

# Fallback heuristic for marker-less toolchains: only treat a tree as a
# relocatable prefix when its bin/ is decidedly large (a whole distribution,
# not a handful of tools) AND it carries a non-standard top-level dir.
PREFIX_BIN_MIN=8

# Classify a source tree, printing a pipe-separated "kind|root|prefix_marked".
# kind is goreleased|standard|prefix|single-bin|unknown; root is the peeled base
# dir; prefix_marked is 1 only for a marker-recognised relocatable prefix.
classify() {  # "$srcdir" -> prints "kind|root|prefix_marked"
    local base kind ex pm=0
    base=$(peel_base "$1")
    # GoReleaser archives carry manpages/ and/or completions/ at the tree root
    # (GoReleaser's generated layout). This shape is NOT FHS: it reshapes those
    # dirs into share/man and shell-completion dirs, so it gets its own strategy.
    if has_sub "$base" manpages || has_sub "$base" completions; then
        kind=goreleased
    elif has_sub "$base" usr; then
        kind=standard
    elif has_sub "$base" bin && prefix_markers "$base"; then
        kind=prefix; pm=1
    elif has_sub "$base" bin; then
        ex=$(count_execs "$base/bin")
        local -a extra; local e
        while IFS= read -r e; do extra+=("$e"); done < <(find "$base" -mindepth 1 -maxdepth 1 -type d \
            ! -name bin ! -name etc ! -name share ! -name lib ! -name lib64 \
            ! -name man ! -name var ! -name sbin -print 2>/dev/null)
        if [ "$ex" -ge "$PREFIX_BIN_MIN" ] && [ "${#extra[@]}" -ge 1 ]; then
            kind=prefix   # heuristic, pm stays 0
        else
            kind=standard
        fi
    elif has_sub "$base" etc; then
        kind=standard
    else
        ex=$(count_execs "$base")
        if [ "$ex" -ge 1 ]; then kind=single-bin; else kind=unknown; fi
    fi
    printf '%s|%s|%s\n' "$kind" "$base" "$pm"
}

# ------------------------------------------------- flag parsing

# Parse the stow-install / leaf-installer option set into a single pipe-separated
# line, printed to stdout (no globals). Fields, in order:
#   dry verbose move no_stow keep_extras scope install_dir_opt target_opt
#   name version force_stow checksum archive
# scope is user|system; archive is the positional (required).
parse_flags() {  # "$@" -> prints the record
    local dry=0 verbose=0 move=0 no_stow=0 keep_extras=0 scope=user
    local idir_opt= target_opt= name= version= force_stow=0 checksum= archive=
    while (($#)); do
        case "$1" in
            --dry-run) dry=1; shift ;;
            --verbose|-v) verbose=1; shift ;;
            --move) move=1; shift ;;
            --no-stow) no_stow=1; shift ;;
            --keep-extras) keep_extras=1; shift ;;
            --user) scope=user; shift ;;
            --system) scope=system; shift ;;
            --install-dir) [ $# -ge 2 ] || die "--install-dir requires a value"; idir_opt=$2; shift 2 ;;
            --install-dir=*) idir_opt=${1#*=}; shift ;;
            --target) [ $# -ge 2 ] || die "--target requires a value"; target_opt=$2; shift 2 ;;
            --target=*) target_opt=${1#*=}; shift ;;
            --name) [ $# -ge 2 ] || die "--name requires a value"; name=$2; shift 2 ;;
            --name=*) name=${1#--name=}; shift ;;
            --version) [ $# -ge 2 ] || die "--version requires a value"; version=$2; shift 2 ;;
            --version=*) version=${1#--version=}; shift ;;
            --checksum) [ $# -ge 2 ] || die "--checksum requires a value"; checksum=$2; shift 2 ;;
            --checksum=*) checksum=${1#--checksum=}; shift ;;
            --force-stow) force_stow=1; shift ;;
            -*) die "unknown option: $1" ;;
            *) archive=$1; shift ;;
        esac
    done
    [ -n "$archive" ] || die "missing archive argument"
    printf '%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s\n' \
        "$dry" "$verbose" "$move" "$no_stow" "$keep_extras" "$scope" \
        "$idir_opt" "$target_opt" "$name" "$version" "$force_stow" \
        "$checksum" "$archive"
}

# ------------------------------------------------------- scope / target

# Resolve the install dir and stow target for a scope in a single pass, printing
# a pipe-separated "install_dir|target". The default target is dirname(install_dir); it is
# promoted to $HOME only when a kept user-scope `etc` must land in ~/.config
# (outside the default target) and a target was not pinned explicitly.
scope_resolution() {  # "$scope" "$has_etc" ["$install_dir_opt" "$target_opt"]
    local scope=$1 has_etc=$2 idir_opt=${3:-} target_opt=${4:-} idir target explicit=0
    if [ -n "$idir_opt" ]; then idir=$idir_opt
    elif [ "$scope" = system ]; then idir="${STOW_SYS_ROOT:-/usr/local}/opt"
    else idir="${STOW_INSTALL_ROOT:-$HOME/.local/opt}"; fi
    if [ -n "$target_opt" ]; then target=$target_opt; explicit=1
    elif [ -n "${STOW_TARGET:-}" ]; then target=$STOW_TARGET; explicit=1
    else target=$(dirname "$idir"); fi
    if [ "$scope" = user ] && [ "$has_etc" = 1 ] && [ "$explicit" = 0 ] \
       && [ "$target" = "$(dirname "$idir")" ] && [ "$target" != "$HOME" ]; then
        target=$HOME
    fi
    printf '%s|%s\n' "$idir" "$target"
}

# ------------------------------------------------------------ mapping

# Package-relative destination (== target-relative key) for a source top-level
# dir, so GNU Stow run with -t "$target" reproduces `topdir` at its canonical
# scope location. Only folded/split dirs are rewritten (sbin->bin, lib64->lib,
# man->share/man, etc->.config, lib64->lib on Darwin); an identity mapping
# returns `topdir` unchanged. When the user target is $HOME the FHS dirs sit
# under .local/. Returns 1 for a non-FHS topdir (an extra, dropped).
dest_path() {  # "$layout" "$target" "$topdir"
    local layout=$1 target=$2 topdir=$3 out home=""
    [ "$layout" = user ] && [ "$target" = "$HOME" ] && home=.local/
    case "$layout" in
    user)
        case "$topdir" in
            sbin)    out=bin ;;
            lib64)   out=lib ;;
            man)     out=share/man ;;
            etc)     out=.config ;;
            bin|lib|share|var) out=$topdir ;;
            *)       return 1 ;;
        esac
        [ "$topdir" != etc ] && out="$home$out"
        ;;
    system)
        case "$topdir" in
            sbin)  out=sbin ;;
            man)   out=share/man ;;
            lib64) if [ "$(uname -s)" = Darwin ]; then out=lib; else out=lib64; fi ;;
            bin|lib|share|var|etc) out=$topdir ;;
            *)     return 1 ;;
        esac
        ;;
    *) return 1 ;;
    esac
    printf '%s\n' "$out"
}

# ----------------------------------------------------------- materialise

# Relative path from a symlink location to its target (both absolute and sharing
# a common prefix): $pkg/bin -> ../.orig/bin, $pkg/share/man -> ../.orig/man.
rel_path() {  # "$from_file" "$to"
    local from=$1 to=$2 fd up="" out="" i j k
    local -a fp tp
    fd=$(dirname "$from")
    IFS=/ read -ra fp <<< "$fd"
    IFS=/ read -ra tp <<< "$to"
    i=0
    while [ "$i" -lt "${#fp[@]}" ] && [ "$i" -lt "${#tp[@]}" ] && [ "${fp[$i]}" = "${tp[$i]}" ]; do
        i=$((i+1))
    done
    for ((k=i; k<${#fp[@]}; k++)); do up+="../"; done
    for ((j=i; j<${#tp[@]}; j++)); do out+="/${tp[$j]}"; done
    [ -n "$up" ] || up=.
    printf '%s%s\n' "$up" "$out"
}

# Materialise one planned entry inside the package staging root.
#   $pkg = package staging root (absolute)
#   $src = absolute path of the real source (a file or dir)
#   $dst = package-relative destination key (e.g. bin, share/man, .config)
# farm (default): leave $src in place and create a relative symlink at $dst.
# --move: move $src to $dst. dry-run prints "would link/move"; verbose prints
# the performed op. Parents are created on demand. A perfect-fit placement where
# $src already equals $dst is a no-op.
deploy_entry() {  # "$pkg" "$src" "$dst" "$move" "$dry" "$verbose"
    local pkg=$1 src=$2 target="$1/$3" move=$4 dry=$5 verbose=$6 rel
    if [ -e "$src" ] || (( dry )); then
        if [ "$src" = "$target" ]; then
            if (( dry )); then printf 'would install %s\n' "$3"; fi
            if (( verbose && !dry )); then printf '%s: %s\n' "$PROG" "$3"; fi
            return 0
        fi
        mkdir -p "$(dirname "$target")"
        if (( move )); then
            if (( dry )); then printf 'would move %s\n' "$3"
            else
                mv "$src" "$target"
                if (( verbose )); then printf '%s: moved %s\n' "$PROG" "$3"; fi
            fi
        else
            if (( dry )); then printf 'would link %s\n' "$3"
            else
                rel=$(rel_path "$target" "$src")
                ln -sfn "$rel" "$target"
                if (( verbose )); then printf '%s: linked %s <- %s\n' "$PROG" "$3" "$rel"; fi
            fi
        fi
    fi
}

# Materialise a platform package from its collapsed real tree. $farm is the
# already-decided mode: 1 wraps the real tree in .orig/ with top-level links at
# each key (a fold/split), 0 leaves the real files in place (perfect fit).
# $move/$dry/$verbose are the run flags. dry-run prints "would link/install
# <key>" and touches nothing.
materialise() {  # "$pkg" "$real" "$farm" "$move" "$dry" "$verbose" name key [name key ...]
    local pkg=$1 real=$2 farm=$3 move=$4 dry=$5 verbose=$6; shift 6
    local -a pairs=("$@")
    local i n=${#pairs[@]} name key e
    if (( dry )); then
        for ((i=0;i<n;i+=2)); do
            name=${pairs[$i]}; key=${pairs[$((i+1))]}
            [ -e "$real/$name" ] || continue
            if (( move )); then printf 'would move %s\n' "$key"
            elif (( farm )); then printf 'would link %s\n' "$key"
            else printf 'would install %s\n' "$key"; fi
        done
        return 0
    fi
    rm -rf "$pkg"; mkdir -p "$pkg"
    if (( move )); then
        # --move: real entries land straight at their keys; no .orig farm, and
        # any unplanned real stays behind (dropped with the staging tree).
        for ((i=0;i<n;i+=2)); do
            name=${pairs[$i]}; key=${pairs[$((i+1))]}
            [ -e "$real/$name" ] || continue
            mkdir -p "$pkg/$(dirname "$key")"
            mv "$real/$name" "$pkg/$key"
            if (( verbose )); then printf '%s: moved %s\n' "$PROG" "$key"; fi
        done
    else
        for e in "$real"/*; do
            [ -e "$e" ] || continue
            name=${e##*/}
            if (( farm )); then
                mkdir -p "$pkg/.orig/$(dirname "$name")"; mv "$e" "$pkg/.orig/$name"
            else
                mkdir -p "$pkg/$(dirname "$name")"; mv "$e" "$pkg/$name"
                if (( verbose )); then printf '%s: installed %s\n' "$PROG" "$name"; fi
            fi
        done
        if (( farm )); then
            for ((i=0;i<n;i+=2)); do
                name=${pairs[$i]}; key=${pairs[$((i+1))]}
                [ -e "$pkg/.orig/$name" ] || continue
                deploy_entry "$pkg" "$pkg/.orig/$name" "$key" 0 "$dry" "$verbose"
            done
        fi
    fi
}

# True (0) iff any planned key differs from its source name, i.e. a fold/split
# forces a .orig farm. Used by the installer to choose the farm flag.
plan_needs_farm() {  # name key [name key ...]  (0 => farm needed, 1 => perfect fit)
    while [ $# -ge 2 ]; do
        [ "$2" != "$1" ] && return 0
        shift 2
    done
    return 1
}

# Keep list (unique first path segments of the plan keys) for a keep-only ignore.
plan_keeps() {  # key [key ...]  -> space-joined first segments
    local k first out=""
    for k in "$@"; do
        first=${k%%/*}
        case " $out " in *" $first "*) ;; *) out+=" $first" ;; esac
    done
    printf '%s\n' "${out# }"
}

# True (0) iff the collapsed real tree holds an entry that no plan name keeps.
has_extras() {  # "$real" name [name ...]
    local real=$1; shift
    local e n found
    for e in "$real"/*; do
        [ -e "$e" ] || continue
        n=${e##*/}; found=0
        for k in "$@"; do [ "$k" = "$n" ] && { found=1; break; }; done
        (( found )) || return 0
    done
    return 1
}

# Materialise a file-level (src key ...) plan. $pkg is the staging root, $base
# the real source tree, $move/$dry/$verbose the run flags. The default farm
# moves the real tree under .orig/ and links each planned entry to its key;
# --move moves the entries straight to their keys. No provisioning happens
# here: each installer's plan builder decides what maps to where.
deploy_plan() {  # "$pkg" "$base" "$move" "$dry" "$verbose" src key [src key ...]
    local pkg=$1 base=$2 move=$3 dry=$4 verbose=$5 root="$base" i; shift 5
    local -a pairs=("$@")
    mkdir -p "$pkg"
    if (( !move )); then
        if (( dry )); then
            root="$base"   # dry-run: nothing moved yet, probe the source tree
        else
            root="$pkg/.orig"
            mkdir -p "$root"
            for e in "$base"/*; do [ -e "$e" ] && mv "$e" "$root/"; done
        fi
    fi
    for ((i=0;i<${#pairs[@]};i+=2)); do
        [ -e "$root/${pairs[$i]}" ] || continue
        deploy_entry "$pkg" "$root/${pairs[$i]}" "${pairs[$((i+1))]}" "$move" "$dry" "$verbose"
    done
}

# ------------------------------------------------------------------ stow

# Commit the package staging dir atomically into the install dir and print the
# final versioned path. A half-built package is never visible.
commit_pkg() {  # "$builddir" "$install_dir" "$name" "$version"
    local build=$1 idir=$2 name=$3 version=$4
    local versioned="$idir/$name-$version"
    [ -e "$versioned" ] && die "target already exists: $versioned"
    mkdir -p "$idir"
    mv "$build" "$versioned"
    printf '%s\n' "$versioned"
}

# Write .stow-target iff the target differs from the default dirname(install_dir).
# A $HOME target is written as the portable '~' so it re-resolves on uninstall.
write_target_marker() {  # "$versioned" "$install_dir" "$target"
    local versioned=$1 idir=$2 target=$3
    if [ -n "$target" ] && [ "$target" != "$(dirname "$idir")" ]; then
        [ "$target" = "$HOME" ] && target='~'
        printf '%s\n' "$target" > "$versioned/.stow-target"
    fi
}

# Stow a versioned package through stow-run, passing the stow dir explicitly
# (stow-run is a thin wrapper and does not guess the opt location).
stow_pkg() {  # "$install_dir" "$pkgname"
    local install_dir=$1 pkg=$2
    command -v stow-run >/dev/null 2>&1 || die "stow-run not found on PATH"
    stow-run -d "$install_dir" "$pkg"
}

# Invalidate the zsh startup extras cache. ~/.config/zsh/extras.zsh concatenates
# every executable ~/.config/zshrc.d/*.zsh into ~/.cache/zsh/extras-cache.zsh
# and only rebuilds when that file is absent, so a shim written or removed by an
# installer would otherwise not be picked up until the user clears the cache.
refresh_zsh_cache() {  # no args
    local cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/extras-cache.zsh"
    [ -f "$cache" ] || return 0   # nothing cached: no-op (and never aborts)
    rm -f "$cache" "$cache.zwc"
}

# Escape regex metacharacters so a keep dir name is matched literally.
re_escape() {  # "$s" -> prints s with metacharacters backslash-escaped
    local s=$1 out= c i
    for (( i=0; i<${#s}; i++ )); do
        c=${s:i:1}
        case "$c" in
            \.|\^|\$|\*|\+|\\|\?|\(|\)|\[|\]|\{|\}|\|) out+='\' ;;
        esac
        out+=$c
    done
    printf '%s\n' "$out"
}

# Write .stow-local-ignore. With keeps: a keep-only negative-lookahead so a
# perfect-fit tree's spurious entries (or --move leftovers) are ignored. Without
# keeps: the farm-hiding form, hiding .orig. The markers are never linked.
# GNU Stow has no gitignore-style `!`; every line is a plain regexp and any
# match defeats it, so keeping only a few dirs is expressed in one pattern.
write_ignore_list() {  # "$versioned" [keeps...]
    local versioned=$1 n=0 or="" k q ; shift
    for k in "$@"; do
        q=$(re_escape "$k"); [ -n "$or" ] && or+="|"; or+=$q; n=$((n+1))
    done
    {
        if [ "$n" -gt 0 ]; then printf '/(?!(%s)(/|$))[^/]*\n' "$or"
        else printf '^\\.orig(/.*)?$\n'; fi
        printf '^\\.stow-target$\n^\\.stow-local-ignore$\n'
    } > "$versioned/.stow-local-ignore"
}


# Derive a package name from a wrapper/version dir name: strip a trailing
# version token (foo-1.2.3 -> foo, TinyTeX-2026.09 -> TinyTeX).
derive_name() {  # "$dirname" -> name (or empty)
    local d=$1 tok rest
    tok=${d%%-*}
    rest=${d#*-}
    if [ "$rest" != "$d" ] && parse_version "$rest" >/dev/null; then
        printf '%s\n' "$tok"; return 0
    fi
    return 1
}
