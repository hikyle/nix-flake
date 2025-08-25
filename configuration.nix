{ config, pkgs, ... }:

{
	imports = [ ./hardware-configuration.nix ];

	hardware.graphics.enable = true;
	services.xserver.videoDrivers = ["nvidia"];
	hardware.nvidia = {
		modesetting.enable = true;
		powerManagement.enable = false;
		open = true;
		nvidiaSettings = true;
		package = config.boot.kernelPackages.nvidiaPackages.production;
	};

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.blacklistedKernelModules = [ "iwlwifi" ];
	boot.kernelPackages = pkgs.linuxPackages_latest;

	networking.hostName = "nixos";
	networking.networkmanager.enable = true;

	time.timeZone = "America/New_York";

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

	services.xserver.enable = true;
	services.displayManager.sddm.enable = true;
	services.desktopManager.plasma6.enable = true;
	services.printing.enable = false;
	services.flatpak.enable = true;
	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};

	services.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	nixpkgs.config.allowUnfree = true;
	programs.firefox.enable = true;
	programs.steam.enable = true;

	users.users.kyle = {
		isNormalUser = true;
		description = "kyle";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [ ];
	};

	environment.systemPackages = with pkgs; [
		vim
		wget
		git
		gnumake
		unzip
		gcc
		ripgrep
		fd
		bat
		eza
		neovim
		nerd-fonts.jetbrains-mono
		protonplus
		fastfetch
		heroic
		gh
	];

	programs.bash = {
		promptInit = ''
			export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
		'';
		shellAliases = {
			ls = "eza -a --icons=always";
			ll = "eza -al --icons=always";
			lt = "eza -a --tree --level=1 --icons=always";
			grep = "grep --color=always";
			cat = "bat";
		};
	};

	system.stateVersion = "25.05";
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
