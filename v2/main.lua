

local Vec3d = {}
function Vec3d.new(x,y,z)
    local self = {x=x,y=y,z=z}
    function self:copyinto(other)
        self.x = other.X
        self.y = other.y
        self.z = other.z
    end
    function self:repr()
        return tostring(self.x) .. "," .. tostring(self.y) .. "," .. tostring(self.z)
    end
    return self
end
Vec3d.ZERO = Vec3d.new(0,0,0)
function Vec3d.newZero()
    return Vec3d.new(0,0,0)
end

local Triangle = {}
function Triangle.new()
    local self = { p = {} }
    self.p[1] = Vec3d.newZero()
    self.p[2] = Vec3d.newZero()
    self.p[3] = Vec3d.newZero()

    function self:copyinto(other)
        self.p[1].x = other.p[1].x
        self.p[1].y = other.p[1].y
        self.p[1].z = other.p[1].z

        self.p[2].x = other.p[2].x
        self.p[2].y = other.p[2].y
        self.p[2].z = other.p[2].z

        self.p[3].x = other.p[3].x
        self.p[3].y = other.p[3].y
        self.p[3].z = other.p[3].z
    end

    return self
end

function nt(x1,y1,z1, x2, y2, z2, x3, y3, z3)
    local t = Triangle.new()
    t.p[1] = Vec3d.new(x1,y1,z1)
    t.p[2] = Vec3d.new(x2,y2,z2)
    t.p[3] = Vec3d.new(x3,y3,z3)
    return t
end

