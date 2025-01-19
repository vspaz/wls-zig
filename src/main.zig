const std = @import("std");
const point = @import("point.zig");

pub fn main() !void {
    const point_1 = point.Point{ .slope = 1, .intercept = 2 };
    std.debug.print("{d}", .{point_1.get_slope()});
}
