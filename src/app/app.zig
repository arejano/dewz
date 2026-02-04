const std = @import("std");
const State = @import("state.zig").State;
const Renderer = @import("../tui/renderer.zig");
const Input = @import("../input/input.zig");
const Command = @import("commands.zig").Command;

pub const App = struct {
    allocator: std.mem.Allocator,
    state: State,

    pub fn init(allocator: std.mem.Allocator) !App {
        return .{
            .allocator = allocator,
            .state = try State.init(allocator),
        };
    }

    pub fn deinit(self: *App) void {
        self.state.deinit(self.allocator);
    }

    pub fn run(self: *App) !void {
        while (true) {
            try Renderer.draw(&self.state);

            const key = try Input.readKey();
            if (key == .Quit) break;

            try self.handleKey(key);
        }
    }

    fn handleKey(self: *App, key: Input.Key) !void {
        const cmd = Command.fromKey(key) orelse return;
        try self.execute(cmd);
    }

    fn execute(self: *App, cmd: Command) !void {
        switch (cmd) {
            .GoUp => self.state.moveUp(),
            .GoDown => self.state.moveDown(),
            else => {},
        }
    }
};
