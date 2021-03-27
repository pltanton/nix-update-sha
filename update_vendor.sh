#!/usr/bin/env bash
# set -e

packageFile=${PACKAGE_FILE:-./package.nix}
buildAttr=${BUILD_ATTR}

l="$(mktemp)"
trap "rm ${l}" EXIT

echo "packageFile="$packageFile
vendorSha256=$(grep vendorSha256 "$packageFile" | cut -f2 -d'"')
echo "venhorSha256="$vendorSha256
nix build ".#${buildAttr}" --no-link &>"${l}" || true
cat ${l}
newvendorSha256="$(cat "${l}" | grep 'got:' | cut -d':' -f2 | tr -d ' ' || true)"
echo $newvendorSha256
[ ! -z "$newvendorSha256" ] || exit 0
if [[ "${newvendorSha256}" == "sha256" ]]; then newvendorSha256="$(cat "${l}" | grep 'got:' | cut -d':' -f3 | tr -d ' ' || true)"; fi
newvendorSha256="$(nix hash to-base32 --type sha256 "${newvendorSha256}")"
sed -i "s|${vendorSha256}|${newvendorSha256}|" "$packageFile"

git diff-index --quiet HEAD "${pkg}" ||
	git commit "$packageFile" -m "[CI SKIP] Update vendorSha256 in ${packageFile}: ${vendorSha256} => ${newvendorSha256}"
echo "done updating ${packageFile} (${vendorSha256} => ${newvendorSha256})"
if [ "$PUSH" = true ]; then
	git push origin || echo "Failed to push to origin. Not on the top of the stream?"
fi

exit 0
