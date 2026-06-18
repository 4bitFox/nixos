
{ config, pkgs, lib, ... }:

let
  bootlogo = ''
    \\t                                          
    \\t                                          
    \\t                                          
    \\t               .,-:;//;:=,                
    \\t           . :H@@@MMMM#H/.,+%;,           
    \\t        ,/X+ +M@@MMMM%=,-%HMMM@X/,        
    \\t      -+@MM; \$M@@MH+-,;XMMMM@MMMMH+-      
    \\t     ;@MMMM- XM@X;. -+XXXXXHHH@MMM#@/.    
    \\t   ,%MM@@MH ,@%=             .---=-=:=,.  
    \\t   =@#@@@MX.,                -%HX\$\$%%%:;  
    \\t  =-./@MMM$                   .;@MMMMMMM: 
    \\t  X@/ -\$MM/                    . +MM@@@M$ 
    \\t ,@MMH: :@:                    . =X#@@@@- 
    \\t ,@@@MMX, .                    /H- ;@MMM= 
    \\t .H@@@@@@+,                    %MM+..%#$. 
    \\t  /MMMM@MMH/.                  XM@MH; =;  
    \\t   /%+%\$XHH@$=              , .H@@@@MX,   
    \\t    .=--------.           -%H.,@@@@@MX,   
    \\t    .%MM@@@HHHXX\$\$\$%+- .:\$MMX =M@@MM%.    
    \\t      =XMMM@MMMMM#H;,-+HMM@M+ /MMMX=      
    \\t        =%@MMM#@\$-.=\$MMM@@@M; %M%=        
    \\t          ,:+$+-,/H#MMMMMMM@= =,          
    \\t                =++%%%%+/:-.              
    \\t                                          
    \\t                                          
    \\t                                          
  '';
in

{
  boot = {
    initrd = {
      enable = true;
      systemd = {
        enable = true;
        initrdBin = [ pkgs.coreutils ];
        services = {
          bootlogo = {
            description = "displaying extremely cool and awesome boot logo :D";
            wantedBy = [ "initrd.target" ];
            before = [ 
              "sysinit.target"
              "systemd-cryptsetup@cryptroot.service"
              "initrd-root-device.target"
              "cryptsetup-pre.target"
            ];
            after = [
              "systemd-journald.service"
              "systemd-tmpfiles-setup-dev.service"
              "systemd-vconsole-setup.service"
              "systemd-udev-trigger.service"
              "systemd-udev-settle.service"
              "systemd-modules-load.service"
            ];
            unitConfig.DefaultDependencies = false;
            serviceConfig.Type = "oneshot";
            script = ''
              # Clear
              printf "\033[2J" > /dev/console
              # Move cursor to top left
              printf "\033[H" > /dev/console
              # Set color (bright yellow)
              printf "\033[93m" > /dev/console
              # ASCII art
              ${pkgs.coreutils}/bin/echo -e "${bootlogo}" > /dev/console
              # Set color to normal again
              printf "\033[0m" > /dev/console
            '';
          };
        };
      };
      kernelModules = [   ];
    };
    # kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_xanmod;
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [
      "uinput"
    ];
    kernelParams = [
      "button.lid_init_state=open"
    ];
    kernel.sysctl = {
      "vm.swappiness" = 10;
      "kernel.sysrq" = 1;
    };
    consoleLogLevel = 3;
    tmp.cleanOnBoot = true;
    supportedFilesystems = ["ntfs"];
    loader = {
      grub = {
        enable = true;
        useOSProber = false;
        timeoutStyle = "menu";
        splashImage = null;
        font = "${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf";
        fontSize = 32;
        copyKernels = true;
        fsIdentifier = "uuid";
        default = "saved";
        configurationLimit = 10;
      };
      timeout = 3;
    };
  };
}
