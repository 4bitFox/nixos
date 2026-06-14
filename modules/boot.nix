
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
#              "cryptsetup-pre.target"
            ];
            after = [
              "systemd-journald.service"
              "systemd-tmpfiles-setup-dev.service"
              "systemd-vconsole-setup.service"
              "systemd-udev-trigger.service"
              "systemd-udev-settle.service"
            ];
            unitConfig.DefaultDependencies = "no";
            serviceConfig = {
              Type = "oneshot";
            };
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
#      preDeviceCommands = ''
#        # Clear
#        printf "\033[2J"
#        # Move cursor to top left
#        printf "\033[H"
#        # Set color (bright yellow)
#        printf "\033[93m"
#        # ASCII art
#        echo "                                              "
#        echo "                                              "
#        echo "                                              "
#        echo "                   .,-:;//;:=,                "
#        echo "               . :H@@@MMMM#H/.,+%;,           "
#        echo "            ,/X+ +M@@MMMM%=,-%HMMM@X/,        "
#        echo "          -+@MM; \$M@@MH+-,;XMMMM@MMMMH+-      "
#        echo "         ;@MMMM- XM@X;. -+XXXXXHHH@MMM#@/.    "
#        echo "       ,%MM@@MH ,@%=             .---=-=:=,.  "
#        echo "       =@#@@@MX.,                -%HX\$\$%%%:;  "
#        echo "      =-./@MMM$                   .;@MMMMMMM: "
#        echo "      X@/ -\$MM/                    . +MM@@@M$ "
#        echo "     ,@MMH: :@:                    . =X#@@@@- "
#        echo "     ,@@@MMX, .                    /H- ;@MMM= "
#        echo "     .H@@@@@@+,                    %MM+..%#$. "
#        echo "      /MMMM@MMH/.                  XM@MH; =;  "
#        echo "       /%+%\$XHH@$=              , .H@@@@MX,   "
#        echo "        .=--------.           -%H.,@@@@@MX,   "
#        echo "        .%MM@@@HHHXX\$\$\$%+- .:\$MMX =M@@MM%.    "
#        echo "          =XMMM@MMMMM#H;,-+HMM@M+ /MMMX=      "
#        echo "            =%@MMM#@\$-.=\$MMM@@@M; %M%=        "
#        echo "              ,:+$+-,/H#MMMMMMM@= =,          "
#        echo "                    =++%%%%+/:-.              "
#        echo "                                              "
#        echo "                                              "
#        echo "                                              "
#        # Set color to normal again
#        printf "\033[0m"
#        # Get terminal height
#        rows=$(stty size 2>/dev/null | awk '{print $1}')
#        # Move cursor to third-to-last line
#        target_row=$((rows - 2))
#        printf "\033[''${target_row};1H"
#      '';
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
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = false;
        timeoutStyle = "menu";
        splashImage = null;
        font = "${pkgs.dejavu_fonts}/share/fonts/truetype/DejaVuSansMono.ttf";
        fontSize = 32;
        copyKernels = true;
        gfxmodeBios = "auto";
        gfxpayloadBios = "keep";
        gfxmodeEfi = "auto";
        gfxpayloadEfi = "keep";
        fsIdentifier = "uuid";
        default = "saved";
      };
      timeout = 3;
    };
  };
}
