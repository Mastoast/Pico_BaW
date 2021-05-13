player = new_type(1)
player.color = 7
player.hit_w = 4
player.hit_h = 4
player.speed = 5
player.shots = 3
player.clean_timer = 0
player.state = 1
player.dashing = false
player.solid = false
player.moved = false

-- TODO add particules on win / death / movement
-- TODO Musics / Mix
-- TODO controls with mouse too
function player.init(self)
    self.points = {}
    
end

-- States
-- 1 : alive
-- 2 : exited
-- 3 : dead

function player.update(self)
    self.dest_x = self.dest_x or self.x
    self.dest_y = self.dest_y or self.y

    if self.clean_timer > 0 then
        self.clean_timer -= 1
        if self.clean_timer == 0 then
            if self.state == 2 then
                current_level += 1
                load_level(current_level)
            elseif self.state == 3 then
                load_level(current_level)
            end
            freeze_time = 30
        end
    end

    -- reset
    if self.moved and btnp(4) then self:die() end

    -- lerp
    if self.dashing then
        mm = max(abs(self.dest_x - self.x), abs(self.dest_y - self.y)) * 1/self.speed
        if mm == 0 then
            deli(self.points, 1)
            self.dashing = false
        else
            self.x  = lerp(self.x, self.dest_x, 1/mm)
            self.y  = lerp(self.y, self.dest_y, 1/mm)
        end
    end

    -- place point
    if btnp(4)  and not self.moved then
        local contact = false
        local np = create_point(stat(32), stat(33))
        -- check last point colision
        if #self.points > 0 and object.overlaps(self.points[#self.points], np) then
            deli(self.points, #self.points)
            sfx(0,0,20,4)
            contact = true
            self:show_counter()
        end
        -- check exit
        for o in all(objects) do
            if o.base == exit and o:overlaps(np) then
                np.x, np.y = o.x + o.hit_w/2, o.y + o.hit_h/2
                break
            end
        end
        if #self.points >= self.shots then
            -- no more shots
            self:show_counter()
            sfx(0,0,12,4)
        elseif not contact then
            add(self.points, np)
            sfx(0,0,8,4)
            self:show_counter()
        end
    end
    -- dash to point
    if btnp(5) then
        if #self.points > 0 and not self.dashing then
            self.moved = true
            self.dest_x = self.points[1].x - self.hit_w/2
            self.dest_y = self.points[1].y - self.hit_h/2
            self.dashing = true
            sfx(1,0,0,4)
        end
    end

    -- collisions
    if self.state == 1 then
        for o in all(objects) do
            if o.base == exit and self:overlaps(o) then
                self:exit()
            elseif (o.base == rectangle or o.base == block) and self:overlaps(o) then
                self:die()
            end
        end
    end
end

function player.draw(self)
    -- player
    rectfill(self.x, self.y, self.x + self.hit_w, self.y + self.hit_h, self.color)
    circ(self.x + self.hit_w/2, self.y + self.hit_h/2, self.hit_w/2, revcol(self.color))

    
    -- points
    for p in all(self.points) do
        circ(p.x, p.y, p.radius, self.color)
    end
    -- lines
    if #self.points > 0 then
        fillp(0b0101101001011010)
        line(self.x + self.hit_w/2, self.y + self.hit_h/2, self.points[1].x, self.points[1].y)
        for i=1,#self.points - 1 do
            line(self.points[i].x,self.points[i].y,self.points[i+1].x,self.points[i+1].y)
        end
        fillp()
    end
    -- death
    if self.state != 1 then
        local mod = 1 - (fade_time + 1)/self.clean_timer
        rectfill(self.x + self.hit_w/2 - mod * 50, self.y + self.hit_h/2 - mod * 50,
            self.x + self.hit_w/2 + mod * 50, self.y + self.hit_h/2  + mod * 50, self.color)
        rectfill(self.x + self.hit_w/2 - mod * 35, self.y + self.hit_h/2 - mod * 35,
            self.x + self.hit_w/2 + mod * 35, self.y + self.hit_h/2  + mod * 35, revcol(self.color))
    end
end

function player.die(self)
    freeze_time = 5
    shake = 5
    self.clean_timer = fade_time
    self.state = 3
    sfx(0,0,0,8)
end

function player.exit(self)
    self.clean_timer = fade_time
    self.state = 2
    sfx(0,0,24,8)
end

function player.show_counter(self)
    local ncounter = create(counter, stat(32) - 1, stat(33) - 6)
    ncounter.number = self.shots - #self.points
end

function ply_collide(self, current, dest)
    -- 
end

-- Point
function create_point(x, y)
    local point = {x = x, y = y, hit_x = -4, hit_y = -4, hit_w = 8, hit_h = 8, radius = 3}
    return point
end