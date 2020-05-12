
gameData = {}
gameData.W = 512
gameData.H = 512
gameData.aspect_ratio = gameData.H/gameData.W
gameData.fov = 90 -- not sure about this yet
gameData.fNear = 0.1
gameData.fFar = 1000
gameData.fovRad = 1.0/math.tan(gameData.fov * 0.5/180.0 * 3.14159)

function love.conf(t)
    t.window.width = gameData.W
    t.window.height = gameData.H
    t.console = true
end
