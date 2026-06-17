{
  description = "We do what we must because we can";


  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    ### home-manager ###
    # home-manager.url = github:nix-community/home-manager/; # unstable channel
    home-manager.url = github:nix-community/home-manager/release-26.05; # stable channel
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
        ./modules/networking.nix
        ./users/alya/user.nix
        ./modules/nix.nix
        ./modules/locales.nix
        ./modules/boot.nix
        ./modules/packages.nix
        ./modules/hardware.nix
        ./modules/audio.nix
        ./modules/home-manager.nix
        ./modules/impermanence.nix
        ./modules/security.nix
      ] ++ hostModules;
    };
  in {
    nixosConfigurations = {
      ### aperture: to build run 'nixos-rebuild switch --flake /etc/nixos#aperture' ###
      aperture = mkHost {
        system = "x86_64-linux";
        hostModules = [
          ./hosts/tuxedo-sirius-16-gen2/host.nix
          ./hosts/tuxedo-sirius-16-gen2/hardware-configuration.nix
          ./modules/boot/efi.nix
          ./modules/graphical/niri.nix
          ./modules/printing.nix
          ./modules/virtualisation.nix
          ./modules/packages/tex.nix
          ./modules/packages/steam.nix
          ./modules/declarative-flatpak.nix
          {
            networking.hostName = "aperture";
            system.stateVersion = "25.11";
          }
        ];
      };
      wheatley = mkHost {
        system = "x86_64-linux";
        hostModules = [
          ./hosts/hp-z600-rev2/host.nix
          ./hosts/hp-z600-rev2/hardware-configuration.nix
          ./modules/boot/bios.nix
          ./modules/graphical/niri.nix
          ./modules/packages/steam.nix
          ./modules/declarative-flatpak.nix
          {
            networking.hostName = "wheatley";
            system.stateVersion = "26.05";
          }
        ];
      };
    };
  };
}
