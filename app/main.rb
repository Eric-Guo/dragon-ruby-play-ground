# frozen_string_literal: true

$gtk.reset
# This is the end of our intro tutorial.
# Here we will provide you with the resourses
# to get started with the Dragonruby gametoolkit

# Here is the link to the gtk:
# https://dragonruby.itch.io/dragonruby-gtk
# Check if you qualify for a free licence and contact Amir at ar@amirrajan.net

# You can edit your code via a text document if you want,
# but it's just as easy to download and editor
# (IDE: (Intergrated Development Environment))
# A couple that are pretty good are:

# Visual studio, a free IDE with a built in terminal
# https://code.visualstudio.com

# Ruby Mine, a paid IDE that offeres itself free to:
# students, teachers, classrooms, and open source projects.
# It also has a free trial.
# https://www.jetbrains.com/ruby

# Once you have The dragonruby gtk downloaded and unzipped
# You will need to open the terminal, you can use your IDE's terminal for this.
# Then Navigate to the folder that contains the Dragonruby.exe
# Once there you can symply type "./dragonruby" into the terminal and poof
# The hello world example that comes with the gtk will reveal itself in a pop out window

# Important to note here is that dragon ruby will look for the first app folder available
# This means that the app folder inside of mygame is what is being compiled into dragonruby
# If there is a folder you would like to specify for dragonruby to compile you will need to include
# that files path after "./dragonruby" for example, the tech demo:
# "./dragonruby samples\01_api_99_tech_demo"

# If you desire more info on anything that we have gone over and more,
# the samples folder has dozens of examples with documentation;
# in addition, there is documentation inside of the "mygame\app\documentation" folder.
# This documentation goes of over the expressions we have used in the tutorial
# and is exelent for quick refernce of them until you are comfortable using them.

# Last but not least, here we have the most basic of shooters.
# With a little more work and imagination we could build this into a game of asteroids.

# With out further aduo
def tick(args)
  args.state.random ||= 1_000_000_000 # Random variable for enemy spawn
  # This is a shortcut, using args.state.x ||= 0 is the same as an if not ex:
  # args.state.x ||= 0 is a short version of if !args.state.x then args.state.x = 0

  user_interface args # The user interface function

  sprite args # The player sprite function

  bullet_physics args # this function deals with the bullet physics

  amimation args # This function animates the little sprites by the title

  enemy args # This function deals with enemy spawning
end

def enemy(args)
  args.state.enemy_time ||= args.state.tick_count

  if args.state.circle_x && ((args.state.tick_count - args.state.enemy_time) / 60 > 3)
    unless args.state.e1_x
      args.state.e1_x = (args.state.tick_count * rand(args.state.random)) % args.state.screen_bound_x
      args.state.e1_y = (args.state.tick_count * rand(args.state.random)) % args.state.screen_bound_y
      args.state.e1_size = 75
      bound(args, args.state.e1_x, args.state.e1_y, args.state.e1_size)
      args.state.e1_x = args.state.x
      args.state.e1_y = args.state.y
    end
    if args.state.e1_x
      args.state.e1_direction = args.state.tick_count % 90
      args.outputs.sprites << [args.state.e1_x, args.state.e1_y, args.state.e1_size, args.state.e1_size,
                               'sprites/isometric/violet.png', args.state.e1_direction]
      collision(args, args.state.e1_x, args.state.circle_x, args.state.e1_y, args.state.circle_y,
                args.state.e1_size, args.state.sprite_size)
      if args.state.collisions == 1
        ouch args
        args.state.enemy_time = args.state.tick_count
        args.state.e1_x = nil
        args.state.e1_y = nil
        args.state.kills += 1
        score args
      end
    end
    args.state.bullets.each do |e|
      next unless e.exists

      next unless args.state.e1_x

      collision(args, args.state.e1_x, e.x, args.state.e1_y, e.y, args.state.e1_size, e.size)
      next unless args.state.collisions == 1

      args.state.kills += 1
      score args
      args.state.enemy_time = args.state.tick_count
      args.state.e1_x = nil
      args.state.e1_y = nil
      e.y = nil
      e.x = nil
      e.exists = nil
    end

  end
