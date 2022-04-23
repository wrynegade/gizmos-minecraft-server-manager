*Gizmo disclaimer: All gizmos are on a they-work-on-my-machine basis. These are hacks I've thrown together to make my life easier or to serve some small purpose where there exists no better tool. If this works for you, awesome! I hope you love it. If this doesn't work, hopefully it is useful as a reference or starting point :).*

# Minecraft Server Manager
A set of simple shell utilities to manage the clutter created by the Minecraft Java server.
Worlds and server versions are managed via symbolic links in specified folders.

## Configuration
Configuration is currently in the middle of a revamp.
For now, configuration is provided by setting the following environment variables:

Variable             | Default            | Description
-------------------- | ------------------ | -------------------------------
`JAVA`               | `java`             | path to java executable
`DATA_PATH`          | `<repo-path>/data` | path for server data / binaries
`SERVER_PORT`        | `25565`            | ephemeral port for server / query
`SERVER_INITIAL_MEMORY_SIZE` | `512M`     | executable jar `-Xms` setting
`SERVER_MAXIMUM_MEMORY_SIZE` | `2G`       | executable jar `-Xmx` setting
`MCRCON_PASS`        | `''` | password for `rcon`; empty will disable `rcon`
`MCRCON_HOST`        | `127.0.0.1` | host for `rcon`; only change for remote
`MCRCON_PORT`        | `25575`            | ephemeral port for `rcon`

## Scripts
- [change-world](./change-world) : updates the current active `$WORLD` to point to the desired world within the `$UNIVERSE_PATH`
- [get-latest](./get-latest) : locates, downloads, and links the latest `server.jar` from the official Mojang source
- [install-version](./install-version) : gets a list of available server versions then downloads and links the `server.jar` for the selected version
- [run-server](./run-server) : run the server using specified environment options
