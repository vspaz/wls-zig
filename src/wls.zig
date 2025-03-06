const std = @import("std");
pub const Wls = @import("model.zig").Wls;
pub const asserts = @import("asserts.zig");

pub fn main() !void {}

test {
    std.testing.refAllDecls(@This());
}