local Mesh = {}
function Mesh.new()
    local self = {}
    self.tris = {
		-- SOUTH
		nt( 0.0, 0.0, 0.0,    0.0, 1.0, 0.0,    1.0, 1.0, 0.0 ),
		nt( 0.0, 0.0, 0.0,    1.0, 1.0, 0.0,    1.0, 0.0, 0.0 ),

		-- EAST                                                      
		nt( 1.0, 0.0, 0.0,    1.0, 1.0, 0.0,    1.0, 1.0, 1.0 ),
		nt( 1.0, 0.0, 0.0,    1.0, 1.0, 1.0,    1.0, 0.0, 1.0 ),

		-- NORTH                                                     
		nt( 1.0, 0.0, 1.0,    1.0, 1.0, 1.0,    0.0, 1.0, 1.0 ),
		nt( 1.0, 0.0, 1.0,    0.0, 1.0, 1.0,    0.0, 0.0, 1.0 ),

		-- WEST                                                      
		nt( 0.0, 0.0, 1.0,    0.0, 1.0, 1.0,    0.0, 1.0, 0.0 ),
		nt( 0.0, 0.0, 1.0,    0.0, 1.0, 0.0,    0.0, 0.0, 0.0 ),

		-- TOP                                                       
		nt( 0.0, 1.0, 0.0,    0.0, 1.0, 1.0,    1.0, 1.0, 1.0 ),
		nt( 0.0, 1.0, 0.0,    1.0, 1.0, 1.0,    1.0, 1.0, 0.0 ),

		-- BOTTOM                                                    
		nt( 1.0, 0.0, 1.0,    0.0, 0.0, 1.0,    0.0, 0.0, 0.0 ),
		nt( 1.0, 0.0, 1.0,    0.0, 0.0, 0.0,    1.0, 0.0, 0.0 ),        
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
    
    o.x = i.x * m.m[1][1] + i.y * m.m[2][1] + i.z * m.m[3][1] + m.m[4][1];
    o.y = i.x * m.m[1][2] + i.y * m.m[2][2] + i.z * m.m[3][2] + m.m[4][2];
    o.z = i.x * m.m[1][3] + i.y * m.m[2][3] + i.z * m.m[3][3] + m.m[4][3];
    local w = i.x * m.m[1][4] + i.y * m.m[2][4] + i.z * m.m[3][4] + m.m[4][4];

    if w ~= 0.0 then
        o.x = o.x/w
        o.y = o.y/w
        o.z = o.z/w
    end
    return o
end


local mesh = Mesh.new()
local fTheta = 0
local matProj = Mat4x4.new()

function love.load()
    matProj.m[1][1] = gameData.fAspectRatio * gameData.fFovRad;
    matProj.m[2][2] = gameData.fFovRad;
    matProj.m[3][3] = gameData.fFar / (gameData.fFar - gameData.fNear);
    matProj.m[4][3] = (-gameData.fFar * gameData.fNear) / (gameData.fFar - gameData.fNear);
    matProj.m[3][4] = 1.0;
    matProj.m[4][4] = 0.0;
    
    --[[
        --verify data structure for mesh
    for i,tri in ipairs(mesh.tris) do
        print(tri)
        for j=1,3 do
            print("-- " .. tri.p[j]:repr())
        end
    end
    ]]
end

function love.update(dt)
    fTheta = fTheta + dt
end

function love.draw()
    local matRotZ = Mat4x4.new()
    matRotZ.m[1][1] = math.cos(fTheta)
    matRotZ.m[1][2] = math.sin(fTheta)
    matRotZ.m[2][1] = -math.sin(fTheta)
    matRotZ.m[2][2] = math.cos(fTheta)
    matRotZ.m[3][3] = 1
    matRotZ.m[4][4] = 1

    local matRotX = Mat4x4.new()
    matRotX.m[2][2] = math.cos(fTheta * 0.5)
    matRotX.m[2][3] = math.sin(fTheta * 0.5)
    matRotX.m[3][2] = -math.sin(fTheta * 0.5)
    matRotX.m[3][3] = math.cos(fTheta * 0.5)
    matRotX.m[4][4] = 1

    for i,tri in ipairs(mesh.tris) do
        
        local triRotatedZ = Triangle.new()

        -- rotate in Z axis
        triRotatedZ.p[1] = MultiplyMatrixVector(tri.p[1], matRotZ)
        triRotatedZ.p[2] = MultiplyMatrixVector(tri.p[2], matRotZ)
		triRotatedZ.p[3] = MultiplyMatrixVector(tri.p[3], matRotZ)

        -- rotate in X axis
        local triRotatedZX = Triangle.new()
        triRotatedZX.p[1] = MultiplyMatrixVector(triRotatedZ.p[1], matRotX)
        triRotatedZX.p[2] = MultiplyMatrixVector(triRotatedZ.p[2], matRotX)
        triRotatedZX.p[3] = MultiplyMatrixVector(triRotatedZ.p[3], matRotX)

        -- offset into the screen
        local triTranslated = Triangle.new() -- makes a new one
        -- triTranslated = triRotatedZX;

        triTranslated:copyinto(triRotatedZX)

        triTranslated.p[1].z = triRotatedZX.p[1].z + 3.0
        triTranslated.p[2].z = triRotatedZX.p[2].z + 3.0
        triTranslated.p[3].z = triRotatedZX.p[3].z + 3.0

        -- project from 3d to 2d now!!!
        local triProjected = Triangle.new()
        triProjected.p[1] = MultiplyMatrixVector(triTranslated.p[1], matProj)
        triProjected.p[2] = MultiplyMatrixVector(triTranslated.p[2], matProj)
        triProjected.p[3] = MultiplyMatrixVector(triTranslated.p[3], matProj)

        -- scale into view
        triProjected.p[1].x = triProjected.p[1].x + 1.0
        triProjected.p[1].y = triProjected.p[1].y +  1.0
        triProjected.p[2].x = triProjected.p[2].x + 1.0
        triProjected.p[2].y = triProjected.p[2].y +  1.0
        triProjected.p[3].x = triProjected.p[3].x + 1.0 
        triProjected.p[3].y = triProjected.p[3].y + 1.0
        triProjected.p[1].x = triProjected.p[1].x * 0.5 * gameData.W
        triProjected.p[1].y = triProjected.p[1].y * 0.5 * gameData.H
        triProjected.p[2].x = triProjected.p[2].x * 0.5 * gameData.W
        triProjected.p[2].y = triProjected.p[2].y * 0.5 * gameData.H
        triProjected.p[3].x = triProjected.p[3].x * 0.5 * gameData.W
        triProjected.p[3].y = triProjected.p[3].y * 0.5 * gameData.H


        --[[
        print(triProjected.p[1].x .. " " .. triProjected.p[1].y .. ", " ..
            triProjected.p[2].x .. " " .. triProjected.p[2].y .. ", " ..
            triProjected.p[3].x .. " " .. triProjected.p[3].y)
        ]]
        love.graphics.polygon("fill", 
            triProjected.p[1].x, triProjected.p[1].y,
            triProjected.p[2].x, triProjected.p[2].y,
            triProjected.p[3].x, triProjected.p[3].y)
    end
end

