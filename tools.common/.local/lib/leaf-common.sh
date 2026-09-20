#!/usr/bin/env bash
# Shared driver for the leaf installers (stow-single-bin, stow-goreleased),
# sourced after package-common.sh. The two kinds are an identical pipeline that
# differs only in the classifier kind they accept (and its human label) and in
# their focused (src key) plan builder, so the whole extract/name/version/
# deploy/commit/stow sequence lives here once. No branching on kind: both the
# kind and the plan builder are decided statically by the calling executable.

# Run a leaf installer. $kind is compared against the classifier output, $label
# is the human name used in the "not a <label> tree" error, and $plan is the
# focused builder that prints the (src key) pairs. Everything else is shared.
run_leaf() {  # "$kind" "$label" "$plan_builder" "$@"
    local kind=$1 label=$2 plan=$3
    shift 3
    local name= version= archive=
    local scope=user move=0 dry=0 verbose=0 no_stow=0 keep_extras=0
    local idir_opt= target_opt= verb has_etc install_dir target
    local -a pairs=()
    local n k versioned work readable base checksum=
    IFS='|' read -r dry verbose move no_stow keep_extras scope idir_opt target_opt \
        name version force_stow checksum archive <<< "$(parse_flags "$@")"
    (( dry )) && verb=1 || verb=$verbose

    if [[ "$archive" =~ ^https?:// ]]; then
        die "URLs are handled by 'stow-install' (which verifies checksums); pass a local archive path"
    fi
    [ -f "$archive" ] || die "archive not found: $archive"
    command -v tar >/dev/null 2>&1 || die "tar not found"
    command -v stow >/dev/null 2>&1 || die "stow not found"

    work=$(mktemp -d)
    readable=$(prepare_tar "$archive") || die "cannot decode '$archive': need zstd or Python zstandard"
    mkdir -p "$work/stage"
    tar -xf "$readable" -C "$work/stage" 2>/dev/null || die "cannot extract '$archive'"

    IFS='|' read -r cls_kind base pm <<< "$(classify "$work/stage")"
    [ "$cls_kind" = "$kind" ] || die "not a $label tree (kind=$cls_kind)"

    if [ -z "$name" ]; then name=$(infer_name "$archive" "$base" || true); fi
    [ -n "$name" ] || die "unable to determine package name (pass --name)"
    if [ -z "$version" ]; then version=$(version_from "$archive" "$base" top_exe || true); fi
    [ -n "$version" ] || die "unable to determine version (pass --version)"

    has_etc=0
    IFS='|' read -r install_dir target <<< "$(scope_resolution "$scope" "$has_etc" "$idir_opt" "$target_opt")"

    while IFS='|' read -r n k; do
        [ -n "$n" ] || continue
        pairs+=("$n" "$k")
    done < <("$plan" "$base")

    if (( dry )); then
        printf 'would install %s %s\n' "$name" "$version"
        printf '  target: %s\n' "$install_dir/$name-$version"
        deploy_plan "$work/pkg" "$base" "$move" "$dry" "$verb" "${pairs[@]}"
        rm -rf "$work"
        return 0
    fi

    deploy_plan "$work/pkg" "$base" "$move" "$dry" "$verb" "${pairs[@]}"
    versioned=$(commit_pkg "$work/pkg" "$install_dir" "$name" "$version")
    if (( !move )); then write_ignore_list "$versioned"; fi
    write_target_marker "$versioned" "$install_dir" "$target"

    if (( no_stow )); then
        printf 'built %s %s (stow skipped)\n' "$name" "$version"
    else
        stow_pkg "$install_dir" "${versioned##*/}"
        printf 'installed %s %s\n' "$name" "$version"
    fi
    rm -rf "$work"
}
