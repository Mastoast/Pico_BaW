-- accelerators / slowers
-- black shapes

rectangle = new_type(0)
rectangle.color = 7

function rectangle.draw(self)
    rectfill(self.x, self.y, self.x + self.hit_w - 1, self.y + self.hit_h - 1, self.color)
end

--

block = new_type(6)
block.color = 7
block.solid = false

----
elipse = new_type(0)
elipse.color = 7

function elipse.draw(self)
    ovalfill(self.x, self.y, self.x + self.hit_w, self.y + self.hit_h, self.color)
end

----

exit = new_type(0)
exit.color = 7
exit.solid = false

function exit.draw(self)
    circ(self.x + self.hit_w/2, self.y + self.hit_h/2, 4, exit.color)
    circ(self.x + self.hit_w/2, self.y + self.hit_h/2, 2, exit.color)
end

----

counter = new_type(0)
counter.solid = false
counter.life = 30
counter.number = 0
counter.color = 0

function counter.update(self)
    self.y -= 1 * gtime % 2
    self.life -= 1
    if self.life == 0 then self.destroyed = true end
end

function counter.draw(self)
    print(self.number, self.x, self.y, revcol(self.color))
    self.color = revcol(self.color)
end

----

function update_move_x(self)
    self:move_x(self.facing, reverse_facing)
end

function update_move_y(self)
    self:move_y(self.facing, reverse_facing)
end

function update_rotate(self)
    self.direction = self.direction or 0
    if self.direction == 0 then self:move_x(-1, rotate_direction)
    elseif self.direction == 2 then self:move_x(1, rotate_direction)
    elseif self.direction == 1 then self:move_y(-1, rotate_direction)
    elseif self.direction == 3 then self:move_y(1, rotate_direction) end
end

function reverse_facing(self)
    self.facing *= -1
end

function rotate_direction(self)
    self.direction = (self.direction + self.facing) % 4
end