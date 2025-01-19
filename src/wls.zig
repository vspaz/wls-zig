const std = @import("std");
const point = @import("point.zig");

pub const Wls = struct {
    x_points: *std.ArrayList(f64),
    y_points: *std.ArrayList(f64),
    weights: *std.ArrayList(f64),

    pub fn fit_linear_regression(self: Wls) point.Point {
        return point.Point{ .intercept = self.x_points.items[0], .slope = self.x_points.items[0] };
    }
};

test "test Wls ok" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var x_points = std.ArrayList(f64).init(allocator);
    defer x_points.deinit();
    try x_points.append(1);
    try x_points.append(0.9);
    const wls = Wls{ .x_points = &x_points, .y_points = &x_points, .weights = &x_points };
    try std.testing.expectEqual(@as(f64, 1), wls.fit_linear_regression().get_slope());
}
