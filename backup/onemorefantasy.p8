pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
globaltime = 0
globalgamemode = 0
globalgamewave = 1
globaleventtimer = -1
globalbattlewonflag = false

globalactors = {} --all globalactors in world
globaleffects = {}
globalinterval = 2

layer0globalactors = {}
layer1globalactors = {}
layer2globalactors = {}

globalherostartx = 10
globalenemystartx = 114
globalheroattackx = 56
globalenemyattackx = 67

heroleft = {}
heroup = {}
heroright = {}
herodown = {}

enemyone = {}
enemytwo = {}
enemythree = {}
enemyfour = {}


-- ====================================================
-- pico-8 required methods
function _init()

end


function _update()

  if globalgamemode == 0 then update_game_title()
  elseif globalgamemode == 1 then update_game_main()
  elseif globalgamemode == 2 then update_battle_won()
  end
end

function _draw()

  if globalgamemode == 0 then draw_game_title()
  elseif globalgamemode == 1 then draw_game_main()
  elseif globalgamemode == 2 then draw_battle_won()
  end

end


-- ====================================================
-- gamestate - 0 - title
function update_game_title()
  if btn(0) then start_game(false)
  elseif btn(1) then start_game(false)
  elseif btn(2) then start_game(false)
  elseif btn(3) then start_game(false)
  elseif btn(4) then start_game(false)
  elseif btn(5) then start_game(false)
  end
end

function draw_game_title()
  _gametitle = "one more fantasy"
  rectfill(0,0,128,128,0)
  print(_gametitle,hcenter(_gametitle),vcenter(_gametitle),2)
  print(_gametitle,hcenter(_gametitle)+.5,vcenter(_gametitle)+.5,3)
  _pressabutton = "press a button"
  print(_pressabutton,hcenter(_pressabutton),vcenter(_pressabutton) + 10, 8)
end

function start_game()
    globalgamemode = 1
    globalgamewave = 1
    generate_next_wave()
end

-- ====================================================

function generate_next_wave(deleteactors)
    globaltime = 0
    globalbattlewonflag = false

    if (deleteactors == true) then
        delete_all_hero_actors()
        delete_all_enemy_actors()
    end

    create_all_heroes()

    if (globalgamewave == 1) then
        enemyone = create_enemy(60, "warrior", true, globalinterval)
        enemytwo = create_enemy(70, "nothing", false, globalinterval)
        enemythree = create_enemy(80, "nothing", false, globalinterval)
        enemyfour = create_enemy(90, "nothing", false, globalinterval)

    elseif (globalgamewave == 2) then
        enemyone = create_enemy(60, "warrior", true, globalinterval)
        enemytwo = create_enemy(70, "ranger", true, globalinterval)
        enemythree = create_enemy(80, "nothing", false,globalinterval)
        enemyfour = create_enemy(90, "nothing", false, globalinterval)

    elseif (globalgamewave == 3) then
        enemyone = create_enemy(60, "warrior", true, globalinterval)
        enemytwo = create_enemy(70, "ranger", true, globalinterval)
        enemythree = create_enemy(80, "cleric", true, globalinterval)
        enemyfour = create_enemy(90, "nothing", false, globalinterval)

    elseif (globalgamewave == 4) then
        enemyone = create_enemy(60, "ranger", true, globalinterval)
        enemytwo = create_enemy(70, "ranger", true, globalinterval)
        enemythree = create_enemy(80, "ranger", true, globalinterval)
        enemyfour = create_enemy(90, "ranger", true, globalinterval)

    elseif (globalgamewave == 5) then
        enemyone = create_enemy(60, "warrior", true, globalinterval)
        enemytwo = create_enemy(70, "cleric", true, globalinterval)
        enemythree = create_enemy(80, "cleric", true, globalinterval)
        enemyfour = create_enemy(90, "warrior", true, globalinterval)

    elseif (globalgamewave == 6) then
        enemyone = create_enemy(60, "warrior", true, globalinterval)
        enemytwo = create_enemy(70, "cleric", true, globalinterval)
        enemythree = create_enemy(80, "wizard", true, globalinterval)
        enemyfour = create_enemy(90, "warrior", true, globalinterval)

    elseif (globalgamewave == 7) then
        enemyone = create_enemy(60, "warrior", true, globalinterval)
        enemytwo = create_enemy(70, "ranger", true, globalinterval)
        enemythree = create_enemy(80, "cleric", true, globalinterval)
        enemyfour = create_enemy(90, "warrior", true, globalinterval)

    elseif (globalgamewave == 8) then
        enemyone = create_enemy(60, "warrior", true, globalinterval)
        enemytwo = create_enemy(70, "ranger", true, globalinterval)
        enemythree = create_enemy(80, "ranger", true, globalinterval)
        enemyfour = create_enemy(90, "warrior", true, globalinterval)

        globalinterval -= .5
        globalgamewave = 0 -- reset
    end
