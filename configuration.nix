

# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    #./vm.nix
    <home-manager/nixos>
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
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

  networking.hostName = "nixos"; # Define your hostname.

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
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

  #services.journald.extraConfig = "SystemMaxUse=1G";

  # Enable OpenGL
  hardware.graphics = {
    enable = true; # driSupport = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
  };
  environment.variables.VDPAU_DRIVER = "va_gl";
  environment.variables.LIBVA_DRIVER_NAME = "nvidia";
  environment.sessionVariables.VK_DRIVER_FILES =
    "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

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
    # Modesetting is required.
    modesetting.enable = true;

    # fix after suspend
    powerManagement.enable = false;

    # offload
    powerManagement.finegrained = true;

    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {

    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    #sync.enable = true;
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = { NIXOS_OZONE_WL = "1"; };
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };
  services.libinput.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

	 services.udev = {
	 enable = true;
	 extraRules = ''
	 SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.su}/bin/su maxdu -c \"${pkgs.hyprland}/bin/hyprctl -i 0 --batch 'keyword animations:enabled 0;keyword decoration:drop_shadow 0; keyword decoration:blur:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword decoration:rounding 0; keyword monitor eDP-1,2560x1440@60,0x0,1.6666; keyword misc:vfr 1'\""
	 SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="${pkgs.brightnessctl}/bin/brightnessctl set 5%"
	 SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.brightnessctl}/bin/brightnessctl set 50%"
	 SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="${pkgs.su}/bin/su maxdu -c \"${pkgs.hyprland}/bin/hyprctl -i 0 reload"
	 '';
	};

  # Enable sound with pipewire.
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maxdu = {
    isNormalUser = true;
    description = "maxdu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ neovim ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    home-manager
    neovim
    pamixer
    libnotify
    yt-dlp
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
    wget
    gcc
    waybar
    git
    kitty
    hyprland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xwayland
    floorp
    nodejs
    wl-clipboard
    obsidian
    armcord
    rustc
    cargo
    python3
    fastfetch
    swaybg
    openssl
    networkmanagerapplet
    meson
    wayland-protocols
    wayland-utils
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
    zsh-powerlevel10k
    beeper
    cava
    ffmpeg_7-full
    imagemagick
    yt-dlp
    grimblast
    swappy
    pinta
    loupe
    jetbrains.idea-ultimate
    pandoc
    texlive.combined.scheme-full
    musescore
    ollama
    obs-studio
    audacity
    libreoffice
    zathura
    zip
    opentabletdriver
    peaclock
    cmatrix
    lazygit
    nvtopPackages.full
    killall
    vifm
    python312Packages.pygments
    nixfmt-classic
    rust-analyzer
    zoxide
    prismlauncher
    steam
    steam-run
    mesa
    vulkan-loader
    vulkan-validation-layers
    vulkan-extension-layer
    vulkan-tools
    libva
    libva-utils
    xdragon
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall =
      true; # Open ports in the firewall for Steam Local Network Game Transfers
    extraCompatPackages = with pkgs; [
      vkd3d-proton
      vkd3d
      dxvk_2
      proton-ge-bin
      freetype
    ];
  };

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery.governor = "powersave";

      charger = {
        governor = "powersave";
        turbo = "auto";
      };
    };
  };
  services.thermald.enable = true;
  services.ollama = {
    enable = true;
    acceleration = "cuda"; # Or "rocm"
  };
  systemd.services.ollama.wantedBy = lib.mkForce [ ];

  #nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];
  home-manager.users.maxdu = { pkgs, ... }: {
    home.packages = [ ];
    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 25;
    };
    gtk = {
      enable = true;
      theme.name = "Materia-dark";
      theme.package = pkgs.materia-theme;
      cursorTheme.name = "Bibata-Modern-Ice";
      font.name = "CaskaydiaCove Nerd Font Mono";
    };
    #xdg.mimeApps = {
    #	    enable = true;
    #	    associations.added = {
    #"application/png" = ["kitty +kitten icat"];
    #};
    #};
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      sessionVariables = { EDITOR = "nvim"; };
      shellAliases = {
        ppip3 = "~/.venv/bin/pip3";
        ppython3 = "~/.venv/bin/python3";
        audio = "yt-dlp -x --audio-format mp3";
        ssh = "kitty +kitten ssh";
      };
      initExtra = ''
        			source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
                        	fastfetch --config ~/.config/fastfetch/mini.jsonc
                                export EDITOR=nvim
                		ZVM_VI_INSERT_ESCAPE_BINDKEY=kj
        			POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=True
      '';
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.8.0";
            sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
          };
        }
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
    };
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    programs.kitty = {
      enable = true;
      font.name = "CaskaydiaCove Nerd Font Mono";
      font.size = 9.0;
      shellIntegration.enableZshIntegration = true;
      settings = {
        window_padding_width = 25;
        foreground = "#a9b1d6";
        background = "#000000";
        color0 = "#414868";
        color8 = "#414868";
        # Red
        color1 = "#f7768e";
        color9 = "#f7768e";
        # Green
        color2 = "#73daca";
        color10 = "#73daca";
        # Yellow
        color3 = "#e0af68";
        color11 = "#e0af68";
        # Blue
        color4 = "#7aa2f7";
        color12 = "#7aa2f7";
        # Magenta
        color5 = "#bb9af7";
        color13 = "#bb9af7";
        # Cyan
        color6 = "#7dcfff";
        color14 = "#7dcfff";
        # White
        color7 = "#c0caf5";
        color15 = "#c0caf5";
        # Cursor
        cursor = "#c0caf5";
        cursor_text_color = "#1a1b26";
        # Selection highlight
        selection_foreground = "none";
        selection_background = "#28344a";
        # The color for highlighting URLs on mouse-over
        url_color = "#9ece6a";
        active_border_color = "#3d59a1";
        inactive_border_color = "#101014";
        bell_border_color = "#e0af68";
        tab_bar_style = "fade";
        tab_fade = "1";
        active_tab_foreground = "#3d59a1";
        active_tab_background = "#16161e";
        active_tab_font_style = "bold";
        inactive_tab_foreground = "#787c99";
        inactive_tab_background = "#16161e";
        inactive_tab_font_style = "bold";
        tab_bar_background = "#101014";
        macos_titlebar_color = "#16161e";
        wayland_enable_ime = "no";
        sync_to_monitor = "no";

      };
    };
    programs.wlogout = {
      enable = true;
      style = ''
        * {
        	background-image: none;
        }
        window {
        	background-color: rgba(12, 12, 12, 0.0);
        }
        button {
            color: #6F87E0;
        	background-color: rgba(0, 0, 0, 0.8);
        	/* border-style: solid;
        	border-width: 2px; */
        	background-repeat: no-repeat;
        	background-position: center;
        	background-size: 25%;
        }

        button:focus, button:active, button:hover {
        	color: #000000;
        	background-color: #6F87E0;
        	outline-style: none;
        }

        #lock { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png")); }

        #logout { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png")); }

        #suspend { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png")); }

        #hibernate { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png")); }

        #shutdown { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")); }

        #reboot { background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png")); }
        	    '';
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
            on_click = "blueman-manager";
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
                #custom-rr_end 
        	{
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
                    border-radius: 0px 5px 5px 0px;
                    margin-right: 9px;
                    padding-right: 3px;
                }

                #custom-rl_end {
                    border-radius: 5px 0px 0px 5px;
                    margin-left: 9px;
                    padding-left: 3px;
                }
                	    '';
    };
    home.stateVersion = "23.11";
  };

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
