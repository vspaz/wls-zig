pub const Wls = @import("wls").Wls;
pub const asserts = @import("wls").asserts;

pub fn main() !void {
    const x_points = [_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0 };
    const y_points = [_]f64{ 1.0, 3.0, 4.0, 5.0, 2.0, 3.0, 4.0 };
    const weights = [_]f64{ 1.0, 2.0, 3.0, 1.0, 8.0, 1.0, 5.0 };

    const wls_model = Wls.init(&x_points, &y_points, &weights);
    const fitted_model = wls_model.fit_linear_regression();

    if (fitted_model) |line| {
        asserts.assert_almost_equal(2.14285714, line.intercept, 1.0e-6);
        asserts.assert_almost_equal(0.150862, line.slope, 1.0e-6);
    }
}
