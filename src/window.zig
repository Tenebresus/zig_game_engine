const std = @import("std");
const glfw = @import("mach-glfw");
const gl = @import("gl");

const glfw_log = std.log.scoped(.glfw);
const gl_log = std.log.scoped(.gl);

pub const width: u16 = 640;
pub const height: u16 = 480;

var gl_procs: gl.ProcTable = undefined;

fn logGLFWError(error_code: glfw.ErrorCode, description: [:0]const u8) void {
    glfw_log.err("{}: {s}\n", .{ error_code, description });
}

pub const WindowProcess = struct {
    window: glfw.Window,

    pub fn init() !WindowProcess {
        glfw.setErrorCallback(logGLFWError);

        if (!glfw.init(.{})) {
            glfw_log.err("failed to initialize GLFW: {?s}", .{glfw.getErrorString()});
            return error.GLFWInitFailed;
        }

        // Create our window, specifying that we want to use OpenGL.
        const window = glfw.Window.create(width, height, "mach-glfw + OpenGL", null, null, .{
            .context_version_major = gl.info.version_major,
            .context_version_minor = gl.info.version_minor,
            .opengl_profile = .opengl_core_profile,
            .opengl_forward_compat = true,
        }) orelse {
            glfw_log.err("failed to create GLFW window: {?s}", .{glfw.getErrorString()});
            return error.CreateWindowFailed;
        };

        // Make the window's OpenGL context current.
        glfw.makeContextCurrent(window);

        // Initialize the OpenGL procedure table.
        if (!gl_procs.init(glfw.getProcAddress)) {
            gl_log.err("failed to load OpenGL functions", .{});
            return error.GLInitFailed;
        }

        // Make the OpenGL procedure table current.
        gl.makeProcTableCurrent(&gl_procs);
        return WindowProcess{ .window = window };
    }

    pub fn deinit(self: WindowProcess) void {
        defer glfw.terminate();
        defer self.window.destroy();
        defer glfw.makeContextCurrent(null);
        defer gl.makeProcTableCurrent(null);
    }
};
