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
    impermanence.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.inputs.home-manager.follows = "home-manager";
  };


  outputs = { self, nixpkgs, ... } @attrs: 

  let
    mkHost = { system, hostModules}: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = attrs;
      modules = [
        ./modules/fonts.nix
        ./modules/keyboard.nix
        ./modules/datetime.nix
        ./modules/services.nix
        ./modules/virtualisation.nix
        ./modules/networking.nix
        ./users/alya/user.nix
        ./modules/nix.nix
        ./modules/locales.nix
        ./modules/boot.nix
        ./modules/packages.nix
        ./modules/hardware.nix
        ./modules/graphical/niri.nix
        ./modules/audio.nix
        ./modules/printing.nix
        ./modules/home-manager.nix
        ./modules/declarative-flatpak.nix
        ./modules/impermanence.nix
        ./modules/partitions.nix
      ] ++ hostModules;
    };
  in {
    nixosConfigurations = {
      aperture = mkHost {
        system = "x86_64-linux";
        hostModules = [
          ./hosts/tuxedo-sirius-16-gen2/host.nix
          {
            # This value determines the NixOS release from which the default
            # settings for stateful data, like file locations and database versions
            # on your system were taken. It‘s perfectly fine and recommended to leave
            # this value at the release version of the first install of this system.
            # Before changing this value read the documentation for this option
            # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
            system.stateVersion = "25.11"; # Did you read the comment?
          }
        ];
      };
    };
  };
}
