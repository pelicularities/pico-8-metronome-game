pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- game states:
-- game over / start new game
-- game running, beats shown
-- game running, beats in range
-- game ended, player hit 100 -> win! show bpm
-- game ended, player hit other number -> lost, start new game
-- game running, beats out of range -> lost, start new game

function reset_game()
  player_state = 'unknown'
  fps = 30
  bpm = flr(180 + rnd(60)) -- random bpm between 65 and 85
  divisor = 60 * fps / bpm
  counter = flr((75 + rnd(7)) * divisor) -- random start value between 82 and 87
  beats = flr(counter / divisor)
  show_beats = false
end

function _init()
  -- possible states: "intro", "running", "over"
  -- game state: hasn't started
  -- instructions on screen
  -- press o or x to start game

  -- game state: running
  -- beep every time the beat goes up
  -- press o or x to stop the clock

  -- game state: result screen
  -- press o or x to try again
  game_state = 'intro'

  -- possible states: "unknown", "won", "lost"
  player_state = 'unknown'

  WHITE = 7
  RED = 8
  ORANGE = 9
  YELLOW = 10
  GREEN = 11

  reset_game()
end


function _update()
  if game_state == 'intro' then
    if btnp(🅾️) or btnp(❎) then
      game_state = 'running'
    end
  elseif game_state == 'running' then
    counter += 1
    old_beats = beats
    beats = flr(counter / divisor)

    if beats < 93 or beats > 107 then
      show_beats = true
    else
      show_beats = false
    end

    if show_beats 
    and beats < 100
    and beats % 4 == 0
    and old_beats != beats 
    then
      -- the count has gone up by 4, play a sound
      sfx(0)
    end

    if btnp(🅾️) or btnp(❎) or beats > 107 then
      game_state = 'over'
      if beats == 100 then
        player_state = 'won'
        sfx(1)
      else
        player_state = 'lost'
        sfx(2)
      end
    end
  elseif game_state == 'over' then
    show_beats = true
    if btnp(🅾️) or btnp(❎) then
      reset_game()
      game_state = 'running'
    end
  end
end

function print_number_centered(number, color)
  if number < 100 then
    print_position_x = 56
  else
    print_position_x = 52
  end
  print("\^t\^w" .. number, print_position_x, 61, color)
end

function _draw()
  cls()
  if game_state == 'intro' then
    -- print instructions
    color(WHITE)
    print("the counter will count up", 14, 10)
    print("and beep every 4 counts", 18, 20)
    print("press 🅾️ or ❎\n", 36, 50)
    print("when you think the counter", 12, 60)
    print("has reached 100", 34, 70)
    print("press 🅾️ or ❎ to start", 18, 110)
  elseif game_state == 'running' then
    if show_beats then
      if beats % 4 == 0 then
        color = ORANGE
      else
        color = YELLOW
      end
      print_number_centered(beats, color)
    end
  elseif game_state == 'over' then
    -- print lost or won
    if player_state == 'won' then
      print_number_centered(beats, GREEN)
      print("you won", 50, 90)
    else
      print_number_centered(beats, RED)
      print("you lost", 48, 90)
    end
    print("press 🅾️ or ❎ to play again", 8, 100)
  end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
003201012d7502c0002c0002c0002c0002c0002c0002c0002c0002c0002c0002c0002c0002c0002b0002b0002b0002b0002b0002b0002b0002b0002b0002b0002b0002b0002b0002c0002c0002c0002c0002c000
001000001d05021050240501f05023050260502105025050280502d0502d0502d0502d0502d0502d0502d0502d050340003400035000350000000000000000000000000000000000000000000000000000000000
0010000032150271501f1501b15017150131500f1500b1500615005150051500515005150051500515005150051500d4000d40000000000000000000000000000000000000000000000000000000000000000000
