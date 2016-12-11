pico-8 cartridge // http://www.pico-8.com
version 8
__lua__

layer0globalactors = {}
layer1globalactors = {}
layer2globalactors = {}

hero = {}
hero_swordactive = false
hero_shieldactive = false
hero_speed = 4
shield = {}
sword = {}
shieldup = {}

herolife = 3
monsterlife = 3
monsters = {}
bullets = {}

globalgamemode = 0
globalgamelevel = 1
globaltime = 0
globalnextmonstertime = 0

globalmonsterspawninterval = 30 -- 2 seconds
globalbulletinterval = 30 -- 1 second\
globalswipeinterval = 30 -- 1 second
globalmonsterpiecedeath = 400
globalfistmovementspeed = 2

lastknowndirection = ""
playerFriendlyY = 100

flagbulletmonster = 0
flagweakpoint = 1
flagsword = 2
flagshield = 3
flaghero = 4

keypresstimer = -1
bodycount = 0



-- ====================================================
-- pico-8 required methods
function _init()

end


function _update()

  if globalgamemode == 0 then update_game_title()
  elseif globalgamemode == 1 then update_backstory()
  elseif globalgamemode == 2 then update_game_main()
  elseif globalgamemode == 3 then update_Interlude()
  elseif globalgamemode == 4 then update_Player_Dead()
  end
end

function _draw()

  if globalgamemode == 0 then draw_game_title()
  elseif globalgamemode == 1 then draw_backstory()
  elseif globalgamemode == 2 then draw_game_main()
  elseif globalgamemode == 3 then draw_Interlude()
  elseif globalgamemode == 4 then draw_Player_Dead()
  end

end


-- ====================================================
-- gamestate - 0 - title
function update_game_title()
  if btn(0) then start_game()
  elseif btn(1) then start_game()
  elseif btn(2) then start_game()
  elseif btn(3) then start_game()
  elseif btn(4) then start_game()
  elseif btn(5) then start_game()
  end
end

function draw_game_title()
  _gametitle = "one more tomorrow"
  rectfill(0,0,128,128,0)
  print(_gametitle,hcenter(_gametitle),vcenter(_gametitle),3)
  print(_gametitle,hcenter(_gametitle)+.5,vcenter(_gametitle)+.5,3)
  _pressabutton = "press a button"
  print(_pressabutton,hcenter(_pressabutton),vcenter(_pressabutton) + 10, 6)
end

function start_game()
    globalgamemode = 1
    --globalgamelevel = 1

    --globaltime = 0
    --globalnextmonstertime += globalmonsterspawninterval
    --monsterlife = 3
    --create_hero()
end

function create_hero()

    hero =  make_actor(0,100,1,"hero")
    if (globalgamelevel == 1) then
        hero.idlesprite = 5
        hero.movesprite = 4
        hero.upsprite = 3
    elseif (globalgamelevel == 1) then
        hero.idlesprite = 21
        hero.movesprite = 20
        hero.upsprite = 19
    elseif (globalgamelevel == 1) then
        hero.idlesprite = 37
        hero.movesprite = 36
        hero.upsprite = 35
    elseif (globalgamelevel == 1) then
        hero.idlesprite = 53
        hero.movesprite = 52
        hero.upsprite = 51
    end

    hero.shieldsprite = 1
    hero.shieldupsprite = 33
    hero.swordsprite = 6

    hero.hitbox = {x=2, y=0, w=6, h=8}
    sword.hitbox = {x=0, y=3, w=8, h=2}
    shield.hitbox = {x=0, y=0, w=6, h=8}
    shieldup.hitbox = {x=0, y=6, w=8, h=4}

    hero.life = 3
    hero.visible = true
    hero.sprite = hero.idlesprite
end



-- ====================================================
function update_game_main()
    globaltime += 1

    check_hero_keypress()

    check_all_monster_piece_death()
    check_all_bullets_death()

    move_active_monster_pieces()
    move_bullets()

    create_monster()
    check_create_bullets_from_monsters()

    check_for_all_shield_hits()
    check_for_all_sword_hits()
    check_for_all_hero_hits()

    check_for_monster_defeat()
    check_for_hero_death()
