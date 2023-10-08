const std = @import("std");

pub extern fn is_whitespace(c: u8) bool;

pub fn main() anyerror!void {
    const chars = [_]u8{ 'a', ' ', 'A', 0x09, 0x0A, 0x0D };
    // syntax for enumeration with index changed
    for (chars, 0..) |char, idx| {
        // warn is now print
        std.debug.print("{}: is '{c}' whitespace?: {}\n", .{ idx, char, is_whitespace(char) });
    }
}