end




function create_all_heroes()
    heroleft = make_actor(globalherostartx,60,1,"cleric")
    heroleft.actionbtn = 0;
    set_hero_sprites(heroleft)
    set_class_values(heroleft)
    heroleft.visible = true
    heroleft.controlbtnactor = make_actor(0,60,1,"control")
    heroleft.controlbtnactor.sprite = 64
    heroleft.controlbtnactor.visible = true

    heroup = make_actor(globalherostartx,70,1,"ranger")
    heroup.actionbtn = 2;
    set_hero_sprites(heroup)
    set_class_values(heroup)
    heroup.visible = true
    heroup.controlbtnactor = make_actor(0,70,1,"control")
    heroup.controlbtnactor.sprite = 80
    heroup.controlbtnactor.visible = true


    heroright = make_actor(globalherostartx,80,1,"warrior")
    heroright.actionbtn = 1;
    set_hero_sprites(heroright)
    set_class_values(heroright)
    heroright.visible = true
    heroright.controlbtnactor = make_actor(0,80,1,"control")
    heroright.controlbtnactor.sprite = 96
    heroright.controlbtnactor.visible = true

    herodown = make_actor(globalherostartx,90,1,"wizard")
    herodown.actionbtn = 3;
    set_hero_sprites(herodown)
    set_class_values(herodown)
    herodown.visible = true
    herodown.controlbtnactor = make_actor(0,90,1,"control")
    herodown.controlbtnactor.sprite = 112
    herodown.controlbtnactor.visible = true
end

function create_enemy(ycoord, type, visibility, baseinterval)
    _newenemy = {}

    _newenemy = make_actor(globalenemystartx, ycoord, 1, type)
    set_enemy_sprites(_newenemy)
    set_class_values(_newenemy)
    _newenemy.visible = visibility
    _newenemy.interval = flr(rnd(x))
    flipenemymovement(_newenemy)
    _newenemy.state = "ready"
    return _newenemy
end

function set_class_values(actor)

    if actor.class == "cleric" then
        actor.ability = "heal"
        actor.healvalue = 1
        actor.attackspeed = 3
        actor.recoverspeed = -1
        actor.maxhealth = 4

    elseif actor.class == "ranger" then
        actor.ability = "ranged"
        actor.damage = 1
        actor.attackspeed = 5
        actor.recoverspeed = -2
        actor.maxhealth = 3

    elseif actor.class == "warrior" then
        actor.ability = "melee"
        actor.damage = 1
        actor.attackspeed = 4
        actor.recoverspeed = -1
        actor.maxhealth = 5

    elseif actor.class == "wizard" then
        actor.ability = "storm"
        actor.damage = 1
        actor.attackspeed = 1
        actor.recoverspeed = -1
        actor.maxhealth = 2

    elseif actor.class == "nothing" then
        actor.ability = "nothing"
        actor.attackspeed = 0
        actor.recoverspeed = 0
        actor.maxhealth = 0
    end

    actor.currenthealth = actor.maxhealth
    actor.state = "ready"
    actor.statechangeglobaltimer = -1;

    return actor;
end

