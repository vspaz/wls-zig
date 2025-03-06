# wls-zig

`wls-zig` is the implementation of weighted linear regression in pure **Zig** w/o any 3d party dependencies or frameworks.

## Installation
1. Run the following command inside your project:
```shell
zig fetch --save git+https://github.com/vspaz/wls-zig.git#main
```
it should add the following dependency to your project _build.zig.zon_ file, e.g.
```zig
.dependencies = .{
    .wls = .{
        .url = "git+https://github.com/vspaz/wls-zig.git?ref=main#f4dfc9a98f8f538d6d25d7d3e1e431fe77d54744",
        .hash = "wls-0.1.0-NK6PrjMoAABYyveo97dzY5AugQxqcGgExHsaDVMxx1wm",
    },
}
```

2. Navigate to _build.zig_ file located in the root directory and add the following 2 lines as shown below:

```zig
 const exe = b.addExecutable(.{
        .name = "your project name",
        .root_module = exe_mod,
    });
    
    // add these 2 lines!
    const wlszig = b.dependency("wls", .{});
    exe.root_module.addImport("wls", wlszig.module("wls"));
```
3. Test the project build with `zig build`
   There should be no error!

4. mport `wls-zig` lib in your code as follows:
```zig
const wls = @import("wls");
```
and you're good to go! :rocket:

## Examples
```zig
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
```

## Description

WLS is based on the OLS method and help solve problems of model inadequacy or violations of the basic regression assumptions.

Estimating a linear regression with WLS is can be hard w/o special stats packages, such as Python statsmodels or Pandas.

## References

- [Wikipedia: Weighted least squares](https://en.wikipedia.org/wiki/Weighted_least_squares)
- [Introduction to Linear Regression Analysis, 5th edition](https://tinyurl.com/y3clfnrs)
- [Least Squares Regression Analysis in Terms of Linear Algebra](https://tinyurl.com/y485qhlg) 