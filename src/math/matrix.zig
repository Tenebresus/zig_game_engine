const std = @import("std");
const trig = @import("trig.zig");
const quat = @import("quaternion.zig");

const Mat = struct {
    size: u8,
    matrix: []f32,

    pub fn translate(self: *Mat, translation_vector: @Vector(3, f32)) void {
        self.matrix[self.size - 1] = translation_vector[0];
        self.matrix[self.size * 2 - 1] = translation_vector[0];
        self.matrix[self.size * 3 - 1] = translation_vector[0];
    }

    pub fn scale(self: *Mat, scale_number: f32) void {
        // TODO: make sure this is valid for all matrices with different sizes; Now its only valid for mat4
        self.matrix[0] *= scale_number;
        self.matrix[5] *= scale_number;
        self.matrix[10] *= scale_number;
    }

    // TODO: redo rotation logic. We want a vector(1.0, 0.33, 0.5) and each element * degrees applied to that axis
    pub fn rotate(self: *Mat, degrees: f32, axis: @Vector(3, f32)) void {
        quat.applyRotation(degrees, axis, self.matrix);

        //        if (axis[0] != 0) {
        //            rotateX(self.matrix, degrees * axis[0]);
        //        }
        //        if (axis[1] != 0) {
        //            rotateY(self.matrix, degrees * axis[1]);
        //        }
        //        if (axis[2] != 0) {
        //            rotateZ(self.matrix, degrees * axis[2]);
        //        }
    }
};

const MatAllocator = struct {
    allocator: std.mem.Allocator,
    allocated_matrices: [][]f32,
    allocated_matrices_count: u16,

    pub fn mat4(self: *MatAllocator) !Mat {
        const matrix = try self.allocator.alloc(f32, 16);
        initializeMatrix(4, matrix);
        self.allocated_matrices[self.allocated_matrices_count] = matrix;
        self.allocated_matrices_count += 1;
        return Mat{ .size = 4, .matrix = matrix };
    }

    pub fn deinit(self: MatAllocator) void {
        for (0..self.allocated_matrices_count) |i| {
            self.allocator.free(self.allocated_matrices[i]);
        }
        self.allocator.free(self.allocated_matrices);
    }
};

fn initializeMatrix(len: u8, matrix: []f32) void {
    var count: u8 = 0;

    for (matrix, 0..) |_, i| {
        if (i == count) {
            matrix[i] = 1;
            count += len + 1;
        } else {
            matrix[i] = 0;
        }
    }
}

pub fn init(allocator: std.mem.Allocator) !MatAllocator {
    const allocated_matrices = try allocator.alloc([]f32, 1024);
    return MatAllocator{ .allocator = allocator, .allocated_matrices = allocated_matrices, .allocated_matrices_count = 0 };
}

fn rotateX(matrix: []f32, degrees: f32) void {
    // TODO: fix manual index replacement
    matrix[5] = @cos(trig.degreesToRadians(degrees));
    matrix[6] = 0 - @sin(trig.degreesToRadians(degrees));
    matrix[9] = @sin(trig.degreesToRadians(degrees));
    matrix[10] = @cos(trig.degreesToRadians(degrees));
}

fn rotateY(matrix: []f32, degrees: f32) void {
    // TODO: fix manual index replacement
    matrix[0] = @cos(trig.degreesToRadians(degrees));
    matrix[2] = @sin(trig.degreesToRadians(degrees));
    matrix[8] = 0 - @sin(trig.degreesToRadians(degrees));
    matrix[10] = @cos(trig.degreesToRadians(degrees));
}

fn rotateZ(matrix: []f32, degrees: f32) void {
    // TODO: fix manual index replacement
    matrix[0] = @cos(trig.degreesToRadians(degrees));
    matrix[1] = 0 - @sin(trig.degreesToRadians(degrees));
    matrix[4] = @sin(trig.degreesToRadians(degrees));
    matrix[5] = @cos(trig.degreesToRadians(degrees));
}
