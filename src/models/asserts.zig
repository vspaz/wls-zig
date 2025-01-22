const std = @import("std");
const point = @import("point.zig");

const assert = std.debug.assert;

pub fn assert_almost_equal(expected: f64, actual: f64, delta: f64) void {
    assert(delta > expected - actual);
}

pub fn assert_equal(expected: f64, actual: f64) void {
    assert(expected == actual);
}

pub fn assert_have_same_size(array_1: *std.ArrayList(f64), array_2: *std.ArrayList(f64)) void {
    assert(array_1.items.len == array_2.items.len);
}

pub fn assert_have_size_greater_than_two(array: *std.ArrayList(f64)) void {
    assert(array.items.len >= 2);
}

pub fn assert_true(condition: bool) void {
    assert(condition);
}

pub fn assert_not_null(optional_point: ?point.Point) void {
    assert(optional_point != null);
}

pub fn assert_null(optional_point: ?point.Point) void {
    assert(optional_point == null);
}
