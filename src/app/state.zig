const std = @import("std");

pub const Entry = struct {
    name: []u8,
    is_dir: bool,
};

pub const State = struct {
    cwd: []u8,
    entries: []Entry,
    cursor: usize,

    pub fn init(allocator: std.mem.Allocator) !State {
        const cwd = try std.process.getCwdAlloc(allocator);
        return .{
            .cwd = cwd,
            .entries = &.{},
            .cursor = 0,
        };
    }

    pub fn deinit(self: *State, allocator: std.mem.Allocator) void {
        allocator.free(self.cwd);
    }

    pub fn moveUp(self: *State) void {
        if (self.cursor > 0) self.cursor -= 1;
    }

    pub fn moveDown(self: *State) void {
        if (self.cursor + 1 < self.entries.len) self.cursor += 1;
    }
};
