# claude-desktop-linux-bash

Based on [claude-desktop-linux-flake](https://github.com/k3d3/claude-desktop-linux-flake/), discovered via [reddit](https://www.reddit.com/r/ClaudeAI/comments/1hgsmpq/i_successfully_ran_claude_desktop_natively_on/), Claude built this all inclusive bash script to build the desktop client for Linux on Ubuntu. I would guess that it works on Debian, but I haven't tested it.

The build script assumes that you already have node, pnpm, rust, and cargo installed. If you don't, you'll need to install them first. I'm not going to include how to do that here, because it's pretty easy to find that information elsewhere.

1. First, install the required dependencies:

```bash
# Prep the ubuntu system (I use distorobox Ubuntu 22.04)
sudo apt-get install p7zip-full imagemagick icoutils git
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt update
sudo apt-get install -y nodejs
git clone https://github.com/L0g0ff/claude-desktop-linux-bash.git
cd claude-desktop-linux-bash/
sudo npm install -g electron@19.0.0 --unsafe-perm=true
```

2. Run the build script:
```bash
./build-claude-desktop.sh
```

The script will:
1. Check for required dependencies
2. Create a stub native module using Rust and NAPI-RS
3. Download and extract the Windows client
4. Process icons for Linux
5. Modify and repackage the app.asar
6. Create desktop entries and launcher scripts

The built application will be in the `claude-desktop` directory. You can run it using `./claude-desktop/bin/claude-desktop`.

A few notes:
- The script creates stub implementations for the native functions, which means some features might not work (like global shortcuts)
   - Global shortcuts are confirmed to work on Ubuntu/X11 24.04
- It includes Wayland support via environment variables
   - Global shortcuts may not be available on Wayland due to lack of implementations
- The build process requires quite a bit of disk space for intermediary files
- You might want to add the binary directory to your PATH or copy the files to system locations

# license

The build script in this repository is dual-licensed under the terms of the MIT license and the Apache License (Version 2.0). This follows the licensing of the original repository ([claude-desktop-linux-flake](https://github.com/k3d3/claude-desktop-linux-flake/)).

See [LICENSE-MIT](LICENSE-MIT) and [LICENSE-APACHE](LICENSE-APACHE) for details.

The Claude Desktop application, not included in this repository, is likely covered by [Anthropic's Consumer Terms](https://www.anthropic.com/legal/consumer-terms).
