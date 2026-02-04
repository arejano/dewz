const std = @import("std");

pub const Key = union(enum) {
    Char: u8,
    Quit,
};

pub fn readKey() !Key {
    var buf: [1]u8 = undefined;

    _ = try std.fs.File.stdin().reader().read(&buf);

    if (buf[0] == 'q') return .Quit;

    return .{ .Char = buf[0] };
}
