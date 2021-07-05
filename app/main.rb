# frozen_string_literal: true

# In addition to the expressions are such things as gtk expressions.
$gtk.reset # reset all game state if reloaded.
# This expression will reset or reload the game every time that the game is saved.
# There are many more that exist in dragon ruby that can help with testing
# the game or even with functionality.
# If we wanted to we could set up something more elaborate here, instead of creating it globally,
# we could have the game reset if the user presses r for example.

def tick(args)
  # I have taken the liberty of cleaning up and condensing the previous example code
  # into a function called user interface.
  user_interface args
  # As we expand our user interface we can add functions and information to it.
  # To condense it i took all the code and put it into its own function called user_interface.
  # If we added user interface aspects we could add them to this function.

  # Despite the clean up this bit of code is still useful
  # to show each item one step at a time so we keep it here up top.
  ticks = args.state.tick_count
  args.state.click_count = 0 unless args.state.click_count
  if args.inputs.mouse.up
    args.state.click_count = args.state.click_count + 1
    args.inputs.mouse.up = 0
  end

  # The next element for us to examine is sprites. Now these are the key elements of the game.
  # (plus or minus some labels.)
  # Sprites will act as a character, npc, building, wall, bullet,
  # or basically anything graphical on the screen.
  # Its easy to make a simple interface using lines, borders, and solids,
  # but sprites will fill your game with colors and fantastic moving parts.

  # Lets start with a simple sprite such as a circle:

  if args.state.click_count == 1
    #                         X    Y    W    H    Location/Path           Angle Alpha Red Green Blue
    args.outputs.sprites << [600, 500, 200, 200, 'sprites/circle/black.png', 45, 200, 10, 230, 15]
    # Important to note here is the back slashed used for the location of the png.
    # Different systems work differently when tracing a location.
    # The gtk uses back slashes for location.
    # It's important to use the correct path, otherwise... well you will see :)
  end
  # Dont forget to click to reveal the new element

  # Wow that's pretty big, and its on top of the user interface too.
  # Lets run through what the elements of the sprite expression consist of before we try to fix it.

  # If you use the method from above you have your X, and Y coordinates,
  # then your Length and With in pixels
  # Following this, we have the location of the file of the sprite.
  # Then the Angle, which rotates counter clockwise starting at 3 O'clock.
  # We use degrees instead of radians, because...
  # Well it's so much more intuitive and easy isn't it?
  # Following the angle is the alpha, and the 3 color saturation's red green blue.

  # But there are more options if you use hashes.
  if args.state.click_count == 2
    args.outputs.sprites << {
      x: 100,
      y: 100,
      w: 100,
      h: 100,
      path: 'sprites/misc/dragon-0.png',
      angle: 0,
      a: 255,
      r: 255,
      g: 255,
      b: 255,
      # These we wont be touching in this tutorial, but they are extremely useful.
      source_x: 0,
      source_y: 0,
      source_w: -1,
      source_h: -1,
      flip_vertically: false,
      flip_horizontally: false,
      angle_anchor_x: 0.5,
      angle_anchor_y: 1.0
    }
  end
  # Oops! Whats this checkers pattern?
  # This is what happens when your path doesnt lead to a file or destination without a compatible file.
  # No sprite exists of this type so it outputs a place holder.

  # For our purposes the circle will work fine.

  #-------------- Calculating the position
  # We want to fix the circle so lets move it to the center of the screen and make it solid again
  # Lets set a couple of variables to the dimensions of the screen to make this easier
  # We will also need the size of the circle as well
  sprite_size = 50 # Lets set the circle size to 50 pixels for now
  screen_bound_x = 1280
  screen_bound_y = 720
  if args.state.click_count == 3
    args.outputs.sprites << [screen_bound_x / 2, screen_bound_y / 2, sprite_size, sprite_size, 'sprites/circle/black.png',
                             135]
  end

  # Its still not quite centered is it.
  # Since the origin of the sprite is in the bottom left corner of itself,
  # lets try to include that in our calculations.

  if args.state.click_count == 4
    args.outputs.sprites << [(screen_bound_x - sprite_size) / 2, (screen_bound_y - sprite_size) / 2, sprite_size, sprite_size,
                             'sprites/circle/black.png', 112.5]
  end

  # Much better its useful to take into consideration the objects dimensions when calculating positions.

  #---------- Movement
  # What about movement?
  # If we want to move our sprite we will need to have its coordinates
  # change every time we press a key or button.
  # This means will need a variable that is saved from frame to frame like the clicks are.

  # To do that first we will need to determine if our sprite exists.
  # If it doesn't it will create the variables needed for the sprites creation.
  # We do this by checking if the state value for the coordinates exist
  # this way we are not reinitialising the sprite every frame in the same spot.
  unless args.state.circle_x
    # As before to center our sprite we need to include the sprites size in the calculation.
    args.state.circle_x = (screen_bound_x - sprite_size) / 2
    args.state.circle_y = (screen_bound_y - sprite_size) / 2
    # Also, if we care about the sprites direction we will need this
    # to be a variable that will carry from frame to frame as well.
    args.state.circle_direction = 90
  end

  # Now we can see how movement might work in a game.
  # We are going to establish a variable for the speed of our sprite.
  # This can help us change the movement speed as we please with one edit to speed
  # instead of having to change it a number of times though out our code.
  # You may not need to use a variable for your game but for this one we will.
  speed = 5

  # Click!
  if args.state.click_count == 5
    args.outputs.sprites << [args.state.circle_x, args.state.circle_y, sprite_size, sprite_size,
                             'sprites/circle/black.png', 90]

    # Now, just like when you click to advance the tutorial, you can press a key to move the sprite.
    # This works with the expression keyboard.
    # You can also use controller or mouse.
    # For our game keyboard will serve our purposes nicely.

    # For this to work we need to check if our sprite exists in the first place
    # and determine if the desired key was pressed.
    if args.inputs.keyboard.d && args.state.circle_x
      # If our user presses the d key we update the x value depending on the desired speed.
      args.state.circle_x += speed
    elsif args.inputs.keyboard.a && args.state.circle_x
      # This line decrements x based on a.
      args.state.circle_x -= speed
    elsif args.inputs.keyboard.w && args.state.circle_y
      # and w increments the y coordinate.
      args.state.circle_y += speed
    elsif args.inputs.keyboard.s && args.state.circle_y
      # and finally y is decremented by the s key.
      args.state.circle_y -= speed
    end
    # We are using the wasd format
    # Additionally, you can set almost any key to perform an action if you desire.
    # It becomes possible using the args.input.keyboard expressions
    # Just follow that up with a .key whatever key that might be.

  end

  # We can also have speed carry over if we want it to change as we play our game.
  # This could allow for power ups, equipment, or other components to change the characters speed.
  # How you implement this is up to you.
  # Here we are going to use speed to move the character and for nothing else.
  args.state.speed = 3 unless args.state.speed

  # Another cool thing that can be done is a direction change.
  # You can change the angle in which the sprite is rendered based on the direction your sprite is moving.
  # In this case we bound the direction change to the key pressed, but there are many other ways
  # to perform this and other direction changes.
  # You could even have the sprite slowly turn to the designated direction.
  # Click
  if args.state.click_count >= 6

    args.outputs.sprites << [args.state.circle_x, args.state.circle_y, sprite_size, sprite_size,
                             'sprites/circle/black.png', args.state.circle_direction]
    if args.inputs.keyboard.d && args.state.circle_x
      args.state.circle_x += args.state.speed
      args.state.circle_direction = 0
    end
    if args.inputs.keyboard.a && args.state.circle_x
      args.state.circle_x -= args.state.speed
      args.state.circle_direction = 180
    end
    if args.inputs.keyboard.w && args.state.circle_y
      args.state.circle_y += args.state.speed
      args.state.circle_direction = 90
    end
    if args.inputs.keyboard.s && args.state.circle_y
      args.state.circle_y -= args.state.speed
      args.state.circle_direction = 270
    end

    # Now if we want our sprite to wrap we can do that by having the sprites coordinates change
    # when it goes out of bounds or off the screen.
    # This can also allow you to make barriers too.
    if args.state.click_count > 6
      if args.state.circle_y <= 0
        # If the circle y coordinate is less than the bottom of the screen
        # it will relocate the sprite at the top of the screen.
        # This is how the rest of the directions work too.
        args.state.circle_y = screen_bound_y
      elsif  args.state.circle_y >= screen_bound_y
        args.state.circle_y = 0
      elsif  args.state.circle_x <= 0
        args.state.circle_x = screen_bound_x
      elsif  args.state.circle_x >= screen_bound_x
        args.state.circle_x = 0
      end
    end
    # Now if we want we can also clean this up and have the sprite wrap around the screen when it hits
    # the user interface, but i'll leave that as an exercise
  end
  # Now you have seen how sprites work and how to move them.
  # There are so many ways to go about all of what we have seen.
  # The next section will once more look at the tech demo briefly.
end

# Bellow is just the condensed user interface stuff
# User interface stuff
def user_interface(args)
  ticks = args.state.tick_count

  args.outputs.labels << [1000, 720, ticks, 25, 0, 200, 0o50, 100, 25]
  args.outputs.labels << [640, 700, 'This is a game', 0, 1]
  args.outputs.labels << { x: 10, y: 710, text: 'Lives:', size_enum: -3, alignment_enum: 0, r: 155,
                           g: 50, b: 50 }
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

  args.outputs.solids << {
    x: board_x - echo,
    y: board_y - echo,
    w: board_w + echo * 2,
    h: board_h + echo * 2,
    r: 25,
    g: 100,
    b: 40,
    a: 255
  }
  echo = 10
  args.outputs.solids << [board_x - 4, board_y - echo, board_w + echo + 4, board_h + echo + 4, 0, 35, 0, 20]
end
