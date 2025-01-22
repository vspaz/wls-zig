const std = @import("std");
const asserts = @import("asserts.zig");

pub const Point = struct {
    intercept: f64,
    slope: f64,
};

test "test point ok" {
    const point = Point{ .intercept = 2.0, .slope = 1.0 };
    asserts.assert_equal(1.0, point.slope);
}
