const std = @import("std");
const wls = @import("wls.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var x_points = std.ArrayList(f64).init(allocator);
    defer x_points.deinit();
    try x_points.append(1);
    try x_points.append(0.9);
    const wls_model = wls.Wls{
        .x_points = &x_points,
        .y_points = &x_points,
        .weights = &x_points,
    };
    const fitted_model = wls_model.fit_linear_regression();
    if (fitted_model) |model| {
        std.debug.print("{d}\n", .{model.get_slope()});
    }
}

test {
    std.testing.refAllDecls(@This());
}