function set_hero_sprites(actor)
    actor.type = "hero"

    if actor.class == "cleric" then
        actor.idlesprite = 1
        actor.movesprite = 2
        actor.attacksprite = 3
        actor.deadsprite = 0

    elseif actor.class == "ranger" then
        actor.idlesprite = 17
        actor.movesprite = 18
        actor.attacksprite = 19
        actor.deadsprite = 16

    elseif actor.class == "warrior" then
        actor.idlesprite = 33
        actor.movesprite = 34
        actor.attacksprite = 35
        actor.deadsprite = 32

    elseif actor.class == "wizard" then
        actor.idlesprite = 49
        actor.movesprite = 50
        actor.attacksprite = 51
        actor.deadsprite = 48
    end

    actor.sprite = actor.idlesprite

    return actor;
end

function set_enemy_sprites(actor)
    actor.type = "enemy"

    if actor.class == "cleric" then
        actor.idlesprite = 4
        actor.movesprite = 5
        actor.attacksprite = 6

    elseif actor.class == "ranger" then
        actor.idlesprite = 20
        actor.movesprite = 21
        actor.attacksprite = 22
        actor.deadsprite = 7

    elseif actor.class == "warrior" then
        actor.idlesprite = 36
        actor.movesprite = 37
        actor.attacksprite = 38

    elseif actor.class == "wizard" then
        actor.idlesprite = 52
        actor.movesprite = 53
        actor.attacksprite = 54
    end

    actor.deadsprite = 7
    actor.sprite = actor.idlesprite

    return actor;
end

function flipenemymovement(actor)
    actor.attackspeed = actor.attackspeed * -1
    actor.recoverspeed = actor.recoverspeed * -1
end

-- ====================================================

function update_game_main()
  globaltime += 1

  control_characters()
  move_globalactors()

  --check_for_heroes_dead()
  check_for_all_enemies_dead()
end

function control_characters()

    check_hero_state(heroleft)
    perform_movements(heroleft)
    check_hero_state(heroup)
    perform_movements(heroup)
    check_hero_state(herodown)
    perform_movements(herodown)
    check_hero_state(heroright)
    perform_movements(heroright)

    check_enemy_state(enemyone)
    perform_movements(enemyone)
    check_enemy_state(enemytwo)
    perform_movements(enemytwo)
    check_enemy_state(enemythree)
    perform_movements(enemythree)
    check_enemy_state(enemyfour)
    perform_movements(enemyfour)
end

function check_hero_state(actor)
    check_if_actor_is_dead(actor)
    if btn(actor.actionbtn) and actor.state == "ready" and actor.visible == true and actor.currenthealth > 0 then
          actor.controlbtnactor.visible = false
          actor.state = "charging"
          actor.dx = actor.attackspeed
    end
end

function check_enemy_state(actor)

    check_if_actor_is_dead(actor)

    if ((globaltime / 30) % actor.interval) == 0 and actor.state == "ready" and actor.visible == true and actor.currenthealth > 0 then
        actor.state = "charging"
        actor.dx = actor.attackspeed
    end
end

function check_if_actor_is_dead(actor)
    if (actor.currenthealth <= 0) then
        actor.state = "dead"
        actor.sprite = actor.deadsprite
        actor.dx = 0
    end
end

