# nix-update-sha

It is pretty simple script to update vendorSha256 variable of buildGoModule
package during your CI pipeline. It trying to build your flake and if it
fails it will find vendor sha by patternd and replace it in your derivation
file.

Script is dummy and simple.

## How to use:

`PUSH=true nix run github:pltanton/nix-update-sha`

Available configuration via env variables:

- BUILD_ATTR -- attribute to build from your flake
- PACKAGE_FILE -- file where vendorSha256 should be replaced
- PUSH -- set to `true` to allow script try to push to origin
