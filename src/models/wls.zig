const std = @import("std");
const point = @import("point.zig");
const asserts = @import("asserts.zig");

pub const Wls = struct {
    x_points: *std.ArrayList(f64),
    y_points: *std.ArrayList(f64),
    weights: *std.ArrayList(f64),

    pub fn fit_linear_regression(self: Wls) ?point.Point {
        asserts.assert_have_size_greater_than_two(self.x_points);
        asserts.assert_have_same_size(self.x_points, self.y_points);

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
    for ([_]f64{ 1.0, 2.0, 3.0, 1.0, 8.0, 1.0, 5.0 }) |item| {
        try weights.append(item);
    }

    const wls = Wls{ .x_points = &x_points, .y_points = &y_points, .weights = &weights };
    const fitted_model = wls.fit_linear_regression();

    asserts.assert_not_null(fitted_model);
    if (fitted_model) |model| {
        asserts.assert_almost_equal(2.14285714, model.get_intercept(), 1.0e-6);
        asserts.assert_almost_equal(0.150862, model.get_slope(), 1.0e-6);
    }
}
