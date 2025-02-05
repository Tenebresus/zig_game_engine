const std = @import("std");
const trig = @import("trig.zig");

const Quaternion = struct {
    w: f32,
    x: f32,
    y: f32,
    z: f32,
    radians: f32,

    fn calc(self: *Quaternion) void {
        self.w = @cos(self.radians / 2);
        self.x = self.x * @sin(self.radians / 2);
        self.y = self.y * @sin(self.radians / 2);
        self.z = self.z * @sin(self.radians / 2);
    }
};

pub fn applyRotation(degrees: f32, axis: @Vector(3, f32), matrix: []f32) void {
    const radians = trig.degreesToRadians(degrees);

    var quats: [3]Quaternion = undefined;
    var checks: [3]bool = undefined;

    if (axis[0] != 0) {
        var quat_x = Quaternion{ .w = 0, .x = axis[0], .y = 0, .z = 0, .radians = radians };
        quat_x.calc();

        quats[0] = quat_x;
        checks[0] = true;
    }

    if (axis[1] != 0) {
        var quat_y = Quaternion{ .w = 0, .x = 0, .y = axis[1], .z = 0, .radians = radians };
        quat_y.calc();

        quats[1] = quat_y;
        checks[1] = true;
    }

    if (axis[2] != 0) {
        var quat_z = Quaternion{ .w = 0, .x = 0, .y = 0, .z = axis[2], .radians = radians };
        quat_z.calc();

        quats[2] = quat_z;
        checks[2] = true;
    }

    // TODO: redo checks logic; I want to receive the axis input and automatically apply the correct quats to the matrix

    if (checks[0] and !checks[1] and !checks[2]) {
        applyQuatToMat(quats[0], matrix);
    }

    if (!checks[0] and checks[1] and !checks[2]) {
        applyQuatToMat(quats[1], matrix);
    }

    if (!checks[0] and !checks[1] and checks[2]) {
        applyQuatToMat(quats[2], matrix);
    }

    if (checks[0] and checks[1] and !checks[2]) {
        const mutliplied_quat = multiplyQuats(&quats[1], &quats[0]);
        applyQuatToMat(mutliplied_quat, matrix);
    }

    if (checks[0] and !checks[1] and checks[2]) {
        const mutliplied_quat = multiplyQuats(&quats[2], &quats[0]);
        applyQuatToMat(mutliplied_quat, matrix);
    }

    if (!checks[0] and checks[1] and checks[2]) {
        const mutliplied_quat = multiplyQuats(&quats[2], &quats[1]);
        applyQuatToMat(mutliplied_quat, matrix);
    }

    if (checks[0] and checks[1] and checks[2]) {
        var mutliplied_quat_one = multiplyQuats(&quats[1], &quats[0]);
        const mutliplied_quat_two = multiplyQuats(&quats[2], &mutliplied_quat_one);
        applyQuatToMat(mutliplied_quat_two, matrix);
    }
}

fn multiplyQuats(quat_one: *Quaternion, quat_two: *Quaternion) Quaternion {
    const w = quat_one.w * quat_two.w - quat_one.x * quat_two.x - quat_one.y * quat_two.y - quat_one.z * quat_two.z;
    const x = quat_one.w * quat_two.x + quat_one.x * quat_two.w + quat_one.y * quat_two.z - quat_one.z * quat_two.y;
    const y = quat_one.w * quat_two.y - quat_one.x * quat_two.z + quat_one.y * quat_two.w + quat_one.z * quat_two.x;
    const z = quat_one.w * quat_two.z + quat_one.x * quat_two.y - quat_one.y * quat_two.x + quat_one.z * quat_two.w;

    return Quaternion{ .w = w, .x = x, .y = y, .z = z, .radians = quat_one.radians };
}

fn applyQuatToMat(quat: Quaternion, matrix: []f32) void {
    matrix[0] = 1 - 2 * (quat.y * quat.y + quat.z * quat.z);
    matrix[1] = 2 * (quat.x * quat.y - quat.w * quat.z);
    matrix[2] = 2 * (quat.x * quat.z + quat.w * quat.y);
    matrix[4] = 2 * (quat.x * quat.y + quat.w * quat.z);
    matrix[5] = 1 - 2 * (quat.x * quat.x + quat.z * quat.z);
    matrix[6] = 2 * (quat.y * quat.z - quat.w * quat.x);
    matrix[8] = 2 * (quat.x * quat.z - quat.w * quat.y);
    matrix[9] = 2 * (quat.y * quat.z + quat.w * quat.x);
    matrix[10] = 1 - 2 * (quat.x * quat.x + quat.y * quat.y);
}