function perform_movements(actor)

    if (actor.state == "running") then
        if (actor.sprite == actor.idlesprite) then
            actor.sprite = actor.movesprite
        else
            actor.sprite = actor.idlesprite
        end
    end

    if (actor.state == "charging") then
          if (actor.sprite == actor.idlesprite) then
              actor.sprite = actor.movesprite
          else
              actor.sprite = actor.idlesprite
          end

          if ((actor.type == "hero" and actor.x >= globalheroattackx) or (actor.type == "enemy" and actor.x <= globalenemyattackx)) then
              actor.state = "attacking"
              actor.dx = 0
              if (actor.type == "hero") then
                actor.x = globalheroattackx
              elseif (actor.type == "enemy") then
                actor.x = globalenemyattackx
              end
              actor.statechangeglobaltimer = 15; -- 15 frames
              trigger_attack(actor)
        end
    end

      if (actor.state == "attacking") then

          if (actor.sprite == actor.idlesprite) then
              actor.sprite = actor.attacksprite
          else
              actor.sprite = actor.idlesprite
          end

          actor.statechangeglobaltimer -= 1
          if actor.statechangeglobaltimer <= 0 then
              actor.state = "resetting"
              actor.dx = actor.recoverspeed
          end
       end

      if (actor.state == "resetting") then
          if (actor.sprite == actor.idlesprite) then
              actor.sprite = actor.movesprite
          else
              actor.sprite = actor.idlesprite
          end

          if ((actor.type == "hero" and actor.x <= globalherostartx) or (actor.type == "enemy" and actor.x >= globalenemystartx)) then
              actor.dx = 0
              actor.sprite = actor.idlesprite
              actor.state = "ready"

            if (actor.type == "hero") then
                actor.controlbtnactor.visible = true
                actor.x = globalherostartx
            elseif (actor.type == "enemy") then
                actor.x = globalenemystartx
              end
          end
      end
end

function trigger_attack(actor)

    if (actor.type == "hero") then
        if (actor.ability == "heal") then
            sfx(0, -1)
            livingtargets = find_living_targets(heroleft, heroup, heroright, herodown)
            target = heal_all(livingtargets)

        elseif (actor.ability == "ranged") then
            sfx(1, -1)
            livingtargets = find_living_targets(enemyone, enemytwo, enemythree, enemyfour)
            target = find_farthest_target(livingtargets)
            target.currenthealth -= 1

        elseif (actor.ability == "melee") then
            sfx(2, -1)
            livingtargets = find_living_targets(enemyone, enemytwo, enemythree, enemyfour)
            target = find_closest_target(livingtargets)
            target.currenthealth -= 1

        elseif (actor.ability == "storm") then
            sfx(3, -1)
            enemyone.currenthealth -= 1
            enemytwo.currenthealth -= 1
            enemythree.currenthealth -= 1
            enemyfour.currenthealth -= 1
        end

    elseif (actor.type == "enemy") then
        if (actor.ability == "heal") then
            sfx(0, -1)
            livingtargets = find_living_targets(enemyone, enemytwo, enemythree, enemyfour)
            target = heal_all(livingtargets)

        elseif (actor.ability == "ranged") then
            sfx(1, -1)
            livingtargets = find_living_targets(heroleft, heroup, heroright, herodown)
            target = find_farthest_target(livingtargets)
            target.currenthealth -= 1

        elseif (actor.ability == "melee") then
            sfx(2, -1)
            livingtargets = find_living_targets(heroleft, heroup, heroright, herodown)
            target = find_closest_target(livingtargets)
            target.currenthealth -= 1

        elseif (actor.ability == "storm") then
            sfx(3, -1)
            heroleft.currenthealth -= 1
            heroup.currenthealth -= 1
            heroright.currenthealth -= 1
            herodown.currenthealth -= 1
        end
    end
end


function find_living_targets(target1, target2, target3, target4)

    _livingtargets = {}

    if (target1.currenthealth > 0) then
        add(_livingtargets,target1)
    end
    if (target2.currenthealth > 0) then
        add(_livingtargets,target2)
    end
    if (target3.currenthealth > 0) then
        add(_livingtargets,target3)
    end
    if (target4.currenthealth > 0) then
        add(_livingtargets,target4)
    end

    return _livingtargets
end

function find_closest_target(targets)
    target = {}
    distance = 128

    for p in all(targets) do
        if (find_closest(p, distance)) then
            target = p
            distance = abs(target.x - 64)
        end
    end
    return target
end

function find_closest(target, distance)

    if (abs(target.x - 64) < distance) then
        return true
    end
    return false
end

function find_farthest_target(targets)
    target = {}
    distance = 130

    for p in all(targets) do
        if (find_closest(p, distance)) then
            target = p
            distance = abs(target.x - 64)
        end
    end
    return target
end

function find_farthest(target, distance)
    if (abs(target.x - 64) > distance) then
        return true
    end
    return false
end

