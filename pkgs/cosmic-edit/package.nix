{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  fontconfig,
  freetype,
  glib,
  gtk3,
  just,
  libinput,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-edit";
  version = "1.0.0-alpha.3-unstable-2024-11-07";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-edit";
    rev = "9ae988db678bb273a59a479df38ace380d209636";
    hash = "sha256-YEopRkE81ImPy/kOoBaLSAg6dHzs6YjUkUhlAZXFOJg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.16.0" = "sha256-yeBzocXxuvHmuPGMRebbsYSKSvN+8sUsmaSKlQDpW4w=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-tovB4fjPVVRY8LKn5albMzskFQ+1W5ul4jT5RXx9gKE=";
      "cosmic-config-0.1.0" = "sha256-pnO7IwZS56RfGVytV52weDEO1xcd3M4oUV+bUeUoBLc=";
      "cosmic-files-0.1.0" = "sha256-KciDPlr3CvG1WezdZyEHD4hQ2w0wX2hl6akB1DA6xB0=";
      "cosmic-syntax-theme-0.1.0" = "sha256-BNb9wrryD5FJImboD3TTdPRIfiBqPpItqwGdT1ZiNng=";
      "cosmic-text-0.12.1" = "sha256-nCw3RNIHINXH4+m9wKB+0CeoXSVKKxP+ylaZhfp8u+o=";
      "dpi-0.1.1" = "sha256-whi05/2vc3s5eAJTZ9TzVfGQ/EnfPr0S4PZZmbiYio0=";
      "fs_extra-1.3.0" = "sha256-ftg5oanoqhipPnbUsqnA4aZcyHqn9XsINJdrStIPLoE=";
      "iced_glyphon-0.6.0" = "sha256-u1vnsOjP8npQ57NNSikotuHxpi4Mp/rV9038vAgCsfQ=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "trash-5.1.1" = "sha256-So8rQ8gLF5o79Az396/CQY/veNo4ticxYpYZPfMJyjQ=";
    };
  };

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];
  buildInputs = [
    glib
    gtk3
    libinput
    fontconfig
    freetype
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-edit"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-edit";
    description = "Text Editor for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-edit";
  };
}
