#!/bin/bash
#
# Build script for Claude Desktop on Linux
# Supports both DNF and Debian/Ubuntu (apt) based systems
#
# This script downloads the Windows version of Claude Desktop and
# creates a Linux-compatible version with native bindings.
#
# Usage: ./build-claude-desktop.sh
#
# Dependencies will be checked and installation instructions provided
# for the detected package manager (dnf or apt-get)

set -euo pipefail

# Configuration
CLAUDE_VERSION="0.7.8"  # Updated to match current version
CLAUDE_URL="https://storage.googleapis.com/osprey-downloads-c02f6a0d-347c-492b-a752-3e0651722e97/nest-win-x64/Claude-Setup-x64.exe"
WORK_DIR="$(pwd)/claude-build"
OUTPUT_DIR="$(pwd)/claude-desktop"

# Package definitions for different distributions
DNF_PACKAGES="p7zip p7zip-plugins nodejs rust cargo electron ImageMagick icoutils"
DEBIAN_PACKAGES="p7zip-full nodejs cargo rustc electron imagemagick icoutils"

# Logging functions
log_info() {
    echo -e "\033[0;32m[INFO]\033[0m $1"
}

log_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1" >&2
}

log_warning() {
    echo -e "\033[0;33m[WARNING]\033[0m $1"
}

# Error handling
handle_error() {
    log_error "An error occurred on line $1"
    exit 1
}

trap 'handle_error $LINENO' ERR

# Detect package manager and set appropriate commands/packages
detect_package_manager() {
    if command -v dnf >/dev/null 2>&1; then
        log_info "DNF-based system detected"
        PKG_MANAGER="dnf"
        PKG_INSTALL="sudo dnf install -y"
        PACKAGES="$DNF_PACKAGES"
    elif command -v apt-get >/dev/null 2>&1; then
        log_info "Debian-based system detected"
        PKG_MANAGER="apt"
        PKG_INSTALL="sudo apt-get install -y"
        PACKAGES="$DEBIAN_PACKAGES"
    else
        log_error "Unsupported package manager. This script supports dnf and apt (Debian/Ubuntu)"
        exit 1
    fi
}

# Check for the correct ImageMagick command
check_image_command() {
    if command -v magick >/dev/null 2>&1; then
        IMAGE_CMD="magick"
    elif command -v convert >/dev/null 2>&1; then
        IMAGE_CMD="convert"
    else
        return 1
    fi
    return 0
}

