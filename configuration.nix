# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

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
  fileSystems."/home/maxdu/Windows" = {
	  device = "/dev/nvme0n1p3";
	  fsType = "ntfs3";
  };

 # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
    vaapiVdpau
    ];
  };
  hardware.opentabletdriver = {
    enable = true;
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

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
hardware.nvidia.prime = {
	# Make sure to use the correct Bus ID values for your system!
	offload = {
		enable = true;
		enableOffloadCmd = true;
	};
	#sync.enable = true;
	intelBusId = "PCI:0:2:0";
	nvidiaBusId = "PCI:1:0:0";
};
  # Enable the GNOME Desktop Environment.
  programs.hyprland = {
     enableNvidiaPatches = true;
     enable = true;
  };
  hardware.nvidia.forceFullCompositionPipeline = true;
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
  };

  services.xserver.libinput.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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
   #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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


  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  services.auto-cpufreq.enable = true;
  services.ollama = {
	  #package = pkgs.unstable.ollama; # Uncomment if you want to use the unstable channel, see https://fictionbecomesfact.com/nixos-unstable-channel
	  enable = true;
	  acceleration = "cuda"; # Or "rocm"
	  #environmentVariables = { # I haven't been able to get this to work myself yet, but I'm sharing it for the sake of completeness
	    # HOME = "/home/ollama";
	    # OLLAMA_MODELS = "/home/ollama/models";
	    # OLLAMA_HOST = "0.0.0.0:11434"; # Make Ollama accesible outside of localhost
	    # OLLAMA_ORIGINS = "http://localhost:8080,http://192.168.0.10:*"; # Allow access, otherwise Ollama returns 403 forbidden due to CORS
	  #};
};
  nixpkgs.config.permittedInsecurePackages = [
     "electron-25.9.0"
  ];

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
