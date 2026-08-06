{
  description = "wl_shimeji package";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      # pkgs = import nixpkgs { inherit system; };
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "wl_shimeji";
        version = "unstable";

        src = pkgs.fetchgit {
          url = "https://github.com/CluelessCatBurger/wl_shimeji.git";
          rev = "8ae15cf";
          hash = "sha256-dNShG6SS1jiT0JpI817TSIS7v1JLHSY8T04vhGpD6xo=";
          fetchSubmodules = true;
        };

        nativeBuildInputs = with pkgs; [
          pkg-config
          wayland
          which
          wayland-scanner
          python3
        ];

        buildInputs = with pkgs; [
          wayland
          wayland-protocols
          libarchive
          uthash
        ];

        preBuild = ''
          chmod +x scripts/py-compose.py
        '';

        buildPhase = ''
          make -j$NIX_BUILD_CORES
        '';

        installPhase = ''
          make install PREFIX=$out
        '';
      };
    };
}
