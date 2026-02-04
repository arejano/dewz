const std = @import("std");

pub const EntryKind = enum { file, dir, symlink };

pub const Entry = struct { name: []const u8, kind: EntryKind };

const Self = @This();

allocator: std.mem.Allocator,
entry_list: std.array_list.Managed(Entry),

pub fn init(allocator: std.mem.Allocator) Self {
    return .{
        .allocator = allocator,
        .entry_list = std.array_list.Managed(Entry).init(allocator),
    };
}

pub fn deinit(self: *Self) void {
    self.entry_list.clearAndFree();
    self.entry_list.deinit();
}

pub fn readAndPrintFile(self: *Self, path: []const u8) !void {
    var file = try std.fs.cwd().openFile(path, .{ .mode = .read_only });
    defer file.close();

    var read_buffer: [2]u8 = undefined;
    var f_reader: std.fs.File.Reader = file.reader(&read_buffer);

    var line = std.Io.Writer.Allocating.init(self.allocator);
    defer line.deinit();

    const reader_interface = &f_reader.interface;

    while (true) {
        _ = reader_interface.streamDelimiter(&line.writer, '\n') catch |err| {
            if (err == error.EndOfStream) break else return err;
        };

        _ = f_reader.interface.toss(1);
        std.debug.print("{s}\n", .{line.written()});
        line.clearRetainingCapacity();
    }
}
