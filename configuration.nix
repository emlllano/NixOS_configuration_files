#my /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

   boot.kernelParams = [
	"nvidia-drm.modeset=1"
	"video=1920x1080_144"			#works 50% of the time for some reason
	
	];

  # bootloader
  boot.loader = {
	efi = {
  	canTouchEfiVariables = false;
	};
  grub = {						#still loving grub
	efiSupport = true;
	efiInstallAsRemovable = true;
	device = "nodev";
	};
	};

  networking.hostName = "nix"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # enable the window manager/ de
  services.xserver.displayManager.lightdm.enable = true;
    services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [ i3blocks dmenu ];

  };    

  #bluetooth
  services.blueman.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  #nvidia drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;

  # enable printing services
  services.printing.enable = true;

  #pulseaudio
  sound.enable = true;
  hardware.pulseaudio.enable = true;
#  hardware.pulseaudio.support32bit = true; #works 50% of the time as well
  hardware.pulseaudio.extraConfig = "load-module module-combine-sink";
  security.rtkit.enable = true;

  #auto updates
  system.autoUpgrade = {
	enable = true;
	channel = "https://nixos.org/channels/nixos-unstable";   #do not copy me here 
	};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # User account + user packages
  users.users.emiliano = {
    isNormalUser = true;
    description = "emiliano";
    extraGroups = [ "networkmanager" "kvm" "input" "libvirtd" "audio" "libvirt"  "wheel" ];
    packages = with pkgs; [
	firefox
	chatgpt-cli
	yai
	etcher
	pcsx2
	signal-desktop
	discord
	qbittorrent
	vlc
	obsidian
    ];
  };

  # auto login not used
#  services.xserver.displayManager.autoLogin.enable = true;
#  services.xserver.displayManager.autoLogin.user = "emiliano";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true;

  programs.steam = {
	enable = true;
	remotePlay.openFirewall = true;
	dedicatedServer.openFirewall = true;
	};

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

   #insecure packages, pretty sure there's another way of doing that
  nixpkgs.config.permittedInsecurePackages = [
	"electron-12.2.3"
	"nodejs-16.20.2"
	];
  
  # System packages
  environment.systemPackages = with pkgs; [
	neofetch
	ipfetch	
	util-linux
	lxappearance
	protonup-qt
	protonup-ng
	xorg.xprop
	font-manager
	virt-manager
	qemu_full
	OVMF
	libguestfs
	libvirt
	blueberry
	meslo-lg
	xorg.xdpyinfo
	gawk
	pavucontrol
	fakeroot
	lm_sensors
	openrgb
	sysstat
	imagemagick
	neovim
	vim
	sc-controller
	code-server
	pipewire
	wireplumber
	rpm
	breeze-icons
	capitaine-cursors
	qt5ct
	unzip
	unrar
	rar
	rs
	st
	git
	wget
  ];

  fonts.packages = with pkgs; [
	font-awesome
    dejavu_fonts
	hack-font
	nerdfonts
	liberation_ttf
	fira-code
	fira-code-symbols
    noto-fonts
];

system.stateVersion = "23.05"; # Did you read the comment?

}
