# Waffle-builds

FlyingWaffle's personal Gentoo ebuild overlay.

## Usage

This overlay uses Gentoo and GURU as master repositories.

```sh
eselect repository enable guru waffle-builds
emerge --sync guru waffle-builds
```

Many ebuilds on this repo are 'live' (9999); take care when using those.

## Ladybird alpha

The source package, `www-client/ladybird`, uses
`media-libs/VulkanMemoryAllocator` from GURU. After enabling and syncing the
repositories above, install it with:

```sh
emerge --ask www-client/ladybird
```

The official binary package is available as `www-client/ladybird-bin`.

The overlay supplies ANGLE and Skia because the required libraries are not
packaged in Gentoo or GURU. The Ladybird ebuild builds upstream's pinned FFmpeg
with its codec selection and Vulkan decoder patches, and installs the renamed
libraries privately under `/usr/lib64/ladybird` (or `/usr/lib/ladybird`).
Gentoo's FFmpeg remains available for additional media codecs. There is no
separate FFmpeg package to install or maintain in this overlay.
The source build uses upstream's pinned mimalloc 2 and PDF.js
distributions because the available repository versions are incompatible.

Quality not guaranteed in any way, shape, or form; all ebuilds are experimental, your mileage may vary, etc.

Pull requests and bug reports welcome.