end

# bound(args.state.object_x, args.state.object_y, args.state.object_size)
def bound(args, x, y, size)
  args.state.x = 0
  args.state.y = 0
  y = args.state.screen_bound_y - size - 1 if y <= 0
  y = 1 if y >= args.state.screen_bound_y - size
  x = args.state.screen_bound_x - size - 1 if x <= 0
  x = 1 if x >= args.state.screen_bound_x - size
  args.state.x = x
  args.state.y = y
end

def score(args)
  if args.state.lives <= 1
    args.state.highscore = args.state.current_score if args.state.current_score > args.state.highscore
    args.state.current_score = 0
    args.state.kills = 0
  else
    args.state.current_score += (args.state.lives * args.state.kills)
    args.state.highscore = args.state.current_score if args.state.current_score > args.state.highscore
  end
end

# This is a bullet physics function.
def bullet_physics(args)
  args.state.remove_array_element ||= []
  args.state.index ||= 0
  args.state.bullets  ||= []
  args.state.new_tick ||= 0
  if args.state.circle_x && args.controller_one.key_held.a && args.state.new_tick + 30 < args.state.tick_count
    args.state.new_tick = args.state.tick_count
    args.state.bullets << args.state.new_entity(:bullet) do |e| # declares each enemy as new entity
      e.index = args.state.index + 1 # Index of the entry
      args.state.index += 1 # incriment the indexing counter.
      e.size        = args.state.sprite_size / 10
      e.exists      = 1 # does the bullet exits
      e.direction   = args.state.circle_direction
      e.speed       = 10
      e.distance    = 0
      # Formulas for calculating bullet location in relation to the users circle.
      formula       = args.state.sprite_size + (e.size / 2)
      formula2      = (args.state.sprite_size - e.size) / 2
      case e.direction
      when 90
        e.x       = args.state.circle_x + formula2
        e.y       = args.state.circle_y + formula + 1
      when 180
        e.x       = args.state.circle_x - e.size
        e.y       = args.state.circle_y + formula2
      when 270
        e.x       = args.state.circle_x + formula2
        e.y       = args.state.circle_y - e.size

      when 0
        e.x       = args.state.circle_x + formula + 1
        e.y       = args.state.circle_y + formula2
      else
        e.x       = nil
        e.y       = nil
      end
      # args.state.since_last_bullet = args.state.tick_count - args.state.new_tick
      e.time        = args.state.tick_count / 60
      length        = 2 # In seconds
      e.limit       = (length * 60) * e.speed # 2 seconds, or 120 frames\
    end
  end

  args.state.bullets.each do |e|
    if e.exists

      args.outputs.sprites << [e.x, e.y, e.size, e.size, 'sprites/circle/black.png', e.direction]

      case e.direction
      when 90
        e.y += e.speed
      when 180
        e.x     -= e.speed
      when 270
        e.y     -= e.speed
      when 0
        e.x     += e.speed
      end

      if e.y <= 0
        e.y     = args.state.screen_bound_y - e.size
      elsif  e.y >= args.state.screen_bound_y - e.size
        e.y     = 0
      elsif  e.x <= 0
        e.x     = args.state.screen_bound_x - e.size
      elsif  e.x >= args.state.screen_bound_x - e.size
        e.x     = 0
      end
      e.distance += e.speed
      collision(args, e.x, args.state.circle_x, e.y, args.state.circle_y, e.size, args.state.sprite_size)
      if args.state.collisions == 1
        ouch args
        e.exists = nil
        e.y      = nil
        e.x      = nil
        # args.state.bullets.shift
      end
      if e.distance >= e.limit
        e.exists = nil
        e.y      = nil
        e.x      = nil
        # args.state.bullets.shift
      end
    else
      args.state.remove_array_element << e.index
      args.state.index_nil = e.index
    end
  end
  until args.state.remove_array_element.empty?
    args.state.bullets.delete_at(args.state.remove_array_element[0])
    args.state.remove_array_element.shift

  end
  args.state.index = 0
  args.state.bullets.each do |e|
    e.index = args.state.index
    args.state.index += 1
  end
