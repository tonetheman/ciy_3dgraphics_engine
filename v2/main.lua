

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
    local self = {}
    self[1] = Vec3d.newZero()
    self[2] = Vec3d.newZero()
    self[3] = Vec3d.newZero()
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

local mat4x4 = { m = {
    {0,0,0,0},
    {0,0,0,0},
    {0,0,0,0},
    {0,0,0,0}
    }
}

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

function love.load()
end

function love.draw()
    for i,v in ipairs(mesh) do
    end
end
