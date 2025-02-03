const std = @import("std");

pub const pi: f32 = 3.14159265359;

//fn rotate(degrees: f32) void {
//    const haha = @sin(degreesToRadians(degrees));
//    std.debug.print("{any}\n\n", .{haha});
//}

pub fn degreesToRadians(degrees: f32) f32 {
    return degrees * (pi / 180);
}
