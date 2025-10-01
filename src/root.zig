const std = @import("std");
pub const Style = @import("tintz.zig").Style;
pub const Color = @import("tintz.zig").Color;
pub const tintz = @import("tintz.zig").tintz;
pub const styleCode = @import("tintz.zig").styleCode;
pub const fgCode = @import("tintz.zig").fgCode;

pub fn bufferedPrint() !void {
    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;
    try stdout.print("Run `zig build test` to run the tests.\n", .{});
    try stdout.flush();
}

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try std.testing.expect(add(3, 7) == 10);
}
