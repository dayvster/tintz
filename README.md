[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![Zig Version](https://img.shields.io/badge/Zig-0.15%2B-orange)](https://ziglang.org/)
[![Build](https://img.shields.io/badge/build-passing-brightgreen)]()

## Install

Clone the repository and add `src/tintz.zig` to your Zig project:

```sh
zig fetch --save git+https://github.com/dayvster/tintz
```

Then import the module in your Zig code:

```zig
const tintz = @import("tintz");
```
# tintz

Minimal Zig library for coloring and styling terminal output with ANSI escape codes.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![Zig Version](https://img.shields.io/badge/Zig-0.15%2B-orange)](https://ziglang.org/)
[![Build](https://img.shields.io/badge/build-passing-brightgreen)]()

## Features
- Foreground and background colors (8-bit and truecolor/hex)
- Bold and italic text
- Combine multiple styles
- Simple API for generating styled output
- No dependencies

## Usage
Add `src/tintz.zig` to your Zig project and import via your build system or module path.

```zig
const tintz = @import("tintz");

var buf: [128]u8 = undefined;
const styled = try tintz.tintz(
    tintz.Style{ .fg = tintz.Color.red, .bold = true },
    "Hello, world!",
    &buf,
);
try std.fs.File.stdout().writeAll(styled);
```

See `examples/basic.zig` for more usage patterns and style combinations.

## Why tintz?
- Works with Zig 0.15+
- Handles buffer safety and error reporting
- Designed for robust output in modern terminals
- Easy to extend for more styles

## License
MIT
