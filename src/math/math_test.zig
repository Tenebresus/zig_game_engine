const std = @import("std");
const math = @import("math.zig");

pub fn main() !void {
    var matrix_allocator = try math.init(std.heap.page_allocator);
    defer matrix_allocator.deinit();

    var mat4 = try matrix_allocator.mat4();
    var mat42 = try matrix_allocator.mat4();
    mat4.scale(2);
    mat42.translate(@Vector(3, f32){ 5, 5, 5 });

    std.debug.print("{any}\n", .{mat4.matrix});
    std.debug.print("{any}\n", .{mat42.matrix});
}
