const std = @import("std");
const point = @import("point.zig");

pub const Wls = struct {
    x_points: *std.ArrayList(f64),
    y_points: *std.ArrayList(f64),
    weights: *std.ArrayList(f64),

    pub fn fit_linear_regression(self: Wls) ?point.Point {
        var sum_of_weights: f64 = 0.0;
        var sum_of_products_of_weights_and_x_squared: f64 = 0.0;
        var sum_of_products_of_x_and_y_and_weights: f64 = 0.0;
        var sum_of_products_of_xi_and_wi: f64 = 0.0;
        var sum_of_products_of_y_and_weights: f64 = 0.0;

        var xi: f64 = 0.0;
        var yi: f64 = 0.0;
        var wi: f64 = 0.0;
        var product_of_xi_and_wi: f64 = 0.0;

        for (0..self.x_points.items.len) |i| {
            xi = self.x_points.items[i];
            yi = self.y_points.items[i];
            wi = self.weights.items[i];

            sum_of_weights += wi;
            product_of_xi_and_wi = xi * wi;
            sum_of_products_of_xi_and_wi += product_of_xi_and_wi;
            sum_of_products_of_x_and_y_and_weights += product_of_xi_and_wi * yi;
            sum_of_products_of_y_and_weights += yi * wi;
            sum_of_products_of_weights_and_x_squared += product_of_xi_and_wi * xi;
        }

        const dividend = sum_of_weights * sum_of_products_of_x_and_y_and_weights - sum_of_products_of_xi_and_wi * sum_of_products_of_y_and_weights;
        const divisor = sum_of_weights * sum_of_products_of_weights_and_x_squared - sum_of_products_of_xi_and_wi * sum_of_products_of_xi_and_wi;
        if (divisor == 0.0) {
            return null;
        }

        const slope = dividend / divisor;
        const intercept = (sum_of_products_of_y_and_weights - slope * sum_of_products_of_xi_and_wi) / sum_of_weights;

        return point.Point{ .intercept = intercept, .slope = slope };
    }
};

test "test wls model with weights ok" {
    const expect = std.testing.expect;
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var x_points = std.ArrayList(f64).init(allocator);
    defer x_points.deinit();

    var y_points = std.ArrayList(f64).init(allocator);
    defer y_points.deinit();

    var weights = std.ArrayList(f64).init(allocator);
    defer weights.deinit();

    for ([_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0 }) |item| {
        try x_points.append(item);
    }
    for ([_]f64{ 1.0, 3.0, 4.0, 5.0, 2.0, 3.0, 4.0 }) |item| {
        try y_points.append(item);
    }
    for ([_]f64{ 1.0, 3.0, 4.0, 5.0, 2.0, 3.0, 4.0 }) |item| {
        try weights.append(item);
    }

    const wls = Wls{ .x_points = &x_points, .y_points = &x_points, .weights = &x_points };
    const fitted_model = wls.fit_linear_regression();
    try expect(fitted_model != null);
}
