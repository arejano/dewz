const Input = @import("../input/input.zig");

pub const Command = enum {
    GoUp,
    GoDown,
    Quit,

    pub fn fromKey(key: Input.Key) ?Command {
        return switch (key) {
            .Char => |c| switch (c) {
                'k' => .GoUp,
                'j' => .GoDown,
                'q' => .Quit,
                else => null,
            },
            else => null,
        };
    }
};