end

# This is an animation function for a three image animation
def amimation(args)
  # This breakdown would need to change if more animation frames need to be added,
  # eg: 6 frames would need to split splits 11 times for a full loop and only 6 times for one iteration
  # So for this case:
  split = 60
  time = args.state.tick_count % split
  # cordsx/y for easy movment
  cordsx = 540
  cordsy = 675
  # offset is for the second animated sprite

  offset = 165
  b = 4
  if time < split * (1 / b)
    args.outputs.sprites << [cordsx, cordsy, 32, 32, 'sprites/misc/dragon-1.png']
    args.outputs.sprites << [cordsx + offset, cordsy, 32, 32, 'sprites/misc/dragon-1.png']
  elsif (time >= split * (1 / b) && time < split * (2 / b)) || (time >= split * (3 / b))
    args.outputs.sprites << [cordsx, cordsy, 32, 32, 'sprites/misc/dragon-2.png']
    args.outputs.sprites << [cordsx + offset, cordsy, 32, 32, 'sprites/misc/dragon-2.png']
  elsif time >= split * (2 / b) && time < split * (3 / b)
    args.outputs.sprites << [cordsx, cordsy, 32, 32, 'sprites/misc/dragon-3.png']
    args.outputs.sprites << [cordsx + offset, cordsy, 32, 32, 'sprites/misc/dragon-3.png']
  end
end

# This is a collision function.
# Collision(args, args.state.x1, args.state.x2, args.state.y1, args.state.y2, args.state.size1, args.state.size2)
def collision(args, x1, x2, y1, y2, size1, size2)
  args.state.collisions = 0
  args.state.collisions = 1 if y1 + size1 >= y2 && x1 + size1 >= x2 && y1 <= y2 + size2 && x1 <= x2 + size2
end

# Bellow is just the condensed user interface stuff
# User interface stuff
def user_interface(args)
  ticks = args.state.tick_count
  seconds = (ticks / 60).round(0)
  args.state.seconds = seconds unless args.state.seconds

  args.outputs.labels << [770, 720, 'Time Elapsed:', 8, 0, 200, 40, 100, 125]
  args.state.seconds = seconds if (ticks % 3).zero?
  args.outputs.labels << [1000, 720, args.state.seconds, 10, 0, 200, 0o50, 100, 125]
  args.outputs.labels << [640, 700, 'The Circle Game', -1, 1, 0, 0, 0, 150]
  args.outputs.labels << [642, 698, 'The Circle Game', -1, 1, 0, 200, 25]
  args.outputs.labels << [10, 710, 'Lives:', -3, 0, 155, 50,  50]

  args.outputs.labels << [10, 690, 'Score:', -3, 0, 155, 50,  50]
  args.outputs.labels << [60, 690, args.state.current_score, -3, 0, 155, 50, 50] if args.state.current_score
  args.outputs.labels << [10, 670, 'Highscore:', -3, 0, 155, 50, 50]
  args.outputs.labels << [90, 670, args.state.highscore, -3, 0, 155, 50, 50] if args.state.highscore
  args.outputs.lines << [0, 600, 1280, 600, 0, 0, 0, 255]
  board_x = 540
  board_y = 668
  board_w = 200
  board_h = 45
  echo = 4
  args.outputs.borders << [board_x, board_y, board_w, board_h, 0, 0, 200, 255]
  args.outputs.borders << [board_x - echo, board_y - echo, board_w + echo * 2, board_h + echo * 2, 200, 0, 0, 255]
  args.outputs.solids << [board_x - echo, board_y - echo, board_w + echo * 2, board_h + echo * 2, 35, 0, 50, 255]
  echo -= 5
  args.outputs.solids << [board_x - echo, board_y - echo, board_w + echo * 2, board_h + echo * 2, 25, 100, 40]
  args.state.lives = 0 if args.state.lives.negative? || !args.state.lives

  if args.state.lives == 1

    args.outputs.labels << [640, 590, 'Game over', 0, 1]
    args.state.circle_x = nil
    args.state.circle_y = nil
    args.state.lives = nil if args.state.ticks_since_nil.to_i + 120 < args.state.tick_count
  end
  args.outputs.sprites << [60, 697.5,  10, 10, 'sprites/circle/black.png', 90] if args.state.lives > 1
  args.outputs.sprites << [75, 697.5,  10, 10, 'sprites/circle/black.png', 90] if args.state.lives > 2
  args.outputs.sprites << [90, 697.5,  10, 10, 'sprites/circle/black.png', 90] if args.state.lives > 3
  if ticks % 255 < 127
    args.outputs.labels << [640, 655, 'Press WASD to Move', 0, 1, 0, 0, 0, ticks % 255]
    args.outputs.labels << [640, 625, 'Press Space to Shoot', 0, 1, 0, 0, 0, ticks % 255]
  else
    args.outputs.labels << [640, 655, 'Press WASD to Move', 0, 1, 0, 0, 0, 255 - ticks % 255]
    args.outputs.labels << [640, 625, 'Press Space to Shoot', 0, 1, 0, 0, 0, 255 - ticks % 255]
  end
