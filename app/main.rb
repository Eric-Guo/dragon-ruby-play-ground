# A sample boss battle by @Akzidenz

$gtk.reset

def tick args
  defaults args
  player_inputs args
  calc args
  render args
  game_inputs args
end

######################
# SETUP DEFAULT VALUES
######################

def defaults args
  game_defaults args
  player_defaults args
  enemy_defaults args
end

def game_defaults args
  args.state.game_state ||= :playing # will be :win or :lose later on
end

def player_defaults args
  args.state.player.speed ||= 14
  args.state.player.dir ||= [0, 0]
  args.state.player.animation_frame ||= 0
  args.state.player.w ||= 180
  args.state.player.h ||= 182
  args.state.player.x ||= (args.grid.w - args.state.player.w) / 2
  args.state.player.y ||= (args.grid.h - args.state.player.h) / 2
  args.state.player.path ||= 'sprites/ladybird-0.png'
  args.state.player.angle ||= 0
end

def enemy_defaults args
  args.state.enemy.num_segments ||= 10
  args.state.enemy.x ||= -999 # hidden off-screen at start
  args.state.enemy.y ||= -999
  args.state.enemy.w ||= 121
  args.state.enemy.h ||= 118
  args.state.enemy.angle ||= 0
  args.state.enemy.speed ||= 12
  args.state.enemy.mode ||= :get_started
  args.state.enemy.dir ||= 0
  args.state.enemy.action_timer ||= 0
end

###################
# HANDLE USER INPUT
###################

def player_inputs args
  args.state.player.dir = [args.inputs.left_right, args.inputs.up_down]
end

def game_inputs args
  $gtk.reset seed: Time.now.to_f * 1000 if args.inputs.keyboard.key_down.backspace
end

############################
# CALCULATE STUFF EVERY TICK
############################

def calc args
  # stop calculating if the game is not playing
  return unless args.state.game_state == :playing

  calc_player args
  calc_enemy args
  check_collisions args
end

def calc_player args
  # update player based on movement direction
  case args.state.player.dir
  when [0, 0] # no movement
    args.state.player.animation_frame = 0 # reset legs
  when [0, 1] # up
    args.state.player.angle = 0
  when [1, 1] # right and up
    args.state.player.angle = 315
  when [1, 0] # right
    args.state.player.angle = 270
  when [1, -1] # right and down
    args.state.player.angle = 225
  when [0, -1] # down
    args.state.player.angle = 180
  when [-1, -1] # left and down
    args.state.player.angle = 135
  when [-1, 0] # left
    args.state.player.angle = 90
  when [-1, 1] # left and up
    args.state.player.angle = 45
  end

  # update player location
  args.state.player.x += args.state.player.dir.x * args.state.player.speed
  args.state.player.y += args.state.player.dir.y * args.state.player.speed

  # prevent player moving offscreen
  args.state.player.x = args.state.player.x.clamp(0, 1280 - args.state.player.w)
  args.state.player.y = args.state.player.y.clamp(0, 720 - args.state.player.h)

  # animate player legs
  args.state.player.animation_frame += 0.2 # update every 5 ticks of movement
  # loop back to frame 1 if we are out of frames
  args.state.player.animation_frame = 1 if args.state.player.animation_frame >= 4

  # player sprite changes
  args.state.player.path = "sprites/ladybird-#{args.state.player.animation_frame.to_i}.png"
end

def calc_enemy args
  # determine enemy behaviour
  case args.state.enemy.mode
  when :get_started
    enemy_get_started args
  when :pause_1
    enemy_pause_1 args
  when :move_1
    enemy_move_1 args
  when :pause_2
    enemy_pause_2 args
  when :move_2
    enemy_move_2 args
  end

  # build the enemy segment sprites now
  args.state.enemy.sprites = calc_enemy_sprites args
end

