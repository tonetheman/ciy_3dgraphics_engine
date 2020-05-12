



local V3 = {}
function V3.new(x,y,z)
    local self = {x=x,y=y,z=z}
    function self:repr()
        return self.x .. " " .. self.y .. " " .. self.z
    end
    function self:equals(o)
        return self.x == o.x and self.y == o.y and self.z == o.z
    end

    return self
end

local Triangle = {}
function Triangle.new(x1,y1,z1,x2,y2,z2,x3,y3,z3)
    local self = {}
    -- 3 vectors
    self[1] = V3.new(x1,y1,z1)
    self[2] = V3.new(x2,y2,z2)
    self[3] = V3.new(x3,y3,z3)

    function self:dup(o)
        self[1].x = o[1].x
        self[1].y = o[1].y
        self[1].z = o[1].z
        self[2].x = o[2].x
        self[2].y = o[2].y
        self[2].z = o[2].z
        self[3].x = o[3].x
        self[3].y = o[3].y
        self[3].z = o[3].z
    end

    function self:repr()
        return self[1]:repr() .. ", " .. self[2]:repr() .. ", " .. self[3]:repr()
    end

    function self:equals(o)
        return self[1]:equals(o[1]) and self[2]:equals(o[2]) and self[3]:equals(o[3])
    end

    return self
end

local Mesh = {}
function Mesh.new()
    local self = {}
    -- an array of triangles
    -- add another triangles
    function self:add(t)
        table.insert(self,t)
    end

    return self
end

local Matrix4x4 = {}
function Matrix4x4.new()
    local self = {}
    self[1] = {0,0,0,0}
    self[2] = {0,0,0,0}
    self[3] = {0,0,0,0} 
    self[4] = {0,0,0,0}

    self[1][1] = gameData.aspect_ratio * gameData.fovRad
    self[2][2] = gameData.fovRad
    self[3][3] = gameData.fFar / (gameData.fFar - gameData.fNear)
    self[4][3] = (-gameData.fFar * gameData.fNear) / (gameData.fFar-gameData.fNear)
    self[3][4] = 1.0
    self[4][4] = 0

    return self
end

function multMatrixVector(i,m)
    local o = V3.new(0,0,0)

    -- for debugging
    -- print(m[1][1] .. " " .. m[2][1] .. " " .. m[3][1] .. " " .. m[4][1])
    o.x = i.x * m[1][1] + i.y * m[2][1] + i.z*m[3][1] + m[4][1]
    o.y = i.x * m[1][2] + i.y * m[2][2] + i.z*m[3][2] + m[4][2]
    o.x = i.x * m[1][3] + i.y * m[2][3] + i.z*m[3][3] + m[4][3]

    local w = i.x * m[1][4] + i.y * m[2][4] + i.z*m[3][4] + m[4][4]
 
    if w~=0 then
        o.x = o.x/w
        o.y = o.y/w
        o.z = o.z/w
    end
    return o
end

---
---
local mymesh = nil
local projMatrix = nil

function setup_mesh()
    mymesh = Mesh.new()
    -- south
    mymesh:add(Triangle.new(0,0,0, 0,1,0, 1,1,0))
    mymesh:add(Triangle.new(0,0,0, 1,1,0, 1,0,0))
    
    -- east
    mymesh:add(Triangle.new(1,0,0, 1,1,0, 1,1,1))
    mymesh:add(Triangle.new(1,0,0, 1,1,1, 1,0,1))

    -- north
    mymesh:add(Triangle.new(1,0,1, 1,1,1, 0,1,1))
    mymesh:add(Triangle.new(1,0,1, 0,1,1, 0,0,1))

    -- west
    mymesh:add(Triangle.new(0,0,1, 0,1,1, 0,1,0))
    mymesh:add(Triangle.new(0,0,1, 0,1,0, 0,0,0))

    -- top
    mymesh:add(Triangle.new(0,1,0, 0,1,1, 1,1,1))
    mymesh:add(Triangle.new(0,1,0, 1,1,1, 1,1,0))

    -- bottom
    mymesh:add(Triangle.new(1,0,1, 0,0,1, 0,0,0))
    mymesh:add(Triangle.new(1,0,1, 0,0,0, 1,0,0))
end

function love.load()
    setup_mesh()
    projMatrix = Matrix4x4.new()
end

function love.update(dt)
end

-- local f = 0.1

function love.draw()

    for i,v in ipairs(mymesh) do
        
        -- print(v:repr())
        local triTran = Triangle.new(0,0,0,0,0,0,0,0,0)
        
        -- copy the source into triTran
        triTran:dup(v)

        if not triTran:equals(v) then
            print("not equals")
            print(triTran:repr() .. " -- " .. v:repr())
         end

        -- print(triTran:repr())
        
        -- translate it a bit
        --[[
        triTran[1].z = triTran[1].z + f
        triTran[2].z = triTran[2].z + f
        triTran[3].z = triTran[3].z + f

        f = f + 0.001
        if f>3 then
            f = 0
        end

        ]]
        -- print(triTran:repr())

        local triProjected = Triangle.new(0,0,0,0,0,0,0,0,0)
        triProjected[1] = multMatrixVector(triTran[1], projMatrix)
        triProjected[2] = multMatrixVector(triTran[2], projMatrix)
        triProjected[3] = multMatrixVector(triTran[3], projMatrix)

        -- scale into view move point from 0,1 to 1,2
        triProjected[1].x = triProjected[1].x + 1
        triProjected[1].y = triProjected[1].y + 1
        triProjected[2].x = triProjected[2].x + 1
        triProjected[2].y = triProjected[2].y + 1
        triProjected[3].x = triProjected[3].x + 1
        triProjected[3].y = triProjected[3].y + 1

        triProjected[1].x = triProjected[1].x * 0.5 * gameData.W
        triProjected[1].y = triProjected[1].y * 0.5 * gameData.H
        triProjected[2].x = triProjected[2].x * 0.5 * gameData.W
        triProjected[2].y = triProjected[2].y * 0.5 * gameData.H
        triProjected[3].x = triProjected[3].x * 0.5 * gameData.W
        triProjected[3].y = triProjected[3].y * 0.5 * gameData.H

        
        love.graphics.polygon("line", 
            triProjected[1].x, triProjected[1].y,
            triProjected[2].x, triProjected[2].y,
            triProjected[3].x, triProjected[3].y
        )
    end
end

