
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-f475e108-8d9c-4807-9ceb-a4ca68d672ff".device = "/dev/disk/by-uuid/f475e108-8d9c-4807-9ceb-a4ca68d672ff";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

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
  users.users.judge = {
    isNormalUser = true;
    description = "Coal-Coloured Judgement Crow";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      discord
      google-chrome
      kate
      thunderbird
      neofetch
      vivaldi
      vivaldi-ffmpeg-codecs
      tidal-hifi
      widevine-cdm
      chatterino2

    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
                "openssl-1.1.1v"
		"python-2.7.18.6"
              ];
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: builtins.elem (builtins.parseDrvName pkg.name).name [ "steam" ]);
  nix.settings = {
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    age
    bind
    neovim
    vimPlugins.zoxide-vim
    vimPlugins.zoomwintab-vim
    vimPlugins.zk-nvim
    vimPlugins.zig-vim
    vimPlugins.zephyr-nvim
    vimPlugins.zenburn
    vimPlugins.zenbones-nvim
    vimPlugins.zen-mode-nvim
    vimPlugins.zeavim-vim
    vimPlugins.yuck-vim
    vimPlugins.yescapsquit-vim
    vimPlugins.yats-vim
    vimPlugins.xterm-color-table-vim
    vimPlugins.xptemplate
    vimPlugins.wstrip-vim
    vimPlugins.wrapping-nvim
    vimPlugins.workflowish
    vimPlugins.wombat256-vim
    vimPlugins.wmgraphviz-vim
    vimPlugins.winshift-nvim
    vimPlugins.windows-nvim
    vimPlugins.winbar-nvim
    vimPlugins.wildfire-vim
    vimPlugins.wilder-nvim
    vimPlugins.wiki-vim
    vimPlugins.wiki-ft-vim
    vimPlugins.whitespace-nvim
    vimPlugins.which-key-nvim
    vimPlugins.wgsl-vim
    vimPlugins.webapi-vim
    vimPlugins.wal-vim
    vimPlugins.vista-vim
    vimPlugins.vissort-vim
    vimPlugins.vis
    vimPlugins.virtual-types-nvim
    vimPlugins.vimwiki
    vimPlugins.vimux
    vimPlugins.vimtex
    vimPlugins.vimspector
    vimPlugins.vimshell-vim
    vimPlugins.vimsence
    vimPlugins.vimproc-vim
    vimPlugins.vimpreviewpandoc
    vimPlugins.vimoutliner
    vimPlugins.vimfiler-vim
    vimPlugins.vimelette
    vimPlugins.vimagit
    vimPlugins.vimade
    vimPlugins.vimacs
    vimPlugins.vim_current_word
    vimPlugins.vim9-stargate
    vimPlugins.vim2nix
    vimPlugins.vim2hs
    vimPlugins.vim-zettel
    vimPlugins.vim-yapf
    vimPlugins.vim-yaml
    vimPlugins.vim-xkbswitch
    vimPlugins.vim-xtabline
    vimPlugins.vim-xdebug
    vimPlugins.vim-wordy
    vimPlugins.vim-wordmotion
    vimPlugins.vim-windowswap
    vimPlugins.vim-which-key
    vimPlugins.vim-wayland-clipboard
    vimPlugins.vim-watchdogs
    vimPlugins.vim-wakatime
    vimPlugins.vim-vue-plugin
    vimPlugins.vim-vue
    vimPlugins.vim-vsnip-integ
    vimPlugins.vim-vsnip
    vimPlugins.vim-vp4
    vimPlugins.vim-visualstar
    vimPlugins.vim-visual-star-search
    vimPlugins.vim-visual-increment
    vimPlugins.vim-vinegar
    vimPlugins.vim-vagrant
    vimPlugins.vim-unimpaired
    vimPlugins.vim-unicoder
    vimPlugins.vim-ultest
    vimPlugins.vim-twiggy
    vimPlugins.vim-twig
    vimPlugins.vim-tsx
    vimPlugins.vim-tridactyl
    vimPlugins.vim-trailing-whitespace
    vimPlugins.vim-tpipeline
    vimPlugins.vim-toml
    vimPlugins.vim-togglelist
    vimPlugins.vim-tmux-navigator
    vimPlugins.vim-tmux-clipboard
    vimPlugins.vim-tmux
    vimPlugins.vim-themis
    wineWowPackages.waylandFull
    wineWowPackages.unstableFull
    wineWowPackages.stagingFull
    wineWowPackages.full
    wineWowPackages.fonts
    wineWow64Packages.waylandFull
    wineWow64Packages.unstableFull
    wineWow64Packages.stagingFull
    wineWow64Packages.full
    wineWow64Packages.fonts
    winePackages.waylandFull
    winePackages.unstableFull
    winePackages.stagingFull
    winePackages.full
    wine-wayland
    wine-staging
    wine
    wine64
    winetricks
    wineasio
    winePackages.fonts
    bottles
    bottles-unwrapped
    steamPackages.steamcmd
    steamPackages.steam-runtime-wrapped
    steamPackages.steam-runtime
    steamPackages.steam-fhsenv-without-steam
    steamPackages.steam
    podman
    podman-desktop
    podman-tui
    podman-compose
    guix
    apx
    emacs
    emacsPackages.guix
    emacsPackages.twitch-api
    emacsPackages.helm-twitch
    emacsPackages.zzz-to-char
    emacsPackages.zygospore
    emacsPackages.kdeconnect
    davinci-resolve
    android-tools
    android-udev-rules
    android-file-transfer
    androidStudioPackages.canary
    anbox
    apkid
    genymotion
    apktool
    git-repo
    gnugrep
    gnumake
    flameshot
    eww
    powershell
    rofi
    ripgrep
    btop
    cached-nix-shell
    cloudflared
    duf
    eza
    jq
    killall
    micro
    mosh
    nettools
    nmap
    nvd
    python3
    sops
    tldr
    tmux
    traceroute
    ugrep
    wget
    whois
    acpi
    appimage-run
    asciinema
    aspell
    aspellDicts.de
    aspellDicts.en
    ffmpegthumbnailer
    floorp
    freerdp
    element-desktop-wayland
    element-desktop
    gimp
    revolt-desktop
    helvum
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    inkscape
    krita
    libreoffice-qt
    libsForQt5.kdenlive
    libsForQt5.kleopatra
    libsForQt5.krdc
    libsForQt5.krfb
    libsecret
    libva-utils
    lm_sensors
    movit
    nextcloud-client
    okular
    qbittorrent
    rustdesk
    syncthingtray
    telegram-desktop
    tor-browser
    usbutils
    vorta
    vulkan-tools
    yt-dlp
    ansible
    beekeeper-studio
    bind.dnsutils
    deadnix
    gh
    heroku
    discord-canary
    discord-gamesdk
    hugo
    manix
    mongodb-compass
    nerdctl
    nix-prefetch-git
    nixd
    nixos-generators
    nixpkgs-lint
    nixpkgs-review
    nodePackages_latest.prettier
    nodejs
    pacman
    ruff
    shellcheck
    shfmt
    speedcrunch
    statix
    termius
    vagrant
    ventoy-full
    xdg-utils
    yarn
    yubikey-manager-qt
    yubioath-flutter
    ocrmypdf
    speedcrunch
    sqlite
    sqlitebrowser
    btrfs-progs
    fwupd
    fwupd-efi
    dosfstools
    e2fsprogs
    efibootmgr
    flashrom
    gparted
    home-manager
    hwinfo
    qemu-utils
    rsync
    testdisk
    fish
    zsh
    curl
    flatpak
    libsForQt5.kdeconnect-kde
    git-lfs
    git
    github-desktop
    virt-manager
    gitkraken
    gnome.gnome-boxes
    vim
    nano
    distrobox
    qemu
    kde-gruvbox
    catppuccin-kde
    kde-rounded-corners
    steam
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  virtualisation.libvirtd.enable = true; 
  # enable flatpak support
  services.flatpak.enable = true;
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      (nerdfonts.override { fonts = [ "Meslo" ]; })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
	      monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
	      serif = [ "Noto Serif" "Source Han Serif" ];
	      sansSerif = [ "Noto Sans" "Source Han Sans" ];
        };
     };
  };
  
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;
  system.autoUpgrade.enable = true;  
  system.autoUpgrade.allowReboot = false; 
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.11";
  


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
