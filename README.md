# wls-zig

weighted linear regression in pure Zig w/o any 3d party dependencies or frameworks.

## How-to

```zig
const std = @import("std");
const wls = @import("models/wls.zig");
const asserts = @import("models/asserts.zig");

pub fn main() !void {
    const x_points = [_]f64{ 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0 };
    const y_points = [_]f64{ 1.0, 3.0, 4.0, 5.0, 2.0, 3.0, 4.0 };
    const weights = [_]f64{ 1.0, 2.0, 3.0, 1.0, 8.0, 1.0, 5.0 };

    const wls_model = wls.Wls.init(&x_points, &y_points, &weights);
    const fitted_model = wls_model.fit_linear_regression();

    if (fitted_model) |line| {
        asserts.assert_almost_equal(2.14285714, line.intercept, 1.0e-6);
        asserts.assert_almost_equal(0.150862, line.slope, 1.0e-6);
    }
}
```

## Description

WLS is based on the OLS method and help solve problems of model inadequacy or violations of the basic regression assumptions.

Estimating a linear regression with WLS is can be daunting w/o special stats packages, such as Python statsmodels or Pandas.

## References

- [Wikipedia: Weighted least squares](https://en.wikipedia.org/wiki/Weighted_least_squares)
- [Introduction to Linear Regression Analysis, 5th edition](https://tinyurl.com/y3clfnrs)
- [Least Squares Regression Analysis in Terms of Linear Algebra](https://tinyurl.com/y485qhlg) 