def calc_enemy_sprites args
  # put enemy segment sprites in an array
  enemy_segments = []

  # loop for the current number of enemy segments
  args.state.enemy.num_segments.times do |seg_num|
    # do some calculations for position
    seg_x = args.state.enemy.x
    seg_y = args.state.enemy.y
    seg_y -= (args.state.enemy.h - 8) * seg_num if args.state.enemy.dir == 1
    seg_x -= (args.state.enemy.w - 10) * seg_num if args.state.enemy.dir == 2
    seg_y += (args.state.enemy.h - 8) * seg_num if args.state.enemy.dir == 3
    seg_x += (args.state.enemy.w - 10) * seg_num if args.state.enemy.dir == 4
    seg_color = 'green'
    seg_color = 'orange' if seg_num == args.state.enemy.num_segments - 1

    # add the segment background color sprite to the array
    enemy_segments << {
      x: seg_x,
      y: seg_y,
      w: args.state.enemy.w,
      h: args.state.enemy.h,
      path: "sprites/segment-#{seg_color}.png"
    }

    # add the segment line art sprite to the array
    enemy_segments << {
      x: seg_x,
      y: seg_y,
      w: args.state.enemy.w,
      h: args.state.enemy.h,
      angle: args.state.enemy.angle,
      path: 'sprites/segment.png'
    }
  end

  # return the array
  enemy_segments
end

def check_collisions args
  # create a hit box for the player
  # a little smaller than the sprite rect
  player_hit_rect = [
    args.state.player.x + 40,
    args.state.player.y + 40,
    args.state.player.w - 80,
    args.state.player.h - 80
  ]

  # loop through the enemy segments (skip the last two sprites)
  args.state.enemy.sprites[0..-3].each do |es|
    segment_hit_rect = [
      es.x + 15,
      es.y + 15,
      es.w - 30,
      es.h - 30
    ]

    # did player hit a green segment?
    if segment_hit_rect.intersect_rect? player_hit_rect
      args.state.game_state = :lose
    end
  end
  
  # create hit box for the orange segment
  last_segment = args.state.enemy.sprites[-1]
  last_segment_hit_rect = [
    last_segment.x + 5,
    last_segment.y + 5,
    last_segment.w - 10,
    last_segment.h - 10
  ]

  # did the player hit the orange segment?
  if last_segment_hit_rect.intersect_rect? player_hit_rect
    # knock out the last segment
    args.state.enemy.num_segments -= 1
  end

  # if the enemy is dead (player won!)
  if args.state.enemy.num_segments.zero?
    args.state.game_state = :win
  end
end

########
# RENDER
########

def render args
  render_background args
  render_enemy args
  render_player args
  render_instructions args
  render_jumbotron args
end

def render_background args
  args.outputs.sprites << {
    x: 0,
    y: 0,
    w: 1280,
    h: 720,
    path: 'sprites/green-background.png',
    a: 140
  }
end

def render_enemy args
  args.outputs.sprites << args.state.enemy.sprites
end

def render_player args
  args.outputs.sprites << {
    x: args.state.player.x,
    y: args.state.player.y,
    w: args.state.player.w,
    h: args.state.player.h,
    angle: 0,
    path: 'sprites/ladybird-background.png'
  }

  args.outputs.sprites << {
    x: args.state.player.x,
    y: args.state.player.y,
    w: args.state.player.w,
    h: args.state.player.h,
    angle: args.state.player.angle,
    path: args.state.player.path
  }
end

# show instructions at the top of the screen
def render_instructions args
  texts = ["Use arrow keys or WASD to move. Backspace to restart.",
  "If you touch the CATERKILLAR, you will die. But what is up with the orange bit?"]

  args.outputs.labels << texts.map.with_index do |txt, i|
    {
      x: 10,
      y: 710 - i * 22,
      text: txt,
      r: 60,
      g: 120,
      b: 60
    }
  end
end

