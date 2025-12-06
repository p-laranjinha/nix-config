# nix-config

Inspired by multiple other configs including [ncfavier/config](https://github.com/ncfavier/config).

## Structure

This config has 3 main parts:

### ./flake.nix

This is where I configure the config inputs, or in other words, the dependencies and what versions to use.

Run `nix flake update` to update the inputs with a variable version, like 'latest'.

### ./lib

This is where I put my reusable variables, functions, and options.

This directory has 4 sub-directories:

**./lib/lib** is where I put my "pure"/standard functions that don't require things from other modules like 'home-manager'.
These functions extend the already existing 'lib' argument used in the modules.

**./lib/funcs** is where I put my functions that do require things from other modules.
These functions use a new 'funcs' argument.

**./lib/vars** is where I put my variables.
These variables use a new 'vars' argument.

**./lib/opts** is where I put my options that don't specify regular module functionality.
These options work almost like functions, to be used in any module as many times as needed to accomplish something specific (for example, creating a symlink).
Options like the one I use in the specification to enable/disable Sunshine should be defined in the appropriate module.

These last 3 argument names were chosen because they're unlikely to overlap with any current/future "official" arguments, and they're explicit enough.

Both 'funcs' and 'config.opts' cannot be used in the 'imports' option as they're "volatile" (defined in NixOS modules).

### ./modules

This is where I put my actual configuration. Everything from hardware and filesystem to programs and games.
