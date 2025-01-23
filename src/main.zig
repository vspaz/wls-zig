const std = @import("std");
const wls = @import("models/wls.zig");

pub fn main() !void {
    const wls_model = wls.Wls{
        .x_points = &.{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0 },
        .y_points = &.{ 1.0, 3.0, 4.0, 5.0, 2.0, 3.0, 4.0 },
        .weights = &.{ 1.0, 2.0, 3.0, 1.0, 8.0, 1.0, 5.0 },
    };
    const fitted_model = wls_model.fit_linear_regression();
    if (fitted_model) |model| {
        std.debug.print("{d}\n", .{model.slope});
    }
}

test {
    std.testing.refAllDecls(@This());
}
