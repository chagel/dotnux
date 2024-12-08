# dotmac - Dotfiles for macOS

This repository contains my dotfiles for macOS, building on the foundation provided by the [dotbase](https://github.com/chagel/dotbase) repository.

The base configuration is maintained in the [dotbase](dotbase) repository, while this repository holds the specific configurations tailored for my setup. By structuring it this way, I can easily update the base configuration and customize my setup without conflicts. Submodules are used to incorporate the base configuration into this repository.

This repository also serves as an example to demonstrate how to use the [dotbase](dotbase) repository. I hope you find it useful and inspiring. :)

## Features
- **Base Configurations:** Includes settings for Vim, tmux, and more (from dotbase).
- **Specific Configurations:** Custom settings for fish, kitty, etc.
- **Scripts:** Collection of useful tools and hacks.
- **Makefile:** Human-readable commands for easy management.

## Installation
1. Clone this repository:
   ```sh
   git clone https://github.com/chagel/dotmac.git
   ```
2. Check the `Makefile` for available commands.
3. Run `make link` to link the dotfiles:
   ```sh
   make link
   ```

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