end

-- HERO
function check_hero_keypress()

    hero_shieldactive = false
    hero_swordactive = false

    if btn(5) then
        hero_shieldactive = true
    else
        hero_shieldactive = false
        if btn(4) then
            hero_swordactive = true
            hero_shieldactive = false
        else
            hero_swordactive = false
        end
    end

    if btn(0) then hero.x -= hero_speed
        toggle_hero_movement_sprites()
        if hero.x < 0 then hero.x = 0 end
        lastknowndirection = "left"
    elseif btn(1) then hero.x += hero_speed
        toggle_hero_movement_sprites()
        if hero.x > 122 then hero.x = 122 end
        lastknowndirection = "right"
    elseif btn(2) then
        hero.sprite = hero.upsprite
        lastknowndirection = "up"
    else
        hero.sprite = hero.idlesprite
    end
end

function toggle_hero_movement_sprites()
    if (hero.sprite == hero.idlesprite) then
        hero.sprite = hero.movesprite
    else
        hero.sprite = hero.idlesprite
    end
end

-- MONSTERS
function create_monster()
    if globaltime >= globalnextmonstertime then

        _newMonster = {}

        monsterid =  flr(rnd(8))

        if (monsterid == 1 and bodycount >= 1) then
                monsterid =  flr(rnd(8))
        end
        if (monsterid == 1 and bodycount >= 1) then
            monsterid =  flr(rnd(8))
        end
        if (monsterid == 1 and bodycount >= 1) then
            monsterid =  flr(rnd(8))
        end

        if (monsterid == 0) then -- head
            _newMonster = make_actor(0,0,1,"head")
            _newMonster.sprite1 = 9
            _newMonster.sprite2 = 10
            _newMonster.sprite3 = 25
            _newMonster.sprite4 = 26
            _newMonster.x = flr(rnd(120)) + 8
            _newMonster.y = flr(rnd(60))
            _newMonster.dx = flr(rnd(2))
            if (_newMonster.x > 64) then
                _newMonster.dx *= -1
            end
            _newMonster.dy = 0
            _newMonster.bullettimer = globaltime + globalbulletinterval
            _newMonster.bulletdx = 0
            _newMonster.bulletdy = globalfistmovementspeed
            _newMonster.deathtimer = globaltime + globalmonsterpiecedeath
            _newMonster.hitbox = {x=0, y=0, w=1, h=1}

        elseif (monsterid == 1) then -- body
            _newMonster = make_actor(0,0,1,"body")
            _newMonster.sprite1 = 41
            _newMonster.sprite2 = 42
            _newMonster.sprite3 = 57
            _newMonster.sprite4 = 58
            _newMonster.x = flr(rnd(108)) + 10
            _newMonster.y = playerFriendlyY - 4
            _newMonster.dx = 0
            _newMonster.dy = 0
            _newMonster.bullettimer = -1
            _newMonster.deathtimer = globaltime + globalmonsterpiecedeath
            _newMonster.hitbox = {x=4, y=4, w=8, h=8}
            bodycount += 1

        elseif (monsterid == 2) then -- left fist
            _newMonster = make_actor(0,0,1,"leftfist")
            _newMonster.sprite1 = 24
            _newMonster.sprite2 = -1
            _newMonster.sprite3 = -1
            _newMonster.sprite4 = -1
            _newMonster.x = 0
            _newMonster.y = playerFriendlyY
            _newMonster.dx = globalfistmovementspeed
            _newMonster.dy = 0
            _newMonster.bullettimer = -1
            _newMonster.deathtimer = globaltime + globalmonsterpiecedeath
            _newMonster.hitbox = {x=0, y=0, w=6, h=8}

        elseif (monsterid == 3) then
            _newMonster = make_actor(0,0,1,"rightfist")
            _newMonster.sprite1 = 27
            _newMonster.sprite2 = -1
            _newMonster.sprite3 = -1
            _newMonster.sprite4 = -1
            _newMonster.x = 122
            _newMonster.y = playerFriendlyY
            _newMonster.dx = (globalfistmovementspeed * -1)
            _newMonster.dy = 0
            _newMonster.bullettimer = -1
            _newMonster.deathtimer = globaltime + globalmonsterpiecedeath
            _newMonster.hitbox = {x=2, y=0, w=6, h=8}

        elseif (monsterid == 4) then
            _newMonster = make_actor(0,0,1,"leftpalmhigh")
            _newMonster.sprite1 = 40
            _newMonster.sprite2 = -1
            _newMonster.sprite3 = -1
            _newMonster.sprite4 = -1
            _newMonster.x = flr(rnd(108)) + 20
            _newMonster.y = flr(rnd(60))
            _newMonster.dx = globalfistmovementspeed
            _newMonster.dy = 0
            if (_newMonster.x > 64) then
                _newMonster.dx *= -1
            end
            _newMonster.bullettimer = globaltime + globalbulletinterval
            _newMonster.bulletdx = 0
            _newMonster.bulletdy = globalfistmovementspeed
            _newMonster.deathtimer = globaltime + globalmonsterpiecedeath
            _newMonster.hitbox = {x=0, y=0, w=1, h=1}

        elseif (monsterid == 5) then
            _newMonster = make_actor(0,0,1,"rightpalmhigh")
            _newMonster.sprite1 = 43
            _newMonster.sprite2 = -1
            _newMonster.sprite3 = -1
            _newMonster.sprite4 = -1
            _newMonster.x = flr(rnd(108)) + 20
            _newMonster.y = flr(rnd(60))
            _newMonster.dx = (globalfistmovementspeed * -1)
            _newMonster.dy = 0
            if (_newMonster.x > 64) then
                _newMonster.dx *= -1
            end
            _newMonster.bullettimer = globaltime + globalbulletinterval
            _newMonster.bulletdx = 0
            _newMonster.bulletdy = globalfistmovementspeed
            _newMonster.deathtimer = globaltime + globalmonsterpiecedeath
            _newMonster.hitbox = {x=0, y=0, w=1, h=1}

        elseif (monsterid == 6) then
            _newMonster = make_actor(0,0,1,"leftpalmlow")
            _newMonster.sprite1 = 56
            _newMonster.sprite2 = -1
            _newMonster.sprite3 = -1
            _newMonster.sprite4 = -1
            _newMonster.x = 0
            _newMonster.y = playerFriendlyY
            _newMonster.dx = 0
            _newMonster.dy = 0
            _newMonster.bullettimer = globaltime + globalbulletinterval
            _newMonster.bulletdx = globalfistmovementspeed
            _newMonster.bulletdy = 0
            _newMonster.deathtimer = globaltime + globalmonsterpiecedeath
            _newMonster.hitbox = {x=0, y=0, w=6, h=8}

        elseif (monsterid == 7) then
            _newMonster = make_actor(0,0,1,"rightpalmlow")
            _newMonster.sprite1 = 59
            _newMonster.sprite2 = -1
            _newMonster.sprite3 = -1
            _newMonster.sprite4 = -1
            _newMonster.x = 118
            _newMonster.y = playerFriendlyY
            _newMonster.dx = 0
            _newMonster.dy = 0
            _newMonster.bullettimer = globaltime + globalbulletinterval
            _newMonster.bulletdx = (globalfistmovementspeed * -1)
            _newMonster.bulletdy = 0
            _newMonster.deathtimer = globaltime + globalmonsterpiecedeath
            _newMonster.hitbox = {x=2, y=0, w=6, h=8}
        end

        sfx(5, -1)
        _newMonster.active = true
        add(monsters,_newMonster)
        globalnextmonstertime += globalmonsterspawninterval
    end