end

def ouch(args)
  args.state.lives -= 1
  args.state.circle_life_length = args.state.tick_count - args.state.ticks_since_nil
  args.state.ticks_since_nil = args.state.tick_count
end

def sprite(args)
  ticks = args.state.tick_count
  sprite_size = 50
  args.state.sprite_size = sprite_size
  # Screen Boundries set to not interfear with the user interface
  screen_bound_x = 1280
  screen_bound_y = 600
  args.state.screen_bound_x = screen_bound_x
  args.state.screen_bound_y = screen_bound_y
  args.state.ticks_since_nil ||= 0
  args.state.highscore ||= 0
  if !args.state.circle_x && args.state.lives <= 0
    args.state.circle_x = (screen_bound_x - sprite_size) / 2
    args.state.circle_y = (screen_bound_y - sprite_size) / 2
    args.state.circle_direction = 0
    args.state.speed = 6
    args.state.lives = 4
    args.state.circle_life_length = args.state.tick_count
    args.state.kills = 0
    args.state.current_score = 0
    # args.state.since_last_bullet = 0
    args.state.ticks_since_nil = 0
  end
  if args.state.circle_x
    args.outputs.sprites << [args.state.circle_x, args.state.circle_y, sprite_size, sprite_size,
                             'sprites/hexagon/blue.png', args.state.circle_direction]
    if args.inputs.controller_one.right
      args.state.circle_x += args.state.speed
      args.state.circle_direction = 0
    end
    if args.inputs.controller_one.left
      args.state.circle_x -= args.state.speed
      args.state.circle_direction = 180
    end
    if args.inputs.controller_one.up
      args.state.circle_y += args.state.speed
      args.state.circle_direction = 90
    end
    if args.inputs.controller_one.down
      args.state.circle_y -= args.state.speed
      args.state.circle_direction = 270
    end
    # Bounds are set so the user wraps
    if args.state.circle_y <= 0
      args.state.circle_y = screen_bound_y - sprite_size - 1
    elsif  args.state.circle_y >= screen_bound_y - sprite_size
      args.state.circle_y = 1
    elsif  args.state.circle_x <= 0
      args.state.circle_x = screen_bound_x - sprite_size - 1
    elsif  args.state.circle_x >= screen_bound_x - sprite_size
      args.state.circle_x = 1
    end
  end
end
