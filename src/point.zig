const std = @import("std");

pub const Point = struct {
    intercept: f64,
    slope: f64,

    pub fn get_intercept(self: Point) f64 {
        return self.intercept;
    }

    pub fn get_slope(self: Point) f64 {
        return self.slope;
    }
};

test "test point ok" {
    const point_1 = Point{ .slope = 1.0, .intercept = 2.0 };
    try std.testing.expectEqual(@as(f64, 1.0), point_1.get_slope());
}
