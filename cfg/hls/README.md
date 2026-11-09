# Local HLS backend patches

`patches/scaiev-vex-subword-stores.patch` fixes SCAIE-V's Vex generator:
DBusSimpleBus requires byte/halfword store values to be replicated across
word lanes, matching native stores. The original injected path passed only
the unformatted value, causing SB/SH to higher lanes to write zero.

Build from the repository root:

```sh
docker build -f docker/Dockerfile_hls_vex -t isaac-quickstart-hls-vex5:local .
```

The Dockerfile pins the previously used HLS image by digest and applies the
source patch. Its specific `.dockerignore` excludes compiler installs and
experiment build directories from the build context. The original image is
unchanged. The experimental Vex preset selects this local image; customize
it with `VEX5_HLS_IMAGE`.

Upstream this patch to the SCAIE-V repository containing
`src/scaiev/backend/VexRiscv.java`. It changes both normal and spawn generator
expressions, but only normal coupled SB/SH/SW were functionally exercised.
The recorded experiment has 48 passing injected-store checks, six native
lane checks, and a failing original RTL control using identical firmware.
