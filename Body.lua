Class = require 'hump.class'
vector = require 'hump.vector'

Body = Class{
    init = function(self, pos, vel, mass, radius, color, fixed)
        self.pos = pos
        self.vel = vel
        self.acc = vector(0, 0)
        self.mass = mass
        self.radius = radius
        self.color = color or {1, 1, 1} -- defaults to white
        self.fixed = fixed or false -- defaults to false if not specified
    end
}

function Body:update(dt)
    self.vel = self.vel + self.acc * dt
    self.pos = self.pos + self.vel * dt
    self.acc = vector(0, 0)
end

function Body:render()
    love.graphics.setColor(self.color)
    love.graphics.circle('fill', self.pos.x, self.pos.y, self.radius)
end

function Body:applyForce(force)
    if not self.fixed then
        self.acc = self.acc + (force / self.mass)
    end
end