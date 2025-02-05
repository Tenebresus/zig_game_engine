const std = @import("std");

const PolyAllocator = struct {
    allocator: std.mem.Allocator,
    allocated_vertices: [][]Vertex,
    allocation_counter: u8,

    pub fn createTriangle(self: *PolyAllocator) !Polygon {
        var vertices = try self.allocator.alloc(Vertex, 3);
        self.allocated_vertices[self.allocation_counter] = vertices;
        self.allocation_counter += 1;

        vertices[0].setLocation(-0.5, -0.5, 0.0);
        vertices[0].setColour(1.0, 0.0, 0.0);

        vertices[1].setLocation(0.0, 0.5, 0.0);
        vertices[1].setColour(0.0, 1.0, 0.0);

        vertices[2].setLocation(0.5, -0.5, 0.0);
        vertices[2].setColour(0.0, 0.0, 1.0);

        return Polygon{ .vertices = vertices, .u_len = 3, .i_len = 3 };
    }

    pub fn deinit(self: PolyAllocator) void {
        for (0..self.allocation_counter) |i| {
            self.allocator.free(self.allocated_vertices[i]);
        }

        self.allocator.free(self.allocated_vertices);
    }
};

const Polygon = struct {
    vertices: []Vertex,
    i_len: isize,
    u_len: usize,
    pub fn getVertices(self: Polygon) []f32 {
        var vertices = [_]f32{0} ** 1024;
        var index_counter: u8 = 0;

        for (self.vertices) |vertex| {
            vertices[index_counter] = vertex.x;
            vertices[index_counter + 1] = vertex.y;
            vertices[index_counter + 2] = vertex.z;
            vertices[index_counter + 3] = vertex.r;
            vertices[index_counter + 4] = vertex.g;
            vertices[index_counter + 5] = vertex.b;

            index_counter += 6;
        }

        return vertices[0 .. self.u_len * 6];
    }
};

const Vertex = struct {
    x: f32,
    y: f32,
    z: f32,

    r: f32,
    g: f32,
    b: f32,

    fn setLocation(self: *Vertex, x: f32, y: f32, z: f32) void {
        self.x = x;
        self.y = y;
        self.z = z;
    }

    fn setColour(self: *Vertex, r: f32, g: f32, b: f32) void {
        self.r = r;
        self.g = g;
        self.b = b;
    }
};

pub fn main() !void {
    var allocator = try init(std.heap.page_allocator);
    defer allocator.deinit();

    const triagle = try allocator.createTriangle(@Vector(3, f32){ 1.0, 0.0, 0.0 });

    std.debug.print("{any}", .{triagle.getVertices()});
}

pub fn init(allocator: std.mem.Allocator) !PolyAllocator {
    const allocated_vertices = try allocator.alloc([]Vertex, 1024);
    return PolyAllocator{ .allocator = allocator, .allocated_vertices = allocated_vertices, .allocation_counter = 0 };
}
