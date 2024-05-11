# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader = {
	  timeout = -1;
	  efi.canTouchEfiVariables = true;
	  grub = {
		  enable = true;
		  device = "nodev";
		  useOSProber= true;
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

#  fileSystems."/home/maxdu/Windows" = {
 #   device = "/dev/nvme0n1p3";
  #  fsType = "ntfs3";
 #
# };

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
    ];
  };
  xdg = {
    autostart.enable = true;
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-gtk
      ];
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
    enableNvidiaPatches = true;
    enable = true;
  };

  programs.hyprland.xwayland = {
    enable = true;
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    libinput.enable = true;
  };

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
	  

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maxdu = {
    isNormalUser = true;
    description = "maxdu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      neovim
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
    killall
    vifm
  ];

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };
  services.auto-cpufreq.enable = true;
  services.ollama = {
    enable = true;
    acceleration = "cuda"; # Or "rocm"
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
  home-manager.users.maxdu = { pkgs, ... }: {
	  home.packages = [ ];
	  gtk = {
		  enable = true;
		  theme.name = "adw-gtk3";
		  cursorTheme.name = "Bibata-Modern-Ice";
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