end

function check_all_monster_piece_death()
    foreach(monsters, check_monster_death)
end

function check_monster_death(actor)
    if (globaltime >= actor.deathtimer) then
        if (actor.class == "body") then
            bodycount -= 1
        end
        del(monsters, actor)
    end
end


function move_active_monster_pieces()
  foreach(monsters, move_all_monsterpieces)
end

function move_all_monsterpieces(actor)
    actor.x += actor.dx
    actor.y += actor.dy
end

function check_create_bullets_from_monsters()
    foreach(monsters, check_create_bullet)
end

function check_create_bullet(actor)
    if (actor.bullettimer >= 0 and globaltime >= actor.bullettimer) then
        sfx(4, -1)
        _newbullet = {}
        _newbullet.x = actor.x
        _newbullet.y = actor.y
        _newbullet.dx = actor.bulletdx
        _newbullet.dy = actor.bulletdy
        _newbullet.sprite1 = 0
        _newbullet.sprite2 = 16
        _newbullet.deathtimer = globaltime + 60
        add(bullets,_newbullet)

        _newbullet.sprite = _newbullet.sprite1
        _newbullet.hitbox = {x=2, y=2, w=4, h=4}

        actor.bullettimer = globaltime + globalbulletinterval
    end
end

function move_bullets()
    foreach(bullets, move_bullet)