# Check for required dependencies
check_dependencies() {
    local deps=("7za" "pnpm" "node" "cargo" "rustc" "electron" "wrestool" "icotool")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing+=("$dep")
        fi
    done
    
    # Check for either magick or convert
    if ! check_image_command; then
        missing+=("ImageMagick")
    fi

    if [ ${#missing[@]} -ne 0 ]; then
        detect_package_manager
        log_warning "Missing required dependencies: ${missing[*]}"
        log_info "Please install them using:"
        echo "${PKG_INSTALL} ${PACKAGES}"
        log_info "And install pnpm using: curl -fsSL https://get.pnpm.io/install.sh | sh -"
        exit 1
    fi
}

# Create and setup the patchy-cnb native module
setup_patchy_cnb() {
    log_info "Setting up patchy-cnb native module..."
    mkdir -p "$WORK_DIR/patchy-cnb"
    cd "$WORK_DIR/patchy-cnb"
    
    # Create Cargo.toml with minimal dependencies
    cat > Cargo.toml << 'EOF'
[package]
name = "patchy-cnb"
version = "0.1.0"
edition = "2021"

[lib]
crate-type = ["cdylib"]

[dependencies]
napi = { version = "2.12.2", default-features = false, features = ["napi4"] }
napi-derive = "2.12.2"
EOF

    # Create stub implementation for native bindings
    mkdir -p src
    cat > src/lib.rs << 'EOF'
#![deny(clippy::all)]

#[macro_use]
extern crate napi_derive;

#[napi]
pub enum KeyboardKey {
    Num0,
    Num1,
    Num2,
    Num3,
    Num4,
    Num5,
    Num6,
    Num7,
    Num8,
    Num9,
    A,
    B,
    C,
    D,
    E,
    F,
    G,
    H,
    I,
    J,
    K,
    L,
    M,
    N,
    O,
    P,
    Q,
    R,
    S,
    T,
    U,
    V,
    W,
    X,
    Y,
    Z,
    AbntC1,
    AbntC2,
    Accept,
    Add,
    Alt,
    Apps,
    Attn,
    Backspace,
    Break,
    Begin,
    BrightnessDown,
    BrightnessUp,
    BrowserBack,
    BrowserFavorites,
    BrowserForward,
    BrowserHome,
    BrowserRefresh,
    BrowserSearch,
    BrowserStop,
    Cancel,
    CapsLock,
    Clear,
    Command,
    ContrastUp,
    ContrastDown,
    Control,
    Convert,
    Crsel,
    DBEAlphanumeric,
    DBECodeinput,
    DBEDetermineString,
    DBEEnterDLGConversionMode,
    DBEEnterIMEConfigMode,
    DBEEnterWordRegisterMode,
    DBEFlushString,
    DBEHiragana,
    DBEKatakana,
    DBENoCodepoint,
    DBENoRoman,
    DBERoman,
    DBESBCSChar,
    DBESChar,
    Decimal,
    Delete,
    Divide,
    DownArrow,
    Eject,
    End,
    Ereof,
    Escape,
    Execute,
    Excel,
    F1,
    F2,
    F3,
    F4,
    F5,
    F6,
    F7,
    F8,
    F9,
    F10,
    F11,
    F12,
    F13,
    F14,
    F15,
    F16,
    F17,
    F18,
    F19,
    F20,
    F21,
    F22,
    F23,
    F24,
    F25,
    F26,
    F27,
    F28,
    F29,
    F30,
    F31,
    F32,
    F33,
    F34,
    F35,
    Function,
    Final,
    Find,
    GamepadA,
    GamepadB,
    GamepadDPadDown,
    GamepadDPadLeft,
    GamepadDPadRight,
    GamepadDPadUp,
    GamepadLeftShoulder,
    GamepadLeftThumbstickButton,
    GamepadLeftThumbstickDown,
    GamepadLeftThumbstickLeft,
    GamepadLeftThumbstickRight,
    GamepadLeftThumbstickUp,
    GamepadLeftTrigger,
    GamepadMenu,
    GamepadRightShoulder,
    GamepadRightThumbstickButton,
    GamepadRightThumbstickDown,
    GamepadRightThumbstickLeft,
    GamepadRightThumbstickRight,
    GamepadRightThumbstickUp,
    GamepadRightTrigger,
    GamepadView,
    GamepadX,
    GamepadY,
    Hangeul,
    Hangul,
    Hanja,
    Help,
    Home,
    Ico00,
    IcoClear,
    IcoHelp,
    IlluminationDown,
    IlluminationUp,
    IlluminationToggle,
    IMEOff,
    IMEOn,
    Insert,
    Junja,
    Kana,
    Kanji,
    LaunchApp1,
    LaunchApp2,
    LaunchMail,
    LaunchMediaSelect,
    Launchpad,
    LaunchPanel,
    LButton,
    LControl,
    LeftArrow,
    Linefeed,
    LMenu,
    LShift,
    LWin,
    MButton,
    MediaFast,
    MediaNextTrack,
    MediaPlayPause,
    MediaPrevTrack,
    MediaRewind,
    MediaStop,
    Meta,
    MissionControl,
    ModeChange,
    Multiply,
    NavigationAccept,
    NavigationCancel,
    NavigationDown,
    NavigationLeft,
    NavigationMenu,
    NavigationRight,
    NavigationUp,
    NavigationView,
    NoName,
    NonConvert,
    None,
    Numlock,
    Numpad0,
    Numpad1,
    Numpad2,
    Numpad3,
    Numpad4,
    Numpad5,
    Numpad6,
    Numpad7,
    Numpad8,
    Numpad9,
    OEM1,
    OEM102,
    OEM2,
    OEM3,
    OEM4,
    OEM5,
    OEM6,
    OEM7,
    OEM8,
    OEMAttn,
    OEMAuto,
    OEMAx,
    OEMBacktab,
    OEMClear,
    OEMComma,
    OEMCopy,
    OEMCusel,
    OEMEnlw,
    OEMFinish,
    OEMFJJisho,
    OEMFJLoya,
    OEMFJMasshou,
    OEMFJRoya,
    OEMFJTouroku,
    OEMJump,
    OEMMinus,
    OEMNECEqual,
    OEMPA1,
    OEMPA2,
    OEMPA3,
    OEMPeriod,
    OEMPlus,
    OEMReset,
    OEMWsctrl,
    Option,
    PA1,
    Packet,
    PageDown,
    PageUp,
    Pause,
    Play,
    Power,
    Print,
    Processkey,
    RButton,
    RCommand,
    RControl,
    Redo,
    Return,
    RightArrow,
    RMenu,
    ROption,
    RShift,
    RWin,
    Scroll,
    ScrollLock,
    Select,
    ScriptSwitch,
    Separator,
    Shift,
    ShiftLock,
    Sleep,
    Snapshot,
    Space,
    Subtract,
    Super,
    SysReq,
    Tab,
    Undo,
    UpArrow,
    VidMirror,
    VolumeDown,
    VolumeMute,
    VolumeUp,
    MicMute,
    Windows,
    XButton1,
    XButton2,
    Zoom,
}

#[napi]
pub enum ScrollDirection {
    Down = 0,
    Up = 1,
}

#[napi]
pub enum MouseButton {
    Left = 0,
    Middle = 1,
    Right = 2,
}

#[napi]
pub struct MousePosition {
    pub x: u32,
    pub y: u32,
}

#[napi]
pub enum RequestAccessibilityOptions {
    ShowDialog,
    OnlyRegisterInSettings,
}

#[napi]
pub struct MonitorInfo {
    pub x: u32,
    pub y: u32,
    pub width: u32,
    pub height: u32,
    pub monitor_name: String,
    pub is_primary: bool,
}

#[napi]
pub struct WindowInfo {
    pub handle: u32,
    pub process_id: u32,
    pub executable_path: String,
    pub title: String,
    pub x: u32,
    pub y: u32,
    pub width: u32,
    pub height: u32,
}

#[napi]
pub fn request_accessibility(options: i32) -> bool {
    println!("request_accessibility {options}");
    true
}

#[napi]
pub fn get_window_info() -> Vec<WindowInfo> {
    println!("get_window_info");
    vec![]
}

#[napi]
pub fn get_active_window_handle() -> u32 {
    println!("get_active_window_handle");
    0
}

#[napi]
pub fn get_monitor_info() -> MonitorInfo {
    println!("get_monitor_info");
    MonitorInfo {
        x: 0,
        y: 0,
        width: 1920,
        height: 1080,
        monitor_name: "\\\\.\\DISPLAY1".to_string(),
        is_primary: true,
    }
}

#[napi]
pub fn focus_window(handle: u32) {
    println!("focus_window {handle}");
}

#[napi(constructor)]
pub struct InputEmulator {}

#[napi]
impl InputEmulator {
    #[napi]
    pub fn copy(&self) {
        println!("IE copy");
    }

    #[napi]
    pub fn cut(&self) {
        println!("IE cut");
    }

    #[napi]
    pub fn paste(&self) {
        println!("IE paste");
    }

    #[napi]
    pub fn undo(&self) {
        println!("IE undo");
    }

    #[napi]
    pub fn select_all(&self) {
        println!("IE select all");
    }

    #[napi]
    pub fn held(&self) -> Vec<u16> {
        println!("IE held");
        vec![]
    }

    #[napi]
    pub fn press_chars(&self, text: String) {
        println!("IE press chars '{text}'");
    }

    #[napi]
    pub fn press_key(&self, key: Vec<i32>) {
        println!("IE press key {key:?}");
    }

    #[napi]
    pub fn press_then_release_key(key: Vec<i32>) {
        println!("IE press then release key {key:?}");
    }

    #[napi]
    pub fn release_chars(&self, text: String) {
        println!("IE release chars '{text}'");
    }

    #[napi]
    pub fn release_key(&self, key: u32) {
        println!("IE release key {key}");
    }

    #[napi]
    pub fn set_button_click(&self, button: i32) {
        println!("IE set button click {button}");
    }

    #[napi]
    pub fn set_button_toggle(&self, button: i32) {
        println!("IE set button toggle {button}");
    }

    #[napi]
    pub fn get_mouse_position(&self) -> MousePosition {
        println!("IE get mouse position");
        MousePosition { x: 0, y: 0 }
    }

    #[napi]
    pub fn type_text(&self, text: String) {
        println!("IE type text '{text}'");
    }

    #[napi]
    pub fn set_mouse_scroll(&self, direction: i32, amount: i32) {
        println!("IE set mouse scroll {direction} {amount}");
    }
}
EOF

    # Create package.json
    cat > package.json << EOF
{
  "name": "patchy-cnb",
  "version": "0.1.0",
  "main": "index.js",
  "napi": {
    "name": "patchy-cnb",
    "triples": {
      "defaults": false,
      "additional": [
        "x86_64-unknown-linux-gnu"
      ]
    }
  },
  "scripts": {
    "build": "napi build --platform --release"
  },
  "devDependencies": {
    "@napi-rs/cli": "^2.18.4"
  }
}
EOF

    # Build native module with error handling
    log_info "Building native module..."
    if ! pnpm install; then
        log_error "Failed to install dependencies for native module"
        exit 1
    fi

    if ! pnpm run build; then
        log_error "Failed to build native module"
        exit 1
    fi

    # Verify build output
    if [ ! -f "patchy-cnb.linux-x64-gnu.node" ]; then
        log_error "Native module build failed - output file not found"
        exit 1
    fi
}

# Download and extract the Windows client
download_and_extract() {
    log_info "Downloading Claude Desktop..."
    mkdir -p "$WORK_DIR"
    cd "$WORK_DIR"
    
    if [ ! -f "Claude-Setup-x64.exe" ]; then
        wget "$CLAUDE_URL" -O "Claude-Setup-x64.exe" || {
            log_error "Failed to download Claude Desktop"
            exit 1
        }
    fi
    
    log_info "Extracting..."
    7z x -y "Claude-Setup-x64.exe" || {
        log_error "Failed to extract Claude-Setup-x64.exe"
        exit 1
    }
    
    # Find the actual nupkg file instead of assuming the name
    NUPKG_FILE=$(find . -name "*.nupkg" | head -n 1)
    if [ -z "$NUPKG_FILE" ]; then
        log_error "Could not find .nupkg file"
        exit 1
    fi
    
    7z x -y "$NUPKG_FILE" || {
        log_error "Failed to extract $NUPKG_FILE"
        exit 1
    }
}

# Process icons
process_icons() {
    log_info "Processing icons..."
    cd "$WORK_DIR"
    
    wrestool -x -t 14 "lib/net45/claude.exe" -o claude.ico || {
        log_error "Failed to extract icons from claude.exe"
        exit 1
    }
    
    icotool -x claude.ico || {
        log_error "Failed to convert ico file"
        exit 1
    }
    
    mkdir -p "$OUTPUT_DIR/share/icons/hicolor"
    for size in 16 24 32 48 64 256; do
        mkdir -p "$OUTPUT_DIR/share/icons/hicolor/${size}x${size}/apps"
        $IMAGE_CMD "claude_*${size}x${size}x32.png" \
            "$OUTPUT_DIR/share/icons/hicolor/${size}x${size}/apps/claude.png" || {
            log_warning "Failed to convert icon for size ${size}x${size}"
        }
    done
}

# Process and repackage app.asar
process_asar() {
    log_info "Processing app.asar..."
    cd "$WORK_DIR"
    
    mkdir -p "$OUTPUT_DIR/lib/claude-desktop"
    cp "lib/net45/resources/app.asar" "$OUTPUT_DIR/lib/claude-desktop/" || {
        log_error "Failed to copy app.asar"
        exit 1
    }
    
    cp -r "lib/net45/resources/app.asar.unpacked" "$OUTPUT_DIR/lib/claude-desktop/" || {
        log_error "Failed to copy app.asar.unpacked"
        exit 1
    }
    
    cd "$OUTPUT_DIR/lib/claude-desktop"
    npx asar extract app.asar app.asar.contents || {
        log_error "Failed to extract app.asar"
        exit 1
    }
    
    # Replace native bindings
    cp "$WORK_DIR/patchy-cnb/patchy-cnb.linux-x64-gnu.node" \
        "app.asar.contents/node_modules/claude-native/claude-native-binding.node" || {
        log_error "Failed to copy native binding to app.asar.contents"
        exit 1
    }
    
    cp "$WORK_DIR/patchy-cnb/patchy-cnb.linux-x64-gnu.node" \
        "app.asar.unpacked/node_modules/claude-native/claude-native-binding.node" || {
        log_error "Failed to copy native binding to app.asar.unpacked"
        exit 1
    }
    
    # Copy Tray icons
    mkdir -p app.asar.contents/resources
    cp "$WORK_DIR/lib/net45/resources/Tray"* app.asar.contents/resources/ || {
        log_error "Failed to copy tray icons"
        exit 1
    }
    
    # Repackage app.asar
    npx asar pack app.asar.contents app.asar || {
        log_error "Failed to repackage app.asar"
        exit 1
    }
}

# Create desktop entry
create_desktop_entry() {
    echo "Creating desktop entry..."
    mkdir -p "$OUTPUT_DIR/share/applications"
    cat > "$OUTPUT_DIR/share/applications/claude-desktop.desktop" << EOF
[Desktop Entry]
Name=Claude
Exec=claude-desktop %u
Icon=claude
Type=Application
Terminal=false
Categories=Office;Utility;
MimeType=x-scheme-handler/claude
EOF
}

# Create launcher script
create_launcher() {
    echo "Creating launcher script..."
    mkdir -p "$OUTPUT_DIR/bin"
    
    # Get absolute path to the app directory
    APP_DIR="$(cd "$(dirname "$OUTPUT_DIR")" && pwd)/$(basename "$OUTPUT_DIR")"
    
    cat > "$OUTPUT_DIR/bin/claude-desktop" << EOF
#!/bin/bash
electron "$APP_DIR/lib/claude-desktop/app.asar" \
    \${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations} "\$@"
EOF
    chmod +x "$OUTPUT_DIR/bin/claude-desktop"
}

# Create installation instructions based on detected system
create_install_instructions() {
    log_info "Build complete! Claude Desktop is available in: $OUTPUT_DIR"
    log_info "To install, run the following commands:"
    
    # Common directories setup
    echo "mkdir -p ~/.local/bin ~/.local/share/applications ~/.local/share/icons"
    echo "cp $OUTPUT_DIR/bin/claude-desktop ~/.local/bin/"
    echo "cp $OUTPUT_DIR/share/applications/claude-desktop.desktop ~/.local/share/applications/"
    echo "cp -r $OUTPUT_DIR/share/icons/* ~/.local/share/icons/"
    
    # System-specific commands
    if command -v dnf >/dev/null 2>&1; then
        # Fedora-specific
        echo "update-desktop-database ~/.local/share/applications"
    elif command -v apt-get >/dev/null 2>&1; then
        # Debian/Ubuntu-specific
        echo "update-desktop-database ~/.local/share/applications"
        echo "# You might need to install update-desktop-database if not present:"
        echo "# sudo apt-get install desktop-file-utils"
    fi
    
    # Protocol handler setup
    echo -e "\nTo enable Claude protocol handler (for Google login), run:"
    echo "xdg-mime default claude-desktop.desktop x-scheme-handler/claude"
}

# Main execution
main() {
    log_info "Building Claude Desktop for Linux..."
    check_dependencies
    
    # Create clean build environment
    rm -rf "$WORK_DIR" "$OUTPUT_DIR"
    mkdir -p "$WORK_DIR" "$OUTPUT_DIR"
    
    setup_patchy_cnb
    download_and_extract
    process_icons
    process_asar
    create_desktop_entry
    create_launcher
    create_install_instructions
}

main "$@"
