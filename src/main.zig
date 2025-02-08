const std = @import("std");
const glfw = @import("mach-glfw");
const gl = @import("gl");

const window = @import("window.zig");
const shader = @import("shader.zig");
const matrix = @import("math/matrix.zig");
const quat = @import("math/quaternion.zig");
const poly = @import("poly.zig");

//const vertices = [_]f32{ -0.5, -0.5, 0.0, 1.0, 0.0, 0.0, 0.0, 0.5, 0.0, 0.0, 1.0, 0.0, 0.5, -0.5, 0.0, 0.0, 0.0, 1.0 };

const positions = [_]@Vector(3, f32){
    @Vector(3, f32){ -0.9, 0.3, -20 },
    @Vector(3, f32){ 0.9, -0.3, 20 },
};

pub fn main() !void {
    const window_process = try window.WindowProcess.init();
    defer window_process.deinit();

    const allocator = std.heap.page_allocator;
    var shader_process = try shader.ShaderProcess.init(allocator);
    defer shader_process.deinit();

    const shaderProgram = shader_process.getShaderProgram();

    gl.Enable(gl.DEPTH_TEST);

    var poly_allocator = try poly.init(allocator);
    defer poly_allocator.deinit();

    const triangle = try poly_allocator.createCube();

    var VAO: [1]gl.uint = undefined;
    var VBO: [1]gl.uint = undefined;

    gl.GenVertexArrays(1, &VAO);
    gl.GenBuffers(1, &VBO);

    gl.BindVertexArray(VAO[0]);
    gl.BindBuffer(gl.ARRAY_BUFFER, VBO[0]);
    //    gl.BufferData(gl.ARRAY_BUFFER, @sizeOf(f32) * vertices.len, &vertices, gl.STATIC_DRAW);
    gl.BufferData(gl.ARRAY_BUFFER, @sizeOf(f32) * triangle.i_len * 6, triangle.getVertices().ptr, gl.STATIC_DRAW);

    gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, @sizeOf(f32) * 6, 0);
    gl.EnableVertexAttribArray(0);

    gl.VertexAttribPointer(1, 3, gl.FLOAT, gl.FALSE, @sizeOf(f32) * 6, 3 * @sizeOf(f32));
    gl.EnableVertexAttribArray(1);

    var matrix_allocator = try matrix.init(allocator);
    defer matrix_allocator.deinit();

    var model_transformation = try matrix_allocator.mat4();

    var view_point_z: f32 = -50;
    var view_point_x: f32 = 0;
    var view_transformation = try matrix_allocator.mat4();
    //    view_transformation.translate(@Vector(3, f32){ 0.0, 0.0, view_point });

    var projection_transformation = try matrix_allocator.mat4();
    projection_transformation.projectPerspective(45, 16 / 9, 0.1, 300);

    var lol: f32 = 0.0;

    while (!window_process.window.shouldClose()) {
        if (window_process.window.getKey(.escape) == glfw.Action.press) {
            window_process.window.setShouldClose(true);
        }

        if (window_process.window.getKey(.w) == glfw.Action.press) {
            view_point_z += 1;
        }

        if (window_process.window.getKey(.s) == glfw.Action.press) {
            view_point_z -= 1;
        }

        if (window_process.window.getKey(.a) == glfw.Action.press) {
            view_point_x += 0.1;
        }

        if (window_process.window.getKey(.d) == glfw.Action.press) {
            view_point_x -= 0.1;
        }

        gl.ClearColor(0.2, 0.3, 0.3, 1.0);
        gl.Clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

        gl.UseProgram(shaderProgram);

        //        model_transformation.rotate(lol, @Vector(3, f32){ 1.0, 1.0, 1.0 });
        //        const model_location = gl.GetUniformLocation(shaderProgram, "model");
        //        gl.UniformMatrix4fv(model_location, 1, gl.FALSE, model_transformation.matrix.ptr);

        view_transformation.translate(@Vector(3, f32){ view_point_x, 0.0, view_point_z });
        const view_location = gl.GetUniformLocation(shaderProgram, "view");
        gl.UniformMatrix4fv(view_location, 1, gl.FALSE, view_transformation.matrix.ptr);

        const projection_location = gl.GetUniformLocation(shaderProgram, "projection");
        gl.UniformMatrix4fv(projection_location, 1, gl.FALSE, projection_transformation.matrix.ptr);

        for (positions) |position| {
            model_transformation.translate(position);
            model_transformation.rotate(lol, @Vector(3, f32){ 1.0, 1.0, 1.0 });
            const model_location = gl.GetUniformLocation(shaderProgram, "model");
            gl.UniformMatrix4fv(model_location, 1, gl.FALSE, model_transformation.matrix.ptr);
            gl.DrawArrays(gl.TRIANGLES, 0, 36);
        }

        lol += 0.5;

        glfw.pollEvents();
        window_process.window.swapBuffers();
    }
}
