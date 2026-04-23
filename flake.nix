{
  description = "We do what we must because we can";


  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    ### home-manager ###
    # home-manager.url = github:nix-community/home-manager/ # unstable channel
    home-manager.url = github:nix-community/home-manager/release-25.11; # stable channel
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    ### declarative-flatpak ###
    declarative-flatpak.url = "github:in-a-dil-emma/declarative-flatpak/latest";
    # ### impermanence ###
    impermanence.url = "github:nix-community/impermanence";
    impermanence.inputs.nixpkgs.follows = "";
    impermanence.inputs.home-manager.follows = "";
  };


  outputs = { self, nixpkgs, ... } @attrs: {
    nixosConfigurations = {
      aperture = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ./configuration.nix
          ./host/aperture/tuxedo-sirius-16-gen2.nix
        ];
      };
    };
  };
}
