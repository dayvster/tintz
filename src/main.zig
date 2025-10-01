const std = @import("std");
const tintz = @import("tintz");

pub fn main() !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});
    try tintz.bufferedPrint();
}

test "tintz fg color" {
    const style = tintz.Style{ .fg = tintz.Color.red };
    const result = try tintz.tintz(style, "red");
    try std.testing.expect(std.mem.indexOf(u8, result, "\x1b[31m") != null);
}

test "tintz bg color" {
    const style = tintz.Style{ .bg = tintz.Color.green };
    const result = try tintz.tintz(style, "green bg");
    try std.testing.expect(std.mem.indexOf(u8, result, "\x1b[42m") != null);
}

test "tintz bold italic" {
    const style = tintz.Style{ .bold = true, .italic = true };
    const result = try tintz.tintz(style, "bolditalic");
    try std.testing.expect(std.mem.indexOf(u8, result, "\x1b[1m") != null);
    try std.testing.expect(std.mem.indexOf(u8, result, "\x1b[3m") != null);
}

test "tintz hex fg" {
    const style = tintz.Style{ .fg = tintz.Color.hex, .fg_hex = 0xFF8800 };
    const result = try tintz.tintz(style, "hex fg");
    try std.testing.expect(std.mem.indexOf(u8, result, "\x1b[38;2;255;136;0m") != null);
}

test "tintz hex bg" {
    const style = tintz.Style{ .bg = tintz.Color.hex, .bg_hex = 0x222244 };
    const result = try tintz.tintz(style, "hex bg");
    try std.testing.expect(std.mem.indexOf(u8, result, "\x1b[48;2;34;34;68m") != null);
}
