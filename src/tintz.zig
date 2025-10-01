/// Terminal color and style library for Zig.
const std = @import("std");

/// Supported terminal colors and hex color.
pub const Color = enum {
    black,
    red,
    green,
    yellow,
    blue,
    magenta,
    cyan,
    white,
    reset,
    hex,
};

/// Error set for color and style operations.
pub const ColorError = error{
    BufferTooSmall,
    InvalidHexColor,
};

/// Generate ANSI escape code for foreground color.
/// If `color` is `.hex`, provide a hex RGB value in `hex`.
/// Writes the code into `buf` and returns the slice.
/// Returns error if buffer is too small or hex is missing.
pub fn fgCode(color: Color, hex: ?u32, buf: []u8) ![]u8 {
    if (color == .hex) {
        if (hex == null) return error.InvalidHexColor;
        if (buf.len < 18) return error.BufferTooSmall;
        const r = (hex.? >> 16) & 0xFF;
        const g = (hex.? >> 8) & 0xFF;
        const b = hex.? & 0xFF;
        return try std.fmt.bufPrint(buf, "\x1b[38;2;{d};{d};{d}m", .{ r, g, b });
    }

    const code = switch (color) {
        .black => "\x1b[30m",
        .red => "\x1b[31m",
        .green => "\x1b[32m",
        .yellow => "\x1b[33m",
        .blue => "\x1b[34m",
        .magenta => "\x1b[35m",
        .cyan => "\x1b[36m",
        .white => "\x1b[37m",
        .reset => "\x1b[39m",
        .hex => return error.InvalidHexColor,
    };

    if (buf.len < code.len) return error.BufferTooSmall;
    return try std.fmt.bufPrint(buf, "{s}", .{code});
}

/// Generate ANSI escape code for background color.
/// If `color` is `.hex`, provide a hex RGB value in `hex`.
/// Writes the code into `buf` and returns the slice.
/// Returns error if buffer is too small or hex is missing.
pub fn bgCode(color: Color, hex: ?u32, buf: []u8) ![]u8 {
    if (color == .hex) {
        if (hex == null) return error.InvalidHexColor;
        if (buf.len < 18) return error.BufferTooSmall;
        const r = (hex.? >> 16) & 0xFF;
        const g = (hex.? >> 8) & 0xFF;
        const b = hex.? & 0xFF;
        return try std.fmt.bufPrint(buf, "\x1b[48;2;{d};{d};{d}m", .{ r, g, b });
    }

    const code = switch (color) {
        .black => "\x1b[40m",
        .red => "\x1b[41m",
        .green => "\x1b[42m",
        .yellow => "\x1b[43m",
        .blue => "\x1b[44m",
        .magenta => "\x1b[45m",
        .cyan => "\x1b[46m",
        .white => "\x1b[47m",
        .reset => "\x1b[49m",
        .hex => return error.InvalidHexColor,
    };

    if (buf.len < code.len) return error.BufferTooSmall;
    return try std.fmt.bufPrint(buf, "{s}", .{code});
}

/// Style configuration for terminal output.
/// Supports foreground/background color, hex color, bold, and italic.
pub const Style = struct {
    fg: ?Color = null,
    fg_hex: ?u32 = null,
    bg: ?Color = null,
    bg_hex: ?u32 = null,
    bold: bool = false,
    italic: bool = false,
};

/// Generate combined ANSI escape codes for a style.
/// Writes all style codes into `buf` and returns the slice.
/// Returns error if buffer is too small.
pub fn styleCode(style: Style, buf: []u8) ![]u8 {
    var idx: usize = 0;

    if (style.fg) |fg| {
        const code = try fgCode(fg, style.fg_hex, buf[idx..]);
        idx += code.len;
    }

    if (style.bg) |bg| {
        if (idx >= buf.len) return error.BufferTooSmall;
        const code = try bgCode(bg, style.bg_hex, buf[idx..]);
        idx += code.len;
    }

    if (style.bold) {
        const code = "\x1b[1m";
        if (idx + code.len > buf.len) return error.BufferTooSmall;
        @memcpy(buf[idx..][0..code.len], code);
        idx += code.len;
    }

    if (style.italic) {
        const code = "\x1b[3m";
        if (idx + code.len > buf.len) return error.BufferTooSmall;
        @memcpy(buf[idx..][0..code.len], code);
        idx += code.len;
    }

    return buf[0..idx];
}

/// Apply a style to text and append reset code.
/// Writes the styled text and reset into `buf` and returns the slice.
/// Returns error if buffer is too small.
pub fn tintz(style: Style, text: []const u8, buf: []u8) ![]u8 {
    var idx: usize = 0;

    var prefix_buf: [64]u8 = undefined;
    const prefix = try styleCode(style, &prefix_buf);

    const reset = "\x1b[0m";
    if (buf.len < prefix.len + text.len + reset.len) return error.BufferTooSmall;

    @memcpy(buf[idx..][0..prefix.len], prefix);
    idx += prefix.len;

    @memcpy(buf[idx..][0..text.len], text);
    idx += text.len;

    @memcpy(buf[idx..][0..reset.len], reset);
    idx += reset.len;

    return buf[0..idx];
}
