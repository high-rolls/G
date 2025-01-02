require 'Body'
vector = require 'hump.vector'

-- Constants
local G = 10000 -- Gravitational constant (adjust for scale)

-- Central fixed circle
local central = Body(vector(400, 300), vector(0, 0), 1000, 20)
local orbiting = {
    Body(vector(600, 300), vector(0, -150), 10, 2),
    Body(vector(200, 300), vector(0, 150), 10, 2),
    Body(vector(400, 500), vector(150, 0), 10, 2)
}

-- Calculate the gravitational force
local function calculateGravitationalForce(bodyFrom, bodyTo)
    local dx = bodyTo.pos.x - bodyFrom.pos.x
    local dy = bodyTo.pos.y - bodyFrom.pos.y
    local distance = math.sqrt(dx^2 + dy^2)
    if distance == 0 then return 0, 0 end -- Avoid division by zero

    local force = G * (bodyFrom.mass * bodyTo.mass) / (distance^2)
    local angle = math.atan2(dy, dx)

    return vector(force * math.cos(angle), force * math.sin(angle))
end

-- Love2D callbacks
function love.update(dt)
    -- Calculate gravitational force
    for k, body in pairs(orbiting) do
        local fc = calculateGravitationalForce(body, central)
        body:applyForce(fc, dt)
        
        for l, other in pairs(orbiting) do
            if l ~= k then
                local f = calculateGravitationalForce(body, other)
                body:applyForce(f, dt)
            end
        end

        body:update(dt)
    end
end

function love.draw()
    -- Draw central circle
    love.graphics.setColor(1, 0, 0)
    central:render()

    -- Draw orbiting circle
    love.graphics.setColor(0, 0, 1)
    for k, body in pairs(orbiting) do
        body:render()
    end
end
