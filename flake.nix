{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      scriptText = builtins.readFile ./update_vendor.sh;
      script = pkgs.writeScriptBin "update-sha" scriptText;
    in { defaultPackage.${system} = script; };
}
