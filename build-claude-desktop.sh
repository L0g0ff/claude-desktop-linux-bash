#!/bin/bash
set -euo pipefail

# Configuration
CLAUDE_VERSION="0.7.7"
CLAUDE_URL="https://storage.googleapis.com/osprey-downloads-c02f6a0d-347c-492b-a752-3e0651722e97/nest-win-x64/Claude-Setup-x64.exe"
WORK_DIR="$(pwd)/claude-build"
OUTPUT_DIR="$(pwd)/claude-desktop"

# Check for required dependencies
check_dependencies() {
    local deps=("p7zip" "pnpm" "node" "cargo" "rustc" "electron" "convert" "wrestool" "icotool")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        echo "Missing required dependencies: ${missing[*]}"
        echo "Please install them using:"
        echo "sudo apt-get install p7zip-full pnpm nodejs cargo rustc electron imagemagick icoutils"
        exit 1
    fi
}

# Create and setup the patchy-cnb native module
setup_patchy_cnb() {
    echo "Setting up patchy-cnb..."
    mkdir -p "$WORK_DIR/patchy-cnb"
    cd "$WORK_DIR/patchy-cnb"
    
    # Create Cargo.toml
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

    # Create src/lib.rs with stub implementations
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

    # Install dependencies and build
    pnpm install
    pnpm run build
}

# Download and extract the Windows client
download_and_extract() {
    echo "Downloading Claude Desktop..."
    mkdir -p "$WORK_DIR"
    cd "$WORK_DIR"
    
    if [ ! -f "Claude-Setup-x64.exe" ]; then
        wget "$CLAUDE_URL" -O "Claude-Setup-x64.exe"
    fi
    
    echo "Extracting..."
    7z x -y "Claude-Setup-x64.exe"
    7z x -y "AnthropicClaude-${CLAUDE_VERSION}-full.nupkg"
}

# Process icons
process_icons() {
    echo "Processing icons..."
    cd "$WORK_DIR"
    
    wrestool -x -t 14 "lib/net45/claude.exe" -o claude.ico
    icotool -x claude.ico
    
    mkdir -p "$OUTPUT_DIR/share/icons/hicolor"
    for size in 16 24 32 48 64 256; do
        mkdir -p "$OUTPUT_DIR/share/icons/hicolor/${size}x${size}/apps"
        convert "claude_*${size}x${size}x32.png" "$OUTPUT_DIR/share/icons/hicolor/${size}x${size}/apps/claude.png"
    done
}

# Process and repackage app.asar
process_asar() {
    echo "Processing app.asar..."
    cd "$WORK_DIR"
    
    mkdir -p "$OUTPUT_DIR/lib/claude-desktop"
    cp "lib/net45/resources/app.asar" "$OUTPUT_DIR/lib/claude-desktop/"
    cp -r "lib/net45/resources/app.asar.unpacked" "$OUTPUT_DIR/lib/claude-desktop/"
    
    cd "$OUTPUT_DIR/lib/claude-desktop"
    npx asar extract app.asar app.asar.contents
    
    # Replace native bindings
    cp "$WORK_DIR/patchy-cnb/patchy-cnb.linux-x64-gnu.node" \
        "app.asar.contents/node_modules/claude-native/claude-native-binding.node"
    cp "$WORK_DIR/patchy-cnb/patchy-cnb.linux-x64-gnu.node" \
        "app.asar.unpacked/node_modules/claude-native/claude-native-binding.node"
    
    # Copy Tray icons
    mkdir -p app.asar.contents/resources
    cp "$WORK_DIR/lib/net45/resources/Tray"* app.asar.contents/resources/
    
    # Repackage app.asar
    npx asar pack app.asar.contents app.asar
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

# Main execution
main() {
    echo "Building Claude Desktop for Linux..."
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
    
    echo "Build complete! Claude Desktop is available in: $OUTPUT_DIR"
    echo "You can run it using: $OUTPUT_DIR/bin/claude-desktop"
}

main "$@"