end

function move_bullet(actor)
    actor.x += actor.dx
    actor.y += actor.dy
    if actor.sprite == actor.sprite1 then
        actor.sprite = actor.sprite2
    else
        actor.sprite = actor.sprite1
    end
end

function check_all_bullets_death()
    foreach(bullets, check_bullet_death)
end

function check_bullet_death(actor)
    if (globaltime >= actor.deathtimer) then
        del(bullets, actor)
    end
end



function draw_game_main()
    rectfill(0,0,128,128,0)
    draw_monster_pieces()
    draw_bullets()
    draw_game_hero()
    draw_debug()
end


function draw_game_hero()
    if hero.visible == true then
        if (lastknowndirection == "left") then
            spr(hero.sprite, hero.x, hero.y, 1, 1, true, false)
            if (hero_swordactive) then
                spr(hero.swordsprite, hero.x-6, hero.y + 1, 1, 1, true, false)
            end
            if (hero_shieldactive) then

                spr(hero.shieldsprite, hero.x-7, hero.y, 1, 1, true, false)
            end
        elseif (lastknowndirection == "right") then
            spr(hero.sprite, hero.x, hero.y)
            if (hero_swordactive) then
                spr(hero.swordsprite, hero.x+6, hero.y + 1, 1, 1, false, false)
            end
            if (hero_shieldactive) then
                spr(hero.shieldsprite, hero.x+7, hero.y, 1, 1, false, false)
            end
        elseif (lastknowndirection == "up") then
            spr(hero.sprite, hero.x, hero.y)
            if (hero_shieldactive) then
                spr(hero.shieldupsprite, hero.x, hero.y - 8, 1, 1, false, false)
            end
        end
    end
end

function draw_monster_pieces()
    foreach(monsters, draw_monster)
end

function draw_monster(actor)
    if actor.sprite1 >= 0 then
        spr(actor.sprite1, actor.x, actor.y)
    end
    if actor.sprite2 >= 0 then
        spr(actor.sprite2, actor.x + 8, actor.y)
    end
    if actor.sprite3 >= 0 then
        spr(actor.sprite3, actor.x, actor.y + 8)
    end
    if actor.sprite4 >= 0 then
        spr(actor.sprite4, actor.x + 8, actor.y + 8)
    end
end

function draw_bullets()
    foreach(bullets, draw_bullet)
end

function draw_bullet(actor)
    if actor.sprite >= 0 then
        spr(actor.sprite, actor.x, actor.y)
    end
end



function check_for_all_shield_hits()
    if (hero_shieldactive) then
        shieldhitbox = {}

        if (lastknowndirection == "left") then
            shieldhitbox = shield
            shieldhitbox.x = hero.x-7
            shieldhitbox.y = hero.y

        elseif (lastknowndirection == "right") then
            shieldhitbox = shield
            shieldhitbox.x = hero.x+7
            shieldhitbox.y = hero.y

        else
            shieldhitbox = shieldup
            shieldhitbox.x = hero.x-8
            shieldhitbox.y = hero.y

        end

        for bullet in all(bullets) do
            if (collide(shieldhitbox, bullet)) then
                sfx(0, -1)
                del(bullets, bullet)
            end
        end

        for piece in all(monsters) do
            if (piece.active == true) then
                if (collide(shieldhitbox, piece)) then
                    if (piece.dx > 0) then
                        hero.x += 4
                    else
                        hero.x -= 4
                    end
                    sfx(3, -1)
                    piece.active = false
                end
            end
        end
    end
end

function check_for_all_sword_hits()
    if (hero_swordactive) then
        if (lastknowndirection == "left") then
            sword.x = hero.x-6
            sword.y = hero.y
        else
            sword.x = hero.x+6
            sword.y = hero.y
        end

        for piece in all(monsters) do
            if (collide(sword, piece)) then
                if (piece.class == "body") then
                    monsterlife -= 1
                    bodycount -= 1
                    sfx(1, -1)
                end
                del(monsters, piece)
            end
        end
    end
end

function check_for_all_hero_hits()
    for piece in all(monsters) do
        if (piece.active == true) then
            if (collide(hero, piece)) then
                if (piece.class != "body") then
                    herolife -= 1
                    sfx(1, -1)
                    piece.active = false;
                end
            end
        end
    end

    for bullet in all(bullets) do
        if (collide(hero, bullet)) then
            herolife -= 1
            del(bullets, bullet)
        end
    end
end



function draw_debug()
    print("h "..herolife,0,10,7)
    print("m "..monsterlife,64,10,7)
end






function check_for_monster_defeat()
    if (monsterlife <= 0) then
        keypresstimer = 60
        globalgamemode = 3
        monster = {}
        hero = {}
    end
end

function check_for_hero_death()
    if (herolife <= 0) then
        keypresstimer = 60
        globalgamemode = 4
        monster = {}
        hero = {}
    end
end












function update_backstory()
    keypresstimer -= 1
    if (keypresstimer < 0) then
      if btn(0) then initial_wave()
      elseif btn(1) then initial_wave()
      elseif btn(2) then initial_wave()
      elseif btn(3) then initial_wave()
      elseif btn(4) then initial_wave()
      elseif btn(5) then initial_wave()
      end
  end
end


function draw_backstory()
    rectfill(0,0,128,128,0)
    _gametitle = "For generations, your family has"
    print(_gametitle,hcenter(_gametitle),vcenter(_gametitle),2)

    _pressabutton = " fought an ancient evil. "
    print(_pressabutton,hcenter(_pressabutton),vcenter(_pressabutton) + 10, 2)



    _pressabutton = "Now it is your turn..."
    print(_pressabutton,hcenter(_pressabutton),vcenter(_pressabutton) + 20, 6)
end

function initial_wave()

    globalgamemode = 2
    globalgamelevel = 1

    globaltime = 0
    globalnextmonstertime += globalmonsterspawninterval
    monsterlife = 3
    herolife = 3
    hero_speed = 4
    create_hero()
end


-- =============================================
function update_Interlude()
    keypresstimer -= 1
    if (keypresstimer < 0) then
        if btn(0) then next_wave()
        elseif btn(1) then next_wave()
        elseif btn(2) then next_wave()
        elseif btn(3) then next_wave()
        elseif btn(4) then next_wave()
        elseif btn(5) then next_wave()
        end
    end
end


function draw_Interlude()
    rectfill(0,0,128,128,0)
    _gametitle = "It's been 20 years since"
    print(_gametitle,hcenter(_gametitle),vcenter(_gametitle),2)

    _pressabutton = " you last fought the demon."
    print(_pressabutton,hcenter(_pressabutton),vcenter(_pressabutton) + 10, 2)



    _pressabutton = "But evil never rests..."
    print(_pressabutton,hcenter(_pressabutton),vcenter(_pressabutton) + 20, 6)

end

function next_wave()
    globalgamemode = 2
    globalgamelevel = 2

    globaltime = 0
    globalnextmonstertime = globalmonsterspawninterval
    monsterlife = 3
    herolife = 3
    create_hero()

    -- MAKE SLOWER HERE
    hero_speed -= 1
end

-- =============================================
function update_Player_Dead()
    keypresstimer -= 1
    if (keypresstimer < 0) then
        if btn(0) then initial_wave()
        elseif btn(1) then initial_wave()
        elseif btn(2) then initial_wave()
        elseif btn(3) then initial_wave()
        elseif btn(4) then initial_wave()
        elseif btn(5) then initial_wave()
        end
    end