# show this when the game is lost or won
def render_jumbotron args
  # back out if the game is still playing
  return if args.state.game_state == :playing

  # throw a transparent shape over the scene
  args.outputs.sprites << {
    x: 0,
    y: 0,
    w: 1280,
    h: 720,
    a: 100,
    r: 255,
    g: 0,
    b: 0
  }.solid!

  # display win/lose text
  case args.state.game_state
  when :lose
    jumbo_text = "Killed by the CATERKILLAR! :("
  when :win
    jumbo_text = "You beat the CATERKILLAR! :)"
  end

  args.outputs.labels << {
    x: 640,
    y: 360,
    text: jumbo_text,
    alignment_enum: 1,
    vertical_alignment_enum: 1,
    size_enum: 20,
    r: 255,
    g: 255,
    b: 255
  }
end

##################
# ENEMY MOVEMEMENT
##################
# The following methods tell the enemy how to behave during
# each of the modes it goes through

# The game just started
# Setup the enemy and then pause
def enemy_get_started args
  # choose an initial direction, set the sprite angle and
  # set the initial location offscreen
  args.state.enemy.dir = 1 + rand(4) # 1: up, 2: right, 3: down, 4: left
  case args.state.enemy.dir
  when 1 # up
    args.state.enemy.x = rand(1280 - args.state.enemy.w)
    args.state.enemy.y = -args.state.enemy.h
    args.state.enemy.angle = 0
  when 2 # right
    args.state.enemy.x = -args.state.enemy.w
    args.state.enemy.y = rand(720 - args.state.enemy.h)
    args.state.enemy.angle = 270
  when 3 # down
    args.state.enemy.x = rand(1280 - args.state.enemy.w)
    args.state.enemy.y = 720
    args.state.enemy.angle = 180
  when 4 # left
    args.state.enemy.x = 1280
    args.state.enemy.y = rand(720 - args.state.enemy.h)
    args.state.enemy.angle = 90
  end

  # set the timer to the duration of the next pause
  args.state.enemy.action_timer = 60 # 1 second
  # set the next mode
  args.state.enemy.mode = :pause_1
end

# enemy waits before first appearing
def enemy_pause_1 args
  args.state.enemy.action_timer -= 1
  if args.state.enemy.action_timer.zero?
    args.state.enemy.mode = :move_1
  end 
end

# enemy rolls forwards enough to put head on screen
# and then pauses
def enemy_move_1 args
  case args.state.enemy.dir
  when 1
    args.state.enemy.y += args.state.enemy.speed
    move_complete = true if args.state.enemy.y > 0
  when 2
    args.state.enemy.x += args.state.enemy.speed
    move_complete = true if args.state.enemy.x > 0
  when 3
    args.state.enemy.y -= args.state.enemy.speed
    move_complete = true if args.state.enemy.y < 720 - args.state.enemy.h
  when 4
    args.state.enemy.x -= args.state.enemy.speed
    move_complete = true if args.state.enemy.x < 1280 - args.state.enemy.w
  end

  # stop moving if the head is fully on the screen
  if move_complete
    args.state.enemy.action_timer = 60
    args.state.enemy.mode = :pause_2
  end
end

# wait after enemy head appears on screen
def enemy_pause_2 args
  args.state.enemy.action_timer -= 1
  if args.state.enemy.action_timer.zero?
    args.state.enemy.mode = :move_2
  end
end

# move on
def enemy_move_2 args
  case args.state.enemy.dir
  when 1
    args.state.enemy.y += args.state.enemy.speed
  when 2
    args.state.enemy.x += args.state.enemy.speed
  when 3
    args.state.enemy.y -= args.state.enemy.speed
  when 4
    args.state.enemy.x -= args.state.enemy.speed
  end

  # enemy movement is finished when it goes completely off-screen
  unless args.grid.rect.intersect_rect? combine_rects args.state.enemy.sprites
    # restart enemy behaviour
    args.state.enemy.mode = :get_started
  end
end

#########
# HELPERS
#########

def combine_rects array_of_rects
  # re-orient the data from an array of rects to a rect of arrays
  lefts = []
  rights = []
  tops = []
  bottoms = []
  array_of_rects.each do |rect|
    lefts << rect.x
    rights << rect.x + rect.w
    tops << rect.y + rect.h
    bottoms << rect.y
  end

  [lefts.min, bottoms.min, rights.max - lefts.min, tops.max - bottoms.min]
end
