const std = @import("std");
const gl = @import("gl");
const Allocator = std.mem.Allocator;
const fs = std.fs;

pub const ShaderProcess = struct {
    shaders: []Shader,
    vertex_shader: Shader,
    fragment_shader: Shader,
    allocator: Allocator,
    shader_program: c_uint = 0,

    pub fn init(allocator: Allocator) !ShaderProcess {
        var shaders = try allocator.alloc(Shader, 2);

        const vert_shader_content = try fs.cwd().readFile("src/shaders/shader.vert.glsl", &shaders[0].buffer);
        vert_shader_content[vert_shader_content.len - 1] = 0;
        shaders[0].source = vert_shader_content;

        const frag_shader_content = try fs.cwd().readFile("src/shaders/shader.frag.glsl", &shaders[1].buffer);
        frag_shader_content[frag_shader_content.len - 1] = 0;
        shaders[1].source = frag_shader_content;

        return ShaderProcess{ .shaders = shaders, .vertex_shader = shaders[0], .fragment_shader = shaders[1], .allocator = allocator };
    }

    pub fn getShaderProgram(self: *ShaderProcess) c_uint {
        if (self.shader_program != 0) {
            return self.shader_program;
        }

        const vertexShader = gl.CreateShader(gl.VERTEX_SHADER);
        gl.ShaderSource(vertexShader, 1, (&self.vertex_shader.source.ptr)[0..1], null);
        gl.CompileShader(vertexShader);

        const fragmentShader = gl.CreateShader(gl.FRAGMENT_SHADER);
        gl.ShaderSource(fragmentShader, 1, (&self.fragment_shader.source.ptr)[0..1], null);
        gl.CompileShader(fragmentShader);

        const shaderProgram = gl.CreateProgram();
        gl.AttachShader(shaderProgram, vertexShader);
        gl.AttachShader(shaderProgram, fragmentShader);
        gl.LinkProgram(shaderProgram);

        self.shader_program = shaderProgram;
        return shaderProgram;
    }

    pub fn deinit(self: ShaderProcess) void {
        self.allocator.free(self.shaders);
    }
};

const Shader = struct { source: []const u8, buffer: [512]u8 };
