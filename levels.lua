start_spr = 18
exit_spr = 19

levels = {
    {
        map = {x = 0, y = 0},
        shots = 1
    },
    {
        map = {x = 16, y = 0},
        shots = 2
    },
    {
        map = {x = 32, y = 0},
        shots = 3
    },
    {
        map = {x = 48, y = 0},
        shots = 3
    },
    {
        map = {x = 64, y = 0},
        shots = 3,
        init = function()
            local rect1 = create(rectangle, 3*8, 5*8, 8, 40)
            rect1.update = update_move_y
            local rect2 = create(rectangle, 6*8, 0*8, 8, 40)
            rect2.update = update_move_y
            local rect3 = create(rectangle, 9*8, 0*8, 8, 40)
            rect3.update = update_move_y
            local rect4 = create(rectangle, 12*8, 5*8, 8, 40)
            rect4.update = update_move_y
        end
    },
    {
        map = {x = 80, y = 0},
        shots = 4,
        init = function()
            local rect1 = create(rectangle, 8*8, 10*8, 8, 24)
            rect1.update = update_move_y
        end
    },
    {
        map = {x = 96, y = 0},
        shots = 10,
        init = function()
            local rect1 = create(rectangle, 13*8, 1*8, 16, 16)
            rect1.update = update_rotate
            rect1.direction = 2
            local rect2 = create(rectangle, 1*8, 13*8, 16, 16)
            rect2.update = update_rotate
            local rect3 = create(rectangle, 13*8, 13*8, 16, 16)
            rect3.update = update_rotate
            local rect4 = create(rectangle, 1*8, 1*8, 16, 16)
            rect4.update = update_rotate
        end
    },
    {
        map = {x = 112, y = 0},
        shots = 3
    },
}

function load_level(i)
    objects = {}
    freeze_time = 0
    shake = 0
    infade = 0
    --
    if levels[i].init then levels[i].init() end
    gen_level(i)
    current_player.shots = levels[i].shots or player.shots
end

function restart_level()
    load_level(current_level)
end

function gen_level(i)
    local lmap = levels[i].map
    for i=lmap.x,lmap.x + 15 do
        local last_rect = nil
        local last_block = nil
        for y=lmap.y,lmap.y + 15 do
            --
            if mget(i, y) == 1 then
                if last_rect != nil then
                    last_rect.hit_h += 8
                else
                    last_rect = create(rectangle, i*8 - lmap.x*8, y*8 - lmap.y*8)
                end
            else
                last_rect = nil
            end
            --
            if mget(i, y) == 6 then
                if last_block then
                    last_block.hit_h += 8
                else
                    last_block = create(block, i*8 - lmap.x*8, y*8 - lmap.y*8)
                end
            else
                last_block = nil
            end
            --
            if mget(i, y) == start_spr then current_player = create(player, i*8 - lmap.x*8, y*8 - lmap.y*8) end
            --
            if mget(i, y) == exit_spr then current_exit = create(exit, i*8 - lmap.x*8, y*8 - lmap.y*8) end
        end
    end
end