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

    pub fn createCube(self: *PolyAllocator) !Polygon {
        var vertices = try self.allocator.alloc(Vertex, 36);
        self.allocated_vertices[self.allocation_counter] = vertices;
        self.allocation_counter += 1;

        vertices[0].setLocation(-0.5, -0.5, -0.5);
        vertices[1].setLocation(0.5, -0.5, -0.5);
        vertices[2].setLocation(0.5, 0.5, -0.5);
        vertices[3].setLocation(0.5, 0.5, -0.5);
        vertices[4].setLocation(-0.5, 0.5, -0.5);
        vertices[5].setLocation(-0.5, -0.5, -0.5);

        vertices[0].setColour(1.0, 0.0, 0.0);
        vertices[1].setColour(1.0, 0.0, 0.0);
        vertices[2].setColour(1.0, 0.0, 0.0);
        vertices[3].setColour(1.0, 0.0, 0.0);
        vertices[4].setColour(1.0, 0.0, 0.0);
        vertices[5].setColour(1.0, 0.0, 0.0);

        vertices[6].setLocation(-0.5, -0.5, 0.5);
        vertices[7].setLocation(0.5, -0.5, 0.5);
        vertices[8].setLocation(0.5, 0.5, 0.5);
        vertices[9].setLocation(0.5, 0.5, 0.5);
        vertices[10].setLocation(-0.5, 0.5, 0.5);
        vertices[11].setLocation(-0.5, -0.5, 0.5);

        vertices[6].setColour(0.0, 1.0, 0.0);
        vertices[7].setColour(0.0, 1.0, 0.0);
        vertices[8].setColour(0.0, 1.0, 0.0);
        vertices[9].setColour(0.0, 1.0, 0.0);
        vertices[10].setColour(0.0, 1.0, 0.0);
        vertices[11].setColour(0.0, 1.0, 0.0);

        vertices[12].setLocation(-0.5, 0.5, 0.5);
        vertices[13].setLocation(-0.5, 0.5, -0.5);
        vertices[14].setLocation(-0.5, -0.5, -0.5);
        vertices[15].setLocation(-0.5, -0.5, -0.5);
        vertices[16].setLocation(-0.5, -0.5, 0.5);
        vertices[17].setLocation(-0.5, 0.5, 0.5);

        vertices[12].setColour(0.0, 0.0, 1.0);
        vertices[13].setColour(0.0, 0.0, 1.0);
        vertices[14].setColour(0.0, 0.0, 1.0);
        vertices[15].setColour(0.0, 0.0, 1.0);
        vertices[16].setColour(0.0, 0.0, 1.0);
        vertices[17].setColour(0.0, 0.0, 1.0);

        vertices[18].setLocation(0.5, 0.5, 0.5);
        vertices[19].setLocation(0.5, 0.5, -0.5);
        vertices[20].setLocation(0.5, -0.5, -0.5);
        vertices[21].setLocation(0.5, -0.5, -0.5);
        vertices[22].setLocation(0.5, -0.5, 0.5);
        vertices[23].setLocation(0.5, 0.5, 0.5);

        vertices[18].setColour(0.0, 1.0, 1.0);
        vertices[19].setColour(0.0, 1.0, 1.0);
        vertices[20].setColour(0.0, 1.0, 1.0);
        vertices[21].setColour(0.0, 1.0, 1.0);
        vertices[22].setColour(0.0, 1.0, 1.0);
        vertices[23].setColour(0.0, 1.0, 1.0);

        vertices[24].setLocation(-0.5, -0.5, -0.5);
        vertices[25].setLocation(0.5, -0.5, -0.5);
        vertices[26].setLocation(0.5, -0.5, 0.5);
        vertices[27].setLocation(0.5, -0.5, 0.5);
        vertices[28].setLocation(-0.5, -0.5, 0.5);
        vertices[29].setLocation(-0.5, -0.5, -0.5);

        vertices[24].setColour(1.0, 1.0, 0.0);
        vertices[25].setColour(1.0, 1.0, 0.0);
        vertices[26].setColour(1.0, 1.0, 0.0);
        vertices[27].setColour(1.0, 1.0, 0.0);
        vertices[28].setColour(1.0, 1.0, 0.0);
        vertices[29].setColour(1.0, 1.0, 0.0);

        vertices[30].setLocation(-0.5, 0.5, -0.5);
        vertices[31].setLocation(0.5, 0.5, -0.5);
        vertices[32].setLocation(0.5, 0.5, 0.5);
        vertices[33].setLocation(0.5, 0.5, 0.5);
        vertices[34].setLocation(-0.5, 0.5, 0.5);
        vertices[35].setLocation(-0.5, 0.5, -0.5);

        vertices[30].setColour(1.0, 0.0, 1.0);
        vertices[31].setColour(1.0, 0.0, 1.0);
        vertices[32].setColour(1.0, 0.0, 1.0);
        vertices[33].setColour(1.0, 0.0, 1.0);
        vertices[34].setColour(1.0, 0.0, 1.0);
        vertices[35].setColour(1.0, 0.0, 1.0);

        return Polygon{ .vertices = vertices, .u_len = 36, .i_len = 36 };
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

    r: f32 = 1,
    g: f32 = 1,
    b: f32 = 1,

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
