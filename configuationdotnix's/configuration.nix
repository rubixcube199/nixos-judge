{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      ./uki.nix
#      ./lanzaboote.nix
#      ./chaotic.nix
    ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

 boot = {
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      timeout = 1;
      systemd-boot.enable = true;
#      loader.systemd-boot.enable = lib.mkForce false;
#    lanzaboote = {
#      enable = true;
#      pkiBundle = "/etc/secureboot";
      efi.canTouchEfiVariables = true;
     };
   };

#  boot.initrd.luks.devices."luks-0a565eff-e722-43c8-9305-0fa46c0717f9".device = "/dev/disk/by-uuid/0a565eff-e722-43c8-9305-0fa46c0717f9";


   networking.hostName = "judgemental"; # Define your hostname.
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
  programs.hyprland.enable = true;
  programs.river.enable = true;
  programs.wayfire.enable = true;
  programs.miriway.enable = true;
  #services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.cinnamon.enable = true;
  #services.xserver.desktopManager.deepin.enable = true;

    systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  
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
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.judge = {
    isNormalUser = true;
    description = "Coal-Coloured Judgement Crow";
    extraGroups = [
      "root"
      "flatpak"
      "disk"
      "qemu"
      "kvm"
      "sshd"
      "networkmanager"
      "storage"
      "optical"
      "sys"
      "tty"
      "wheel"
      "audio"
      "video"
      "libvirtd"
    ];
  };

  documentation.nixos.enable = false; # .desktop
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.joypixels.acceptLicense = true;
  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
  };

     # This is meant to be for x86_64 only, need to use a different config for aarch64
  nixpkgs.hostPlatform = "x86_64-linux";

  # Hardened SSH configuration
  services.openssh = {
    extraConfig = ''
      AllowTcpForwarding no
      HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com
      PermitTunnel no
    '';
    settings = {
      Ciphers = [
        "aes256-gcm@openssh.com"
        "aes256-ctr,aes192-ctr"
        "aes128-ctr"
        "aes128-gcm@openssh.com"
        "chacha20-poly1305@openssh.com"
      ];
      KbdInteractiveAuthentication = false;
      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "sntrup761x25519-sha512@openssh.com"
      ];

      X11Forwarding = false;
    };
  };

  # Client side SSH configuration
  programs.ssh = {
    ciphers = [
      "aes256-gcm@openssh.com"
      "aes256-ctr,aes192-ctr"
      "aes128-ctr"
      "aes128-gcm@openssh.com"
      "chacha20-poly1305@openssh.com"
    ];
    hostKeyAlgorithms = [
      "ssh-ed25519"
      "ssh-ed25519-cert-v01@openssh.com"
      "sk-ssh-ed25519@openssh.com"
      "sk-ssh-ed25519-cert-v01@openssh.com"
      "rsa-sha2-512"
      "rsa-sha2-512-cert-v01@openssh.com"
      "rsa-sha2-256"
      "rsa-sha2-256-cert-v01@openssh.com"
    ];
    kexAlgorithms = [
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
      "sntrup761x25519-sha512@openssh.com"
    ];
    knownHosts = {
      aur-rsa = {
        hostNames = ["aur.archlinux.org"];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKF9vAFWdgm9Bi8uc+tYRBmXASBb5cB5iZsB7LOWWFeBrLp3r14w0/9S2vozjgqY5sJLDPONWoTTaVTbhe3vwO8CBKZTEt1AcWxuXNlRnk9FliR1/eNB9uz/7y1R0+c1Md+P98AJJSJWKN12nqIDIhjl2S1vOUvm7FNY43fU2knIhEbHybhwWeg+0wxpKwcAd/JeL5i92Uv03MYftOToUijd1pqyVFdJvQFhqD4v3M157jxS5FTOBrccAEjT+zYmFyD8WvKUa9vUclRddNllmBJdy4NyLB8SvVZULUPrP3QOlmzemeKracTlVOUG1wsDbxknF1BwSCU7CmU6UFP90kpWIyz66bP0bl67QAvlIc52Yix7pKJPbw85+zykvnfl2mdROsaT8p8R9nwCdFsBc9IiD0NhPEHcyHRwB8fokXTajk2QnGhL+zP5KnkmXnyQYOCUYo3EKMXIlVOVbPDgRYYT/XqvBuzq5S9rrU70KoI/S5lDnFfx/+lPLdtcnnEPk=";
      };
      aur-ed25519 = {
        hostNames = ["aur.archlinux.org"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuBKrPzbawxA/k2g6NcyV5jmqwJ2s+zpgZGZ7tpLIcN";
      };
      github-rsa = {
        hostNames = ["github.com"];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
      };
      github-ed25519 = {
        hostNames = ["github.com"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
      gitlab-rsa = {
        hostNames = ["gitlab.com"];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9";
      };
      gitlab-ed25519 = {
        hostNames = ["gitlab.com"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      };
    };
  };

  # Enable all hardware drivers
  hardware.enableRedistributableFirmware = true;
  environment.systemPackages = with pkgs; [
    vim
    home-manager
    audit
    libargon2
    gzip
    obs-studio
    obs-cli
    neofetch
    floorp
    gtklock
    gtklock-powerbar-module
    gtklock-userinfo-module
    gtklock-playerctl-module
    playerctl
    fuzzel
    foot
    gjs
    gnome.gnome-control-center
    gnome.gnome-bluetooth
    waybar-mpris
    waybar
    plank
    gobject-introspection
    gtk2
    gtk3
    gtk4
    gtk-layer-shell
    meson
    unzip
    gcc
    clang
    rocmPackages.llvm.clang
    meson-tools
    libdbusmenu-gtk2
    swww
    waypaper
    wlogout
    libdbusmenu-gtk3
    nodejs_18
    nodejs_20
    nodejs_21
    sassc
    swayidle
    typescript
    guile 
    json_c
    upower
    webp-pixbuf-loader
    tesseract
    yad
    ydotool
    adw-gtk3
    gradience
    cava
    gojq
    discord
    kate
    tmux
    zellij
    grim
    gnome.nautilus
    slurp
    wl-clipboard
    git-repo
    powershell
    btop
    ripgrep
    eww
    swaybg
    lolcat
    apktool
    genymotion
    killall
    gnome.gnome-keyring
    android-tools
    android-udev-rules
    discord-canary
    podman-compose
    podman-desktop
    podman-tui
    podman
    guix
    apx
    appimage-run
    whois
    nettools
    nmap
    nvd
    python3
    sops
    tldr
    tmux
    github-cli
    git
    github-desktop
    wget
    curl
    zsh
    neovim
    emacs
    fish
    kitty
    alacritty
    sbctl
    distrobox
    podman
    flatpak
    gnome.gnome-boxes
    home-manager
    neovim
    git
    wget
    kitty
    alacritty
    sassc
    swww
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
    brightnessctl
    flatpak
    nerdfonts
    age
    bind
    neovim
    catppuccin
    catppuccin-kde
    tmuxPlugins.catppuccin
    catppuccin-gtk
    catppuccin-kvantum
    catppuccin-cursors
    vimPlugins.catppuccin-vim
    vimPlugins.catppuccin-nvim
    emacsPackages.catppuccin-theme
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
    blueberry
    bluez
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
    p7zip
    unzip
    xclip
    libsForQt5.kded
    libsForQt5.kdev-php
    libsForQt5.kdesu
    libsForQt5.kdevelop
    libsForQt5.kdev-python
    libsForQt5.kdeclarative
    libsForQt5.kdecoration
    libsForQt5.kdepim-addons
    libsForQt5.kde-cli-tools
    libsForQt5.kdevelop-pg-qt
    libsForQt5.kdepim-runtime
    libsForQt5.kdebugsettings
    libsForQt5.kde-gtk-config
    libsForQt5.kdesignerplugin
    libsForQt5.kdelibs4support
    libsForQt5.kde2-decoration
    libsForQt5.kdeplasma-addons
    libsForQt5.kdevelop-unwrapped
    libsForQt5.kde-inotify-survey
    libsForQt5.kdenetwork-filesharing
    libsForQt5.kdegraphics-mobipocket
    libsForQt5.kdegraphics-thumbnailers
    plasma-hud
    plasma-pass
    libsForQt5.plasma-pa
    libsForQt5.plasma-nm
    libsForQt5.plasmatube
    libsForQt5.plasma-sdk
    libsForQt5.plasma-integration
    libsForQt5.plasma-browser-integration
    plasma-theme-switcher
    wacomtablet
    kile
    flatpak-builder
    sweet-nova
    libsForQt5.flatpak-kcm
    weechat-unwrapped
    weechat
    libsForQt5.neochat
    protontricks
    protonup-qt
    protonup-ng
    electron-mail
    vscode-with-extensions
    emacsPackages.weechat
    nodePackages_latest.emojione
    haskellPackages.emoji
    emojione
    emote
    joypixels
  ];

 # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

 # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General.Experimental = true; # for gnome-bluetooth percentage
  };

#  virtualisation.libvirtd.enable = true;
programs.virt-manager.enable = true;
  virtualisation = {
    podman.enable = true;
    libvirtd.enable = true;
  };
  # enable flatpak support
  services.flatpak.enable = true;
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # kde connect
  networking.firewall = rec {
    allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      inconsolata-nerdfont
      fira-code-nerdfont
      terminus-nerdfont
      nerdfonts
      noto-fonts-monochrome-emoji
      noto-fonts-emoji-blob-bin
      noto-fonts-color-emoji
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-lgc-plus
      lohit-fonts.odia
      lohit-fonts.tamil
      lohit-fonts.telugu
      lohit-fonts.sindhi
      lohit-fonts.nepali
      lohit-fonts.marathi
      lohit-fonts.maithili
      lohit-fonts.konkani
      lohit-fonts.kashmiri
      lohit-fonts.kannada
      lohit-fonts.gujarati
      lohit-fonts.bengali
      lohit-fonts.assamese
      lohit-fonts.malayalam
      lohit-fonts.tamil-classical
      lohit-fonts.gurmukhi
      lohit-fonts.devanagari
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
  system.autoUpgrade.allowReboot = true;
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-23.05";

  # This value determines the NixOS release
  system.stateVersion = "24.05"; # Did you read the comment?

}
