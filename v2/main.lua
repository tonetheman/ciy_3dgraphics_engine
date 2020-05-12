

local Vec3d = {}
function Vec3d.new(x,y,z)
    local self = {x=x,y=y,z=z}
    return self
end
Vec3d.ZERO = Vec3d.new(0,0,0)
function Vec3d.newZero()
    return Vec3d.new(0,0,0)
end

local Triangle = {}
function Triangle()
    local self = { p = {} }
    self.p[1] = Vec3d.newZero()
    self.p[2] = Vec3d.newZero()
    self.p[3] = Vec3d.newZero()
    return self
end

local Mesh = {}
function Mesh.new()
    local self = {}
    self.tris = {
		-- SOUTH
		{ 0.0, 0.0, 0.0,    0.0, 1.0, 0.0,    1.0, 1.0, 0.0 },
		{ 0.0, 0.0, 0.0,    1.0, 1.0, 0.0,    1.0, 0.0, 0.0 },

		-- EAST                                                      
		{ 1.0, 0.0, 0.0,    1.0, 1.0, 0.0,    1.0, 1.0, 1.0 },
		{ 1.0, 0.0, 0.0,    1.0, 1.0, 1.0,    1.0, 0.0, 1.0 },

		-- NORTH                                                     
		{ 1.0, 0.0, 1.0,    1.0, 1.0, 1.0,    0.0, 1.0, 1.0 },
		{ 1.0, 0.0, 1.0,    0.0, 1.0, 1.0,    0.0, 0.0, 1.0 },

		-- WEST                                                      
		{ 0.0, 0.0, 1.0,    0.0, 1.0, 1.0,    0.0, 1.0, 0.0 },
		{ 0.0, 0.0, 1.0,    0.0, 1.0, 0.0,    0.0, 0.0, 0.0 },

		-- TOP                                                       
		{ 0.0, 1.0, 0.0,    0.0, 1.0, 1.0,    1.0, 1.0, 1.0 },
		{ 0.0, 1.0, 0.0,    1.0, 1.0, 1.0,    1.0, 1.0, 0.0 },

		-- BOTTOM                                                    
		{ 1.0, 0.0, 1.0,    0.0, 0.0, 1.0,    0.0, 0.0, 0.0 },
		{ 1.0, 0.0, 1.0,    0.0, 0.0, 0.0,    1.0, 0.0, 0.0 },        
    }
    return self
end

local Mat4x4 = {}
function Mat4x4.new()
    local self = {  m = {
        {0,0,0,0},
        {0,0,0,0},
        {0,0,0,0},
        {0,0,0,0}
        }
    }
    return self
end

--[[
    take an input vector - i
    take an input matrix of type mat4x4
]]
function MultiplyMatrixVector(i,m)
    local o = Vec3d.newZero()
    
    o.x = i.x * m.m[0][0] + i.y * m.m[1][0] + i.z * m.m[2][0] + m.m[3][0];
    o.y = i.x * m.m[0][1] + i.y * m.m[1][1] + i.z * m.m[2][1] + m.m[3][1];
    o.z = i.x * m.m[0][2] + i.y * m.m[1][2] + i.z * m.m[2][2] + m.m[3][2];
    local w = i.x * m.m[0][3] + i.y * m.m[1][3] + i.z * m.m[2][3] + m.m[3][3];

    if w ~= 0.0 then
        o.x = o.x/w
        o.y = o.y/w
        o.z = o.z/w
    end
    return o
end


local mesh = Mesh.new()
local fTheta = 0

function love.load()
end

function love.update(dt)
    local matRotZ = Mat4x4.new()
    matRotZ.m[1][1] = math.cos(fTheta)
    matRotZ.m[1][2] = math.sin(fTheta);
    matRotZ.m[2][1] = -math.sin(fTheta);
    matRotZ.m[2][2] = math.cos(fTheta);
    matRotZ.m[3][3] = 1;
    matRotZ.m[4][4] = 1;

    local matRotX = Mat4x4.new()
    matRotX.m[2][2] = math.cos(fTheta * 0.5);
    matRotX.m[2][3] = math.sin(fTheta * 0.5);
    matRotX.m[3][2] = -math.sin(fTheta * 0.5);
    matRotX.m[3][3] = math.cos(fTheta * 0.5);
    matRotX.m[4][4] = 1;

    for i,tri in ipairs(mesh) do
        local triRotatedZ = Triangle.new()

        triRotatedZ.p[1] = MultiplyMatrixVector(tri.p[1], matRotZ)
        triRotatedZ.p[2] = MultiplyMatrixVector(tri.p[2], matRotZ);
		triRotatedZ.p[3] = MultiplyMatrixVector(tri.p[3], matRotZ);
    end
end
