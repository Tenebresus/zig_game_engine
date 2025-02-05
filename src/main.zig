const std = @import("std");
const glfw = @import("mach-glfw");
const gl = @import("gl");

const window = @import("window.zig");
const shader = @import("shader.zig");
const matrix = @import("math/matrix.zig");
const quat = @import("math/quaternion.zig");

const vertices = [_]f32{ -0.5, -0.5, 0.0, 1.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.0, 1.0, 0.0, 0.5, -0.5, 0.0, 0.0, 0.0, 1.0 };

pub fn main() !void {
    const window_process = try window.WindowProcess.init();
    defer window_process.deinit();

    const allocator = std.heap.page_allocator;
    var shader_process = try shader.ShaderProcess.init(allocator);
    defer shader_process.deinit();

    const shaderProgram = shader_process.getShaderProgram();

    var VAO: [1]gl.uint = undefined;
    var VBO: [1]gl.uint = undefined;

    gl.GenVertexArrays(1, &VAO);
    gl.GenBuffers(1, &VBO);

    gl.BindVertexArray(VAO[0]);
    gl.BindBuffer(gl.ARRAY_BUFFER, VBO[0]);
    gl.BufferData(gl.ARRAY_BUFFER, @sizeOf(f32) * vertices.len, &vertices, gl.STATIC_DRAW);

    gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, @sizeOf(f32) * 6, 0);
    gl.EnableVertexAttribArray(0);

    gl.VertexAttribPointer(1, 3, gl.FLOAT, gl.FALSE, @sizeOf(f32) * 6, 3 * @sizeOf(f32));
    gl.EnableVertexAttribArray(1);

    var matrix_allocator = try matrix.init(allocator);
    defer matrix_allocator.deinit();
    var mat4 = try matrix_allocator.mat4();
    //    mat4.translate(@Vector(3, f32){ -0.2, 0, 0 });
    var lol: f32 = 0.0;

    while (!window_process.window.shouldClose()) {
        if (window_process.window.getKey(.escape) == glfw.Action.press) {
            window_process.window.setShouldClose(true);
        }

        gl.ClearColor(0.2, 0.3, 0.3, 1.0);
        gl.Clear(gl.COLOR_BUFFER_BIT);

        gl.UseProgram(shaderProgram);

        //        mat4.rotate(lol, @Vector(3, f32){ 0, 0, 1 });
        mat4.rotate(lol, @Vector(3, f32){ 1, 1, 1 });
        const transform_location = gl.GetUniformLocation(shaderProgram, "transform");
        gl.UniformMatrix4fv(transform_location, 1, gl.FALSE, mat4.matrix.ptr);

        lol += 0.5;
        gl.DrawArrays(gl.TRIANGLES, 0, 3);

        glfw.pollEvents();
        window_process.window.swapBuffers();
    }
}
