const std = @import("std");
const State = @import("../app/state.zig").State;

pub fn draw(state: *State) !void {
    const stdout = std.fs.File.stdout().writer();

    try clear(stdout);

    try stdout.print("cwd: {s}\n\n", .{state.cwd});

    for (state.entries, 0..) |e, i| {
        if (i == state.cursor)
            try stdout.writeAll("> ")
        else
            try stdout.writeAll("  ");

        try stdout.print("{s}\n", .{e.name});
    }
}

fn clear(writer: anytype) !void {
    try writer.writeAll("\x1b[2J\x1b[H");
}