function heal_all(targets)
    for p in all(targets) do
        p.currenthealth += 1
        if (p.currenthealth > p.maxhealth) then
            p.currenthealth = p.maxhealth
        end
    end
end

function check_for_heroes_dead()
    --if (heroleft.currenthealth <= 0) and (heroup.currenthealth <= 0) and (heroright.currenthealth <= 0) and (herodown.currenthealth <= 0) then
        --globalgamewave = 1
        --delete_all_hero_actors()
        --delete_all_enemy_actors()
        --globalgamemode = 4
    --end
end

function check_for_all_enemies_dead()
    if (enemyone.currenthealth <= 0) and (enemytwo.currenthealth <= 0) and (enemythree.currenthealth <= 0) and (enemyfour.currenthealth <= 0) then
        globaleventtimer = 300
        globalgamemode = 2
    end
end

-- +++++++++++++++++++++++++++++++++++++++




-- +++++++++++++++++++++++++++++++++++++++
function draw_game_main()
  rectfill(0,0,128,128,0)

  draw_game_health()

  foreach(layer0globalactors,draw_actor)
  foreach(layer1globalactors,draw_actor)
  foreach(layer2globalactors,draw_actor)

  draw_game_debug()
end

function draw_guidelines()
	--[[
	-- positioning guidelines
	rectfill(65,0,65,128,2)

	rectfill(10,0,10,128,10)
	rectfill(20,0,20,128,10)
	rectfill(30,0,30,128,10)
	rectfill(40,0,40,128,10)
	rectfill(50,0,50,128,10)
	rectfill(60,0,60,128,10)
	rectfill(70,0,70,128,10)
	rectfill(80,0,80,128,10)
	rectfill(90,0,90,128,10)
	rectfill(100,0,100,128,10)
	rectfill(110,0,110,128,10)
	rectfill(120,0,120,128,10)
	]]--
end

function draw_game_health()

    if (heroleft.currenthealth > 0) then
       rectfill(globalherostartx - 1, heroleft.y - 1, globalherostartx + (heroleft.currenthealth * 10), heroleft.y + 8,8)
    end

    if (heroup.currenthealth > 0) then
	rectfill(globalherostartx - 1, heroup.y - 1, globalherostartx + (heroup.currenthealth * 10), heroup.y + 8,8)
    end

    if (heroright.currenthealth > 0) then
    rectfill(globalherostartx - 1, heroright.y - 1, globalherostartx + (heroright.currenthealth * 10), heroright.y + 8,8)
    end

    if (herodown.currenthealth > 0) then
        rectfill(globalherostartx - 1, herodown.y - 1, globalherostartx + (herodown.currenthealth * 10), herodown.y + 8,8)
    end

    if (enemyone.currenthealth > 0) then
        rectfill(globalenemystartx + 8, enemyone.y - 1, globalenemystartx  + (enemyone.currenthealth * -10) + 6, enemyone.y + 8,8)
    end

    if (enemytwo.currenthealth > 0) then
        rectfill(globalenemystartx + 8, enemytwo.y - 1, globalenemystartx  + (enemytwo.currenthealth * -10) + 6, enemytwo.y + 8,8)
    end

    if (enemythree.currenthealth > 0) then
        rectfill(globalenemystartx + 8, enemythree.y - 1, globalenemystartx  + (enemythree.currenthealth * -10) + 6, enemythree.y + 8,8)
    end

    if (enemyfour.currenthealth > 0) then
        rectfill(globalenemystartx + 8, enemyfour.y - 1, globalenemystartx + (enemyfour.currenthealth * -10) + 6, enemyfour.y + 8,8)
    end
end

function draw_game_debug()
    -- debug prints for actor counts & position



    print("a "..globalgamewave,0,120,7)
    --print("a "..heroleft.state,0,120,7)
     --print("a "..enemyone.state,0,120,7)
    --print("a "..enemyone.attackspeed,0,120,7)

    --print("a "..heroleft.x,64,120,7)
    --print("a "..enemyone.x,64,120,7)
    --print("a "..globaleventtimer,64,120,7)

    --print("t "..flr(globaltime / 30),0,120,7)
    print("s "..globalinterval,64,120,7)
    --print("a "..count(globalactors),0,120,7)
