const std = @import("std");
const expect = std.testing.expect;

pub fn assert_almost_equal(expected: f64, actual: f64, delta: f64) void {
    expect(delta > expected - actual);
}

pub fn assert_have_same_size(array_1: *std.ArrayList(f64), array_2: *std.ArrayList(f64)) void {
    expect(array_1.items.len == array_2.items.len);
}

pub fn assert_have_size_greater_than_two(array: *std.ArrayList(f64)) void {
    expect(array.items.len > 2);
}

pub fn assert_true(condition: bool) void {
    expect(condition);
}
