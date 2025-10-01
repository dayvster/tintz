const std = @import("std");
const tintz = @import("tintz");

pub fn main() !void {
    try std.fs.File.stdout().writeAll("Normal text\n");

    var buf_italic: [128]u8 = undefined;
    const styled_italic = try tintz.tintz(
        tintz.Style{ .italic = true },
        "Italic text\n",
        &buf_italic,
    );
    try std.fs.File.stdout().writeAll(styled_italic);

    var buf_bold: [128]u8 = undefined;
    const styled_bold = try tintz.tintz(
        tintz.Style{ .bold = true },
        "Bold text\n",
        &buf_bold,
    );
    try std.fs.File.stdout().writeAll(styled_bold);

    var buf_bolditalic: [128]u8 = undefined;
    const styled_bolditalic = try tintz.tintz(
        tintz.Style{ .bold = true, .italic = true },
        "Bold Italic text\n",
        &buf_bolditalic,
    );
    try std.fs.File.stdout().writeAll(styled_bolditalic);

    var buf_fg: [128]u8 = undefined;
    const styled_fg = try tintz.tintz(
        tintz.Style{ .fg = tintz.Color.green },
        "FG text\n",
        &buf_fg,
    );
    try std.fs.File.stdout().writeAll(styled_fg);

    var buf_bg: [128]u8 = undefined;
    const styled_bg = try tintz.tintz(
        tintz.Style{ .bg = tintz.Color.magenta },
        "BG text\n",
        &buf_bg,
    );
    try std.fs.File.stdout().writeAll(styled_bg);

    var buf_fg_bg: [128]u8 = undefined;
    const styled_fg_bg = try tintz.tintz(
        tintz.Style{ .fg = tintz.Color.cyan, .bg = tintz.Color.yellow },
        "BG and FG text\n",
        &buf_fg_bg,
    );
    try std.fs.File.stdout().writeAll(styled_fg_bg);

    var buf_italic_fg_bg: [128]u8 = undefined;
    const styled_italic_fg_bg = try tintz.tintz(
        tintz.Style{ .italic = true, .fg = tintz.Color.red, .bg = tintz.Color.blue },
        "Italic BG and FG text\n",
        &buf_italic_fg_bg,
    );
    try std.fs.File.stdout().writeAll(styled_italic_fg_bg);

    var buf_italic_bold_fg_bg: [128]u8 = undefined;
    const styled_italic_bold_fg_bg = try tintz.tintz(
        tintz.Style{ .italic = true, .bold = true, .fg = tintz.Color.white, .bg = tintz.Color.black },
        "Italic Bold BG and FG text\n",
        &buf_italic_bold_fg_bg,
    );
    try std.fs.File.stdout().writeAll(styled_italic_bold_fg_bg);

    const rainbow_letters = [_]struct { c: u8, color: tintz.Color }{
        .{ .c = 'R', .color = tintz.Color.red },
        .{ .c = 'A', .color = tintz.Color.yellow },
        .{ .c = 'I', .color = tintz.Color.green },
        .{ .c = 'N', .color = tintz.Color.cyan },
        .{ .c = 'B', .color = tintz.Color.blue },
        .{ .c = 'O', .color = tintz.Color.magenta },
        .{ .c = 'W', .color = tintz.Color.white },
    };
    for (rainbow_letters) |entry| {
        var buf: [32]u8 = undefined;
        const styled = try tintz.tintz(
            tintz.Style{ .fg = entry.color },
            &[_]u8{entry.c},
            &buf,
        );
        try std.fs.File.stdout().writeAll(styled);
    }
    try std.fs.File.stdout().writeAll("\n");

    var buf_hex_fg: [128]u8 = undefined;
    const styled_hex_fg = try tintz.tintz(
        tintz.Style{ .fg = tintz.Color.hex, .fg_hex = 0xFF8800 },
        "Hex FG #FF8800 text\n",
        &buf_hex_fg,
    );
    try std.fs.File.stdout().writeAll(styled_hex_fg);

    var buf_hex_fg_bg: [128]u8 = undefined;
    const styled_hex_fg_bg = try tintz.tintz(
        tintz.Style{ .fg = tintz.Color.hex, .fg_hex = 0x00FF99, .bg = tintz.Color.hex, .bg_hex = 0x222244 },
        "Hex FG #00FF99 BG #222244 text\n",
        &buf_hex_fg_bg,
    );
    try std.fs.File.stdout().writeAll(styled_hex_fg_bg);
}
