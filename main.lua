require 'Body'
require 'dump'
local vector = require 'hump.vector'
local json = require 'json'

-- Constants
local G = 6.674 * 10^-11 -- Gravitational constant (adjust for scale)

local bodies = {}

local function loadBodiesFromJSON(filename)
    local file = love.filesystem.read(filename)
    local bodiesData = json.decode(file)

    local loadedBodies = {}
    for _, bodyData in ipairs(bodiesData) do
        local pos = vector(bodyData.pos[1], bodyData.pos[2])
        local vel = vector(bodyData.vel[1], bodyData.vel[2])
        local mass = bodyData.mass
        local radius = bodyData.radius
        local color = bodyData.color
        local fixed = bodyData.fixed

        table.insert(loadedBodies, Body(pos, vel, mass, radius, color, fixed))
    end

    return loadedBodies
end

local function calculateGravitationalForce(bodyFrom, bodyTo)
    local distance = bodyFrom.pos:dist(bodyTo.pos)
    if distance == 0 then return vector(0, 0) end -- Avoid division by zero

    local force = G * (bodyFrom.mass * bodyTo.mass) / (distance^2)
    local direction = (bodyTo.pos - bodyFrom.pos):normalized()
    return direction * force
end

function love.load()
    bodies = loadBodiesFromJSON('bodies.json')
    print("bodies: ", dump(bodies))
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
