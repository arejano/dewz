const std = @import("std");
// const App = @import("app/app.zig").App;
const Walker = @import("fs/walker.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        _ = gpa.detectLeaks();
        _ = gpa.deinit();
    }
    const allocator = gpa.allocator();

    const walker = try allocator.create(Walker);
    defer {
        walker.deinit();
        allocator.destroy(walker);
    }

    walker.* = Walker.init(allocator);

    try walker.readAndPrintFile("build.zig");

    // var app = try App.init(allocator);
    // defer app.deinit();

    // try app.run();

}
