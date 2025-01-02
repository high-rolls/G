Class = require 'hump.class'
vector = require 'hump.vector'

Body = Class{
    init = function(self, pos, vel, mass, radius)
        self.pos = pos
        self.vel = vel
        self.mass = mass
        self.radius = radius
    end
}

function Body:update(dt)
    self.pos = self.pos + self.vel * dt
end

function Body:render()
    love.graphics.circle('fill', self.pos.x, self.pos.y, self.radius)
end

function Body:applyForce(force, dt)
    self.vel = self.vel + (force / self.mass) * dt
end