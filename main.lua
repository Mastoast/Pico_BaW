-- TODO menu screen

function _init()
    -- enable mouse
    poke(0x5f2d, 1)
    -- stat(32) -> X coord
    -- stat(33) -> Y coord
    -- stat(34) -> button bitmask (1=primary, 2=secondary, 4=middle)
    gtime = 0
    freeze_time = 0
    shake = 0
    infade = 0
    fade_time = 40
    current_level = 1
    printable = nil
    load_level(current_level)
end

function _update60()
    -- timers
    gtime += 1
    shake = max(shake - 1)
    infade = min(infade + 1, fade_time)

    -- freeze
    if freeze_time > 0 then
        freeze_time -= 1
    else
        for o in all(objects) do
            if o.freeze > 0 then
                o.freeze -= 1
            else
                o:update()
            end

            if o.base != player and o.destroyed then
                del(objects, o)
            end
        end
    end
end

function _draw()
    cls(0)
    
    -- camera
    if shake > 0 then
        camera(0 - 2 + rnd(5), 0 - 2 + rnd(5))
    else
        camera(0, 0)
    end

    -- draw map
    --map(levels[current_level].map.x, levels[current_level].map.y, 0, 0, 16, 16)

    -- draw objects
    local ply = nil
    for o in all(objects) do
        if o.base == player then ply = o else o:draw() end
    end
    -- draw player last
	if ply then ply:draw() end

    -- draw level text
    if levels[current_level].texts and ply.state < 2 then
        for item in all(levels[current_level].texts) do
            print_centered(item.text, 0, item.y, item.color)
        end
    end

    -- draw cursor
    draw_cursor()

    -- draw fades
    if infade != fade_time then
        circfill(current_player.x + current_player.hit_w/2, current_player.y + current_player.hit_h/2, 360 * (1 - infade/fade_time), 6)
        circfill(current_player.x + current_player.hit_w/2, current_player.y + current_player.hit_h/2, 180 * (1 - infade/fade_time), 0)
    end

    -- borders
    rect(0, 0, 127, 127, 7)
    
    --print(printable, 80, 120, 4)
end

function draw_cursor()
    local pixels = {{x = 0, y = -2}, {x = -2, y = 0}, {x = 2, y = 0}, {x = 0, y = 2}, {x = 0, y = 0}}
    for p in all(pixels) do
        pset(stat(32) + p.x, stat(33) + p.y, revcol(pget(stat(32) + p.x, stat(33) + p.y)))
    end
end

function revcol(color)
    if color == 0 then return 7 else return 0 end
end

-- linear interpolation
function lerp(start,finish,t)
    return mid(start,start*(1-t)+finish*t,finish)
end

-- print at center
function print_centered(str, offset_x, y, col)
    print(str, 64 - (#str * 2) + offset_x, y, col)
end