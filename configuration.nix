# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # Bootloader
  boot.loader = {
    timeout = -1;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      fontSize = 48;
    };
  };

  # Networking
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking.networkmanager.enable = true;

  # Time
  time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = true;

  # Internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  # File sytems
  fileSystems."/home/maxdu/Windows" = {
    device = "/dev/nvme0n1p3";
    fsType = "ntfs3";

  };
  # Hardware
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ vaapiVdpau ];
  };
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-gtk ];
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    forceFullCompositionPipeline = true;
    modesetting.enable = true; # Required for offload
    # fix after suspend
    powerManagement.enable = false;
    # offload
    powerManagement.finegrained = true; # Required for offload
    open = false;
    nvidiaSettings = true;
    package =
      config.boot.kernelPackages.nvidiaPackages.stable; # Make sure is correct for GPU

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Window Manager
  programs.hyprland = {
    enableNvidiaPatches = true;
    enable = true;
    xwayland.enable = true;
  };

  services.xserver = {
    layout = "us";
    xkbVariant = "";
    libinput.enable = true;
  };
  # services.xserver.libinput.enable = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #  services.udev = {
  #enable = true;
  #extraRules = ''
  #SUBSYSTEM==\"power_supply\",ENV{POWER_SUPPLY_ONLINE}==\"1\",RUN+=\"${pkgs.libnotify}/bin/notify-send "plugged""
  #'';
  #SUBSYSTEM==\"power_supply\",ENV{POWER_SUPPLY_ONLINE}==\"1\",RUN+=\"${pkgs.hyprland}/bin/hyprctl keyword monitor eDP-1,2560x1440@165,0x0,1.66666\"
  #SUBSYSTEM==\"power_supply\",ENV{POWER_SUPPLY_ONLINE}==\"1\",RUN+=\"${pkgs.hyprland}/bin/hyprctl keyword monitor eDP-1,2560x1440@165,0x0,1.66666\"
  #};

  # Enable touchpad support (enabled default in most desktopManager).
  # Fonts
  fonts.packages = with pkgs; [

    nerdfonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maxdu = {
    isNormalUser = true;
    description = "maxdu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ neovim ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Packages
  environment.systemPackages = with pkgs; [
    libnotify
    yt-dlp
    ly
    tetrio-desktop
    nvidia-vaapi-driver
    gnupg
    autoconf
    procps
    gnumake
    util-linux
    m4
    gperf
    cudatoolkit
    qt5ct
    libva
    wget
    gcc
    waybar
    git
    kitty
    hyprland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xwayland
    firefox
    floorp
    nodejs
    wl-clipboard
    obsidian
    nwg-look
    bibata-cursors
    armcord
    dolphin
    rustc
    cargo
    python3
    neofetch
    swaybg
    openssl
    networkmanagerapplet
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    pavucontrol
    racket
    rofi-wayland
    bottom
    dunst
    obsidian
    appimage-run
    unzip
    wlogout
    jdk21
    auto-cpufreq
    brightnessctl
    ripgrep
    powertop
    flat-remix-gtk
    gtk3
    gtk4
    gtk2
    zsh
    oh-my-zsh
    beeper
    cava
    ffmpeg_5-full
    imagemagick
    yt-dlp
    grimblast
    swappy
    pinta
    jetbrains.idea-ultimate
    pandoc
    texlive.combined.scheme-full
    musescore
    ollama
    obs-studio
    audacity
    libreoffice
    zip
    opentabletdriver
    peaclock
    cmatrix
    lazygit
    nvtop
    vifm
    nixfmt
  ];

  # Package config
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
  services.auto-cpufreq.enable = true;
  services.ollama = {
    enable = true;
    acceleration = "cuda"; # Or "rocm"
  };

  programs.zsh.enable = true;

  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];
  home-manager.users.maxdu = { pkgs, ... }: {
    home.packages = [ ];
    gtk = {
      enable = true;
      theme.name = "adw-gtk3";
      cursorTheme.name = "Bibata-Modern-Ice";
    };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      #autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      sessionVariables = { EDITOR = "nvim"; };
      shellAliases = {
        ppip3 = "~/.venv/bin/pip3";
        ppython3 = "~/.venv/bin/python3";
        audio = "yt-dlp -x --audio-format mp3";
      };
      initExtra = ''
        		neofetch --config ~/.config/neofetch/mini.conf 
                	bindkey -M viins 'kj' vi-cmd-mode
                	export EDITOR=nvim
      '';
      plugins = [{
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }];

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" "vi-mode" ];
        theme = "agnoster";
      };
    };
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          backlight = {
            device = "intel_backlight";
            format = "{icon} {percent}%";
            format-icons = [ "" "" "" "" "" "" "" "" "" ];
            min-length = 6;
            on-scroll-down = "brightnessctl set 1%-";
            on-scroll-up = "brightnessctl set 1%+";
          };
          battery = {
            format = "{icon} {capacity}%";
            format-alt = "{time} {icon}";
            format-charging = " {capacity}%";
            format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
            format-plugged = " {capacity}%";
            states = {
              critical = 20;
              good = 95;
              warning = 30;
            };
          };
          bluetooth = {
            format = "";
            format-connected = " {num_connections}";
            format-disabled = "";
            tooltip-format = " {device_alias}";
            tooltip-format-connected = "{device_enumerate}";
            tooltip-format-enumerate-connected = " {device_alias}";
          };
          clock = {
            actions = {
              on-click-backward = "tz_down";
              on-click-forward = "tz_up";
              on-click-right = "mode";
              on-scroll-down = "shift_down";
              on-scroll-up = "shift_up";
            };
            calendar = {
              format = {
                months = "<span color='#ffead3'><b>{}</b></span>";
                today = "<span color='#ff6699'><b>{}</b></span>";
                weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              };
              mode = "month";
              mode-mon-col = 3;
              on-click-right = "mode";
              on-scroll = 1;
            };
            format = "{:%I:%M %p}";
            format-alt = "{:%R 󰃭 %d·%m·%y}";
            tooltip-format = "<tt>{calendar}</tt>";
          };
          cpu = {
            format = "󰍛 {usage}%";
            format-alt = "{icon0}{icon1}{icon2}{icon3}";
            format-icons = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
            interval = 10;
          };
          "custom/gpuinfo" = {
            exec = " ~/.config/hypr/scripts/gpuinfo.sh";
            format = " {}";
            interval = 5;
            max-length = 1000;
            return-type = "json";
            tooltip = true;
          };
          "custom/l_end" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };
          "custom/padd" = {
            format = "  ";
            interval = "once";
            tooltip = false;
          };
          "custom/power" = {
            exec = "echo ; echo  logout";
            format = "{}";
            interval = 86400;
            on-click = "wlogout";
            tooltip = true;
          };
          "custom/r_end" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };
          "custom/rl_end" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };
          "custom/rr_end" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };
          "custom/sl_end" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };
          "custom/sr_end" = {
            format = " ";
            interval = "once";
            tooltip = false;
          };
          exclusive = true;
          gtk-layer-shell = true;
          height = 31;
          "hyprland/workspaces" = {
            active-only = false;
            all-outputs = true;
            disable-scroll = true;
            on-click = "activate";
            persistent-workspaces = { };
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "󰥔";
              deactivated = "";
            };
          };
          layer = "top";
          memory = {
            format = "󰾆 {percentage}%";
            format-alt = "󰾅 {used}GB";
            interval = 30;
            max-length = 10;
            tooltip = true;
            tooltip-format = " {used:0.1f}GB/{total:0.1f}GB";
          };
          mod = "dock";
          modules-center = [
            "custom/padd"
            "custom/l_end"
            "wlr/taskbar"
            "custom/r_end"
            "custom/padd"
          ];
          modules-left = [
            "custom/padd"
            "custom/l_end"
            "cpu"
            "memory"
            "custom/gpuinfo"
            "custom/r_end"
            "custom/l_end"
            "idle_inhibitor"
            "clock"
            "custom/r_end"
            "custom/l_end"
            "hyprland/workspaces"
            "custom/r_end"
            "custom/padd"
          ];
          modules-right = [
            "custom/padd"
            "custom/l_end"
            "backlight"
            "network"
            "bluetooth"
            "pulseaudio"
            "pulseaudio#microphone"
            "custom/updates"
            "custom/r_end"
            "custom/l_end"
            "tray"
            "battery"
            "custom/r_end"
            "custom/l_end"
            "custom/wallchange"
            "custom/mode"
            "custom/wbar"
            "custom/cliphist"
            "custom/power"
            "custom/r_end"
            "custom/padd"
          ];
          network = {
            format-alt = "󰤨 {signalStrength}%";
            format-disconnected = " Disconnected";
            format-ethernet = "󱘖 Wired";
            format-linked = "󱘖 {ifname} (No IP)";
            format-wifi = "󰤨 {essid}";
            interval = 5;
            tooltip-format =
              "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
          };
          passthrough = false;
          position = "bottom";
          pulseaudio = {
            format = "{icon} {volume}";
            format-icons = {
              car = "";
              default = [ "" "" "" ];
              hands-free = "";
              headphone = "";
              headset = "";
              phone = "";
              portable = "";
            };
            format-muted = "󰝟";
            on-click = "pavucontrol -t 3";
            on-click-middle = "~/.config/hypr/scripts/volumecontrol.sh -o m";
            on-scroll-down = "~/.config/hypr/scripts/volumecontrol.sh -o d";
            on-scroll-up = "~/.config/hypr/scripts/volumecontrol.sh -o i";
            scroll-step = 5;
            tooltip-format = "{icon} {desc} // {volume}%";
          };
          "pulseaudio#microphone" = {
            format = "{format_source}";
            format-source = "󰍬";
            format-source-muted = "";
            on-click = "pavucontrol -t 4";
            on-click-middle = "~/.config/hypr/scripts/volumecontrol.sh -i m";
            on-scroll-down = "~/.config/hypr/scripts/volumecontrol.sh -i d";
            on-scroll-up = "~/.config/hypr/scripts/volumecontrol.sh -i i";
            scroll-step = 5;
            tooltip-format =
              "{format_source} {source_desc} // {source_volume}%";
          };
          tray = {
            icon-size = 18;
            spacing = 5;
          };
          "wlr/taskbar" = {
            app_ids-mapping = {
              firefoxdeveloperedition = "firefox-developer-edition";
            };
            format = "{icon}";
            icon-size = 18;
            icon-theme = "Tela-circle-purple";
            ignore-list = [ "Alacritty" ];
            on-click = "activate";
            on-click-middle = "close";
            spacing = 0;
            tooltip-format = "{title}";
          };
        };
      };

      style = ''

        * {
            border: none;
            border-radius: 0px;
            font-family: "JetBrainsMono Nerd Font";
            font-weight: bold;
            font-size: 11px;
            min-height: 10px;
        }

        @define-color bar-bg rgba(0, 0, 0, 0);
        @define-color main-bg rgba(0, 0, 0, 0.8);
        @define-color main-fg #6F87E0;
        @define-color wb-act-bg #6F87E0;
        @define-color wb-act-fg #1C1D21;
        @define-color wb-hvr-bg #6F87E0;
        @define-color wb-hvr-fg #6F87E0;

        window#waybar {
            background: @bar-bg;
        }

        tooltip {
            background: @main-bg;
            color: @main-fg;
            border-radius: 4px;
            border-width: 0px;
        }

        #workspaces button {
            box-shadow: none;
        	text-shadow: none;
            padding: 0px;
            border-radius: 4px;
            margin-top: 3px;
            margin-bottom: 3px;
            padding-left: 3px;
            padding-right: 3px;
            color: @main-fg;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
        }

        #workspaces button.active {
            background: @wb-act-bg;
            color: @wb-act-fg;
            margin-left: 3px;
            padding-left: 12px;
            padding-right: 12px;
            margin-right: 3px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
        }

        #workspaces button:hover {
            background: @wb-hvr-bg;
            color: @wb-hvr-fg;
            padding-left: 3px;
            padding-right: 3px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
        }

        #taskbar button {
            box-shadow: none;
        	text-shadow: none;
            padding: 0px;
            border-radius: 4px;
            margin-top: 3px;
            margin-bottom: 3px;
            padding-left: 3px;
            padding-right: 3px;
            color: @wb-color;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
        }

        #taskbar button.active {
            background: @wb-act-bg;
            color: @wb-act-color;
            margin-left: 3px;
            padding-left: 12px;
            padding-right: 12px;
            margin-right: 3px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
        }

        #taskbar button:hover {
            background: @wb-hvr-bg;
            color: @wb-hvr-color;
            padding-left: 3px;
            padding-right: 3px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
        }

        #backlight,
        #battery,
        #bluetooth,
        #custom-cliphist,
        #clock,
        #cpu,
        #custom-gpuinfo,
        #idle_inhibitor,
        #language,
        #memory,
        #custom-mode,
        #mpris,
        #network,
        #custom-power,
        #pulseaudio,
        #custom-spotify,
        #taskbar,
        #tray,
        #custom-updates,
        #custom-wallchange,
        #custom-wbar,
        #window,
        #workspaces,
        #custom-l_end,
        #custom-r_end,
        #custom-sl_end,
        #custom-sr_end,
        #custom-rl_end,
        #custom-rr_end {
            color: @main-fg;
            background: @main-bg;
            opacity: 1;
            margin: 4px 0px 4px 0px;
            padding-left: 4px;
            padding-right: 4px;
        }

        #workspaces,
        #taskbar {
            padding: 0px;
        }

        #custom-r_end {
            border-radius: 0px 5px 5px 0px;
            margin-right: 9px;
            padding-right: 3px;
        }

        #custom-l_end {
            border-radius: 5px 0px 0px 5px;
            margin-left: 9px;
            padding-left: 3px;
        }

        #custom-sr_end {
            border-radius: 0px;
            margin-right: 9px;
            padding-right: 3px;
        }

        #custom-sl_end {
            border-radius: 0px;
            margin-left: 9px;
            padding-left: 3px;
        }

        #custom-rr_end {
            border-radius: 0px 7px 7px 0px;
            margin-right: 9px;
            padding-right: 3px;
        }

        #custom-rl_end {
            border-radius: 4px 0px 0px 4px;
            margin-left: 9px;
            padding-left: 3px;
        }
        	    '';
    };
    home.stateVersion = "23.11";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