end


function draw_Player_Dead()
    rectfill(0,0,128,128,0)
    _gametitle = "You have fallen in battle"
    print(_gametitle,hcenter(_gametitle),vcenter(_gametitle),2)

    _pressabutton = "as many of your ancestors"
    print(_pressabutton,hcenter(_pressabutton),vcenter(_pressabutton) + 10, 2)

    _pressabutton = "But another readies vengance"
    print(_pressabutton,hcenter(_pressabutton),vcenter(_pressabutton) + 20, 6)

end





















--DETECT if 2 objects with hitbox are colliding
function collide(obj, other)
        if other.x + other.hitbox.x + other.hitbox.w >obj.x + obj.hitbox.x and
         other.y + other.hitbox.y + other.hitbox.h > obj.y + obj.hitbox.y and
         other.x + other.hitbox.x <  obj.x + obj.hitbox.x + obj.hitbox.w and
         other.y + other.hitbox.y < obj.y + obj.hitbox.y + obj.hitbox.h then
         return true
    end
end

-- ====================================================
-- utility fns

-- make an actor
-- and add to global collection
-- x,y means center of the actor
-- in map tiles (not pixels)
function make_actor(x, y, z, type)
 a={}
 a.x = x
 a.y = y
 a.z = z
 a.class = type
 a.dx = 0
 a.dy = 0
 a.sprite = -1
 a.visible = false

 -- half-width and half-height
 -- slightly less than 0.5 so
 -- that will fit through 1-wide
 -- holes.
 a.w = 0.4
 a.h = 0.4

 if z == 0 then
   add(layer0globalactors, a)
 elseif z== 1 then
   add(layer1globalactors, a)
 else
   add(layer2globalactors, a)
 end

 add(globalactors,a)
 return a
end

function move_globalactors()
  foreach(globalactors, move_all_globalactors)
end

function move_all_globalactors(actor)
  --if actor.class ~= "player" then
    actor.x += actor.dx
    actor.y += actor.dy
  --end
end

function check_offscreen()
  foreach(globalactors, delete_offscreenactor)
end

function delete_offscreenactor(actor)
  if (actor.x > 128) then
    delete_actor(actor)
  end
  if (actor.x < -1) then
    delete_actor(actor)
  end
end



function delete_actor(actor)
  if actor.z == 0 then
    del(layer0globalactors, actor)
  elseif actor.z == 1 then
    del(layer1globalactors, actor)
  else
    del(layer2globalactors, actor)
  end
  del(globalactors, actor)
end


function draw_actor(actor)
    if actor.visible == true then
        if actor.sprite >= 0 then
            spr(actor.sprite, actor.x, actor.y)
        else
            pset(actor.x, actor.y, actor.color)
        end
    end
end


