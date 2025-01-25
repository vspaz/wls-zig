const std = @import("std");
const point = @import("point.zig");
const asserts = @import("asserts.zig");

pub const Wls = struct {
    _x_points: []const f64,
    _y_points: []const f64,
    _weights: []const f64,

    pub fn init(x_points: []const f64, y_points: []const f64, weights: []const f64) Wls {
        asserts.assert_have_size_greater_than_two(x_points);
        asserts.assert_have_same_size(x_points, y_points);
        asserts.assert_have_same_size(x_points, weights);

        return Wls{
            ._x_points = x_points,
            ._y_points = y_points,
            ._weights = weights,
        };
    }

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

        for (0..self._x_points.len) |i| {
            xi = self._x_points[i];
            yi = self._y_points[i];
            wi = self._weights[i];

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
    const x_points = [7]f64{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0 };
    const y_points = [7]f64{ 1.0, 3.0, 4.0, 5.0, 2.0, 3.0, 4.0 };
    const weights = [7]f64{ 1.0, 2.0, 3.0, 1.0, 8.0, 1.0, 5.0 };

    const wls = Wls.init(&x_points, &y_points, &weights);
    const fitted_model = wls.fit_linear_regression();
    asserts.assert_fitted_model(asserts.Values{ .model = fitted_model, .expected_intercept = 2.14285714, .expected_slope = 0.150862, .delta = 1.0e-6 });
}

test "test wls model with stable weights ok" {
    const x_points = [7]f64{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0 };
    const y_points = [7]f64{ 1.0, 3.0, 4.0, 5.0, 2.0, 3.0, 4.0 };
    const weights = [7]f64{ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 };
    const wls = Wls.init(&x_points, &y_points, &weights);

    const fitted_model = wls.fit_linear_regression();
    asserts.assert_fitted_model(asserts.Values{ .model = fitted_model, .expected_intercept = 2.14285714, .expected_slope = 0.25, .delta = 1.0e-6 });
}

test "test horizontal line ok" {
    const wls = Wls.init(&.{ 0.0, 1.0 }, &.{ 10.0, 10.0 }, &.{ 1.0, 1.0 });

    const fitted_model = wls.fit_linear_regression();
    asserts.assert_fitted_model(asserts.Values{ .model = fitted_model, .expected_intercept = 10.0, .expected_slope = 0.0, .delta = 0.0 });
}

test "test vertical line ok" {
    const wls = Wls.init(&.{ 1.0, 1.0 }, &.{ 0.0, 1.0 }, &.{ 1.0, 1.0 });
    asserts.assert_model_cant_be_fit(wls.fit_linear_regression());
}

test "test run uphill ok" {
    const wls = Wls.init(&.{ 0.0, 1.0 }, &.{ 0.0, 1.0 }, &.{ 1.0, 1.0 });

    const fitted_model = wls.fit_linear_regression();
    asserts.assert_fitted_model(asserts.Values{ .model = fitted_model, .expected_intercept = 0.0, .expected_slope = 1.0, .delta = 0.0 });
}

test "test run downhill ok" {
    const wls = Wls.init(&.{ 1.0, 0.0 }, &.{ 0.0, 1.0 }, &.{ 1.0, 1.0 });

    const fitted_model = wls.fit_linear_regression();
    asserts.assert_fitted_model(asserts.Values{ .model = fitted_model, .expected_intercept = 1.0, .expected_slope = -1.0, .delta = 0.0 });
}
