pico-8 cartridge // http://www.pico-8.com
version 7
__lua__

-- wall collision example
-- by zep

actor = {} --all actors in world

-- make an actor
-- and add to global collection
-- x,y means center of the actor
-- in map tiles (not pixels)
function make_actor(x, y)
 a={}
 a.x = x
 a.y = y
 a.dx = 0
 a.dy = 0
 a.spr = 16
 a.frame = 0
 a.t = 0
 a.inertia = 0.6
 a.bounce  = 1

 -- half-width and half-height
 -- slightly less than 0.5 so
 -- that will fit through 1-wide
 -- holes.
 a.w = 0.4
 a.h = 0.4

 add(actor,a)

 return a
end

function _init()
 -- make player top left
 pl = make_actor(2,2)
 pl.spr = 17

 -- make a bouncy ball
 local ball = make_actor(8.5,7.5)
 ball.spr = 33
 ball.dx=0.05
 ball.dy=-0.1
 ball.inertia=1

 -- make less bouncy ball
 local ball = make_actor(7,5)
 ball.spr = 49
 ball.dx=-0.1
 ball.dy=0.15
 ball.inertia=1
 ball.bounce = 0.8

end

-- for any given point on the
-- map, true if there is wall
-- there.

function solid(x, y)

 -- grab the cell value
 val=mget(x, y)

 -- check if flag 1 is set (the
 -- orange toggle button in the
 -- sprite editor)
 return fget(val, 1)

end

-- solid_area
-- check if a rectangle overlaps
-- with any walls

--(this version only works for
--actors less than one tile big)

function solid_area(x,y,w,h)

 return
  solid(x-w,y-h) or
  solid(x+w,y-h) or
  solid(x-w,y+h) or
  solid(x+w,y+h)
end

function move_actor(a)

 -- only move actor along x
 -- if the resulting position
 -- will not overlap with a wall

 if not solid_area(a.x + a.dx,
  a.y, a.w, a.h) then
  a.x += a.dx
 else
  -- otherwise bounce
  a.dx *= -a.bounce
  sfx(2)
 end

 -- ditto for y

 if not solid_area(a.x,
  a.y + a.dy, a.w, a.h) then
  a.y += a.dy
 else
  a.dy *= -a.bounce
  sfx(2)
 end

 -- apply inertia
 -- set dx,dy to zero if you
 -- don't want inertia

 a.dx *= a.inertia
 a.dy *= a.inertia

 -- advance one frame every
 -- time actor moves 1/4 of
 -- a tile

 a.frame += abs(a.dx) * 4
 a.frame += abs(a.dy) * 4
 a.frame %= 2 -- always 2 frames

 a.t += 1

end

function control_player(pl)

 -- how fast to accelerate
 accel = 0.1
 if (btn(0)) pl.dx -= accel
 if (btn(1)) pl.dx += accel
 if (btn(2)) pl.dy -= accel
 if (btn(3)) pl.dy += accel

 -- play a sound if moving
 -- (every 4 ticks)

 if (abs(pl.dx)+abs(pl.dy) > 0.1
     and (pl.t%4) == 0) then
  sfx(1)
 end

end

function _update()
 control_player(pl)
 foreach(actor, move_actor)
end

function draw_actor(a)
 local sx = (a.x * 8) - 4
 local sy = (a.y * 8) - 4
 spr(a.spr + a.frame, sx, sy)
end

function _draw()
 cls()
 map(0,0,0,0,16,16)
 foreach(actor,draw_actor)

 print("x "..pl.x,0,120,7)
 print("y "..pl.y,64,120,7)

end