end











-- ====================================================
-- end game
function update_heroes_win()
    if btn(0) then globalgamemode = 1
    elseif btn(1) then globalgamemode = 1
    elseif btn(2) then globalgamemode = 1
    elseif btn(3) then globalgamemode = 1
    elseif btn(4) then globalgamemode = 1
    elseif btn(5) then globalgamemode = 1
    end
end

function draw_heroes_win()
    _gametitle = "woohoo!"
    rectfill(0,0,128,128,0)
    print(_gametitle, hcenter(_gametitle), vcenter(_gametitle),7)
    print(_gametitle, hcenter(_gametitle)+.5, vcenter(_gametitle)+.5, 6)
    _pressabutton = "press a button"
    print(_pressabutton, hcenter(_pressabutton), vcenter(_pressabutton) + 10, 6)
end


-- +++++++++++++++++++++++++++++++++++++++

function update_battle_won()

    if (globalbattlewonflag == false) then
        globalbattlewonflag = true
        globaleventtimer = 30
        make_hero_run(heroleft)
        make_hero_run(heroup)
        make_hero_run(heroright)
        make_hero_run(herodown)
    end

    globaleventtimer -= 1
    if (globaleventtimer < 0) then
        globalgamemode = 1
        globalgamewave += 1
        generate_next_wave(true)
    end

    toggle_hero_run_sprite(heroleft)
    toggle_hero_run_sprite(heroup)
    toggle_hero_run_sprite(heroright)
    toggle_hero_run_sprite(herodown)
    move_globalactors()
end

function make_hero_run(actor)
    if actor.visible == true and actor.currenthealth > 0 then
          actor.controlbtnactor.visible = false
          actor.dx = 5
    end
end

function toggle_hero_run_sprite(actor)
    if (actor.sprite == actor.idlesprite) then
        actor.sprite = actor.movesprite
    else
        actor.sprite = actor.idlesprite
    end
end

function draw_battle_won()
    rectfill(0,0,128,128,0)

    foreach(layer0globalactors,draw_actor)
    foreach(layer1globalactors,draw_actor)
    foreach(layer2globalactors,draw_actor)
    draw_game_debug()
end








function update_heroes_dead()
    if btn(0) then globalgamemode = 0
    elseif btn(1) then globalgamemode = 0
    elseif btn(2) then globalgamemode = 0
    elseif btn(3) then globalgamemode = 0
    elseif btn(4) then globalgamemode = 0
    elseif btn(5) then globalgamemode = 0
    end
end

function draw_heroes_dead()
    _gametitle = "your adventurers died..."
    rectfill(0,0,128,128,0)
    print(_gametitle, hcenter(_gametitle), vcenter(_gametitle),7)
    print(_gametitle, hcenter(_gametitle)+.5, vcenter(_gametitle)+.5, 6)
    _pressabutton = "press a button"
    print(_pressabutton, hcenter(_pressabutton), vcenter(_pressabutton) + 10, 6)
end



function delete_all_hero_actors()
    delete_actor(heroleft.controlbtnactor)
    delete_actor(heroup.controlbtnactor)
    delete_actor(heroright.controlbtnactor)
    delete_actor(herodown.controlbtnactor)

    delete_actor(heroleft)
    delete_actor(heroup)
    delete_actor(heroright)
    delete_actor(herodown)
end

