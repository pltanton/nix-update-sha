{
  outputs = { self, nixpkgs }:
    let
      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      scriptText = builtins.readFile ./update_vendor.sh;
      pkgsFor = system: import nixpkgs { inherit system; };
      scriptFor = system: (pkgsFor system).writeScriptBin "update-sha" scriptText;
    in
    {
      defaultPackage = builtins.foldl' (attrs: system: attrs // { ${system} = scriptFor system; }) { } systems;
    };
}