function hcenter(s)
-- string length globaltimes the
-- pixels in a char's width
-- cut in half and rounded down
  return 64-flr((#s*4)/2)
end

-- string char's height
-- cut in half and rounded down
function vcenter(s)
    return 64-flr(5/2)
end

-- for any given point on the
-- map, true if there is wall
-- there.
 -- grab the cell value
 -- check if flag 1 is set (the
 -- orange toggle button in the
 -- sprite editor)

function solid(x, y)
    val=mget(x, y)
    return fget(val, 1)
end

-- solid_area
-- check if a rectangle overlaps
-- with any walls
--(this version only works for globalactors less than one tile big)
function solid_area(x,y,w,h)
 return
  solid(x-w,y-h) or
  solid(x+w,y-h) or
  solid(x-w,y+h) or
  solid(x+w,y+h)
end





__gfx__
000000006000000000aaaaaa00aaaaa0aaaaaa00aaaaaa0000000000000000000000000000000022220000000000000000000000000000000000000000000000
0000000056000000000ff0fa00aaaaa0af0ff000af0ff00000000000000000000000000000002222222200000000000000000000000000000000000000000000
007007005600000000fffff000aaaaa00fffff000fffff0000600000000000000000000000022282282220000000000000000000000000000000000000000000
00077000560000000f33333f0f33333ff33333f0f33333f055c66666000000000000000000022882288220000000000000000000000000000000000000000000
00077000560000000f33333f0f33333ff33333f0f33333f000600000000000000000000000221112211122000000000000000000000000000000000000000000
00700700560000000055555000555550055555000555550000000000000000000000000000228882288822000000000000000000000000000000000000000000
00000000560000000011111000111110011111000111110000000000000000000000000000221112211122000000000000000000000000000000000000000000
00000000600000000010001000100010100010000100010000000000000000000000000000228882288822000000000000000000000000000000000000000000
00000000000000060055555500555550555555005555550000000000000000000222000000222111111222000000222000000000000000000000000000000000
0000000000000065000ff0f5005555505f0ff0005f0ff00000000000000000002222111000222222222222000111222200000000000000000000000000000000
000000000000006500fffff0005555500fffff005fffff0000000600000000002222222200222220022222002222222200000000000000000000000000000000
00077000000000650f33333f0f33333ff33333f0f33333f066666c55000000002221111000222204402222000111122200000000000000000000000000000000
00777700000000650f33333f0f33333ff33333f0f33333f00000060000000000222222220022224aa42222002222222200000000000000000000000000000000
0007700000000065005555500055555005555500055555000000000000000000222111100022224aa42222000111122200000000000000000000000000000000
0000000000000065001111100011111001111100011111000000000000000000222222220002222aa22220002222222200000000000000000000000000000000
00000000000000060010001000100010100010000100010000000000000000000221111000000220022000000111122000000000000000000000000000000000
00000000000000000066666600676660666666006666660000060000000000000202020000000222222000000020202000000000000000000000000000000000
0000000000000000000ff0f6006667607f0ff0007f0ff00000060000000000001212121000022222222220000121212100000000000000000000000000000000
00000000000000000066666000666660066666000666660000060000000000001212121000122222222221000121212100000000000000000000000000000000
00000000000000000f33333f0f33333ff33333f0f33333f000060000000000001212121002122222222221200121212100000000000000000000000000000000
00000000000000000f33333f0f33333ff33333f0f33333f000060000000000001228822202122221122221202228822100000000000000000000000000000000
000000000000000000555550005555500555550005555500006c600000000000228aa8222212221331222122228aa82200000000000000000000000000000000
0000000006666660001111100011111001111100011111000005000000000000222882222212213aa31221222228822200000000000000000000000000000000
000000006555555600100010001000101000100001000100000500000000000002222220221213aaaa3121220222222000000000000000000000000000000000
000000000000000000777777007777707777770077777700000000000000000000002220221113aaaa3111220222000000000000000000000000000000000000
0000000000000000000ff0f7007777707f0ff0007f0ff0000000000000000000011122222212213aa31221222222111000000000000000000000000000000000
00000000000000000077777000777770077777000777770000000000000000002222282222122213312221222282222200000000000000000000000000000000
00000000000000000f33333f0f33333ff33333f0f33333f0000000000000000001118a82021122211222112028a8111000000000000000000000000000000000
00000000000000000f33333f0f33333ff33333f0f33333f0000000000000000022228a82022122222222122028a8222200000000000000000000000000000000
00000000000000000055555000555550055555000555550000000000000000000111282200212222222212002282111000000000000000000000000000000000
00000000000000000011111000111110011111000111110000000000000000002222222200012222222210002222222200000000000000000000000000000000
00000000000000000010001000100010100010000100010000000000000000000111122000000222222000000221111000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0108101010100400000000000000000001001010101004000100000100000000000810101010000001020201000000000000101010100000010202010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000036070320702e07028070220701e070300702e0702d0702d07000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100001b0701b0701b0701a07018070180701607016070140701307012070110700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000313700c3700d3702a37010370233702437017370213701e37027370243702e3702a370093703437003370033700000000000000000000000000000000000000000000000000000000000000000000000
0001000012370113700e3700937005370023700237002370043700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0002000000000173701d370253702d3703c3703f37000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000300000232002320013200132001320013200232002320023200232002320023200232001320023200232002320023000130000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