function delete_all_enemy_actors()
    delete_actor(enemyone)
    delete_actor(enemytwo)
    delete_actor(enemythree)
    delete_actor(enemyfour)
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
000000009999900099999000999990a000000000000000000a000000000000000000505500000000000000000000000000000000000000000000000000000000
000000009f0f00b09f0f00b09f0f000a0b0777700b077770a007777000000000000444400b0000000b0000000000000000000000000000000000000000000000
000000009ffff0309ffff0309ffff0a003007070030070700a00707000000000000040450300000003000000000a000000000000000000000000000000000000
000000000ffff0300ffff0300ffff03003077770030777700307777000000000000444400300000003000000000aaa0000000000000000000000000000000000
00000000f1212f30f1212f30f1212f300376666703766667037666670007777000443434030000000300000000aaa00000000000000000000000000000000000
99f11110f1222f00f1222f00f1222f00007766760077667600776676000070700043444400000000000000000000a00000000000000000000000000000000000
99f11111011110000111100001111000000677600006776000067760000777700004434000000000000000000000000000000000000000000000000000000000
99f11111010010001001000001001000000700700000700700070070006676670003004000000000000000000000000000000000000000000000000000000000
00000000444440004444400044444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000004f0f00034f0f00034f0f00033007777030077770300777700000000000000505300000000b0000000000000000000000000000000000000000000000
000000004ffff0334ffff0334ffff333330070703300707033307070000000000000444033300000030000000000060000000000000000000000000000000000
000000000ffff3030ffff3030fff3003303777703037777030037770000000000000040530030000030000000333366000000000000000000000000000000000
00000000f9ddd3f3f9ddd3f3f9dd30f3373666673736666737036667000000000000444030030000030000000000060000000000000000000000000000000000
4ff99990f99d9033f99d9033f99d9333330766763307667633376676000000000004434433300000000000000000000000000000000000000000000000000000
44499999099990030999900309999003300677603006776030067760000000000000443030000000000000000000000000000000000000000000000000000000
4ff99999090090009009000009009000000700700000700700070070000000000000304000000000000000000000000000000000000000000000000000000000
00000000666660006666600066666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000640400606404006064040000060777700607777000077770000000000007777000000000060000000000000000000000000000000000000000000000
0000000064444060644440606444400006007070060070700000707000000000000c7c7000000000060000000000000000000000000000000000000000000000
00000000044440600444406004444006060777700607777060077770000000000007777060000000060000000000000000000000000000000000000000000000
00000000466264304662643046626460047666670476666706766667000000000077777006000000040000000000000000000000000000000000000000000000
64466660462664004626640046266400007766760077667600776676000000000076767700000000000000000000000000000000000000000000000000000000
66466666066660000666600006666000000677600006776000067760000000000066767700000000000000000000000000000000000000000000000000000000
64466666060060006006000006006000000700700000700700070070000000000006767600000000000000000000000000000000000000000000000000000000
00000000eeeee000eeeee000eeeee0c000000000000000000c00000000000000000000000c0000000000000000000000000c0000000000000000000000000000
00000000ef0f00e0ef0f00e0ef0f0ccc0e0777700e077770ccc777700000000000077770ccc000000e00000000000000000c0000000000000000000000000000
00000000effff000effff000effff0c000007070000070700c00707000000000000c7c700c000000000000000c00000000070000000000000000000000000000
000000000ffff0f00ffff0f00ffff0f00707777007077770070777700000000000076770000000000000000000c0c000000c0000000000000000000000000000
00000000f1a1af00f1a1af00f1a1af0000766667007666670076666700000000000767700000000000000000000c0c0000070000000000000000000000000000
ccc11110f11a1000f11a1000f11a100000776676007766760077667600000000007676770000000000000000000000c0000c0000000000000000000000000000
ccf11111011110000111100001111000000677600006776000067760000000000066767600000000000000000000000000070000000000000000000000000000
ccc11111010010001001000001001000000700700000700700070070000000000006767000000000000000000000000000070000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00aaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00aaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aaaaa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00aaa000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0002000035070310702e0702907025070210701a070220702b070310703f070180701c07021070230702b070330703a0703f0701a0701f070240702807030070380703f0701a0701e070240702e070380703f070
000100002f5702d5702b570295702757026570245702357022570205701e5701d5701c5701a570195701857017570165701557014570145701657012570145701157011570105700f5700d5700c5700b57008570
000100003c3703c3703b3703537030370293702137018370103700e3700b370073700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200000407006070060700a0701307014070160701d07001070010700107002070040700707009070100701907027070080700307004070080700b0700f07018070290700107002060040700b0701904033030
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

