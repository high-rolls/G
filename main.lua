require 'Body'
vector = require 'hump.vector'

-- Constants
local G = 5000 -- Gravitational constant (adjust for scale)

local bodies = {
    Body(vector(200, 200), vector(0, 0), 500, 10, {1, 0, 0}, true), -- central fixed circle
    Body(vector(600, 400), vector(0, 0), 500, 10, {1, 0.5, 0}, true), -- another fixed circle
    Body(vector(600, 300), vector(0, -150), 20, 2, {0, 0, 1}),
    Body(vector(200, 300), vector(0, 150), 20, 2, {0, 1, 0}),
    Body(vector(400, 500), vector(150, 0), 20, 2, {0, 1, 1})
}

local function calculateGravitationalForce(bodyFrom, bodyTo)
    local distance = bodyFrom.pos:dist(bodyTo.pos)
    if distance == 0 then return vector(0, 0) end -- Avoid division by zero

    local force = G * (bodyFrom.mass * bodyTo.mass) / (distance^2)
    local direction = (bodyTo.pos - bodyFrom.pos):normalized()
    return direction * force
end

-- Love2D callbacks
function love.update(dt)
    -- Calculate gravitational force
    for k = 1, #bodies do
        local body = bodies[k]
        
        for l = k + 1, #bodies do
            local other = bodies[l]
            local f = calculateGravitationalForce(body, other)
            body:applyForce(f)
            other:applyForce(-1 * f)
        end

        body:update(dt)
    end
end

function love.draw()
    for _, body in pairs(bodies) do
        body:render()
    end
end
