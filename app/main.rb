$gtk.reset
def tick args
  if !args.state.sprite_x
    args.state.sprite_x = 120
    args.state.sprite_y = 80
    args.state.sprite_size = 10
    args.state.sprite_movement_speed = 1
    # Here is the new direction variable
    args.state.direction = 90
  end
  args.outputs.sprites << [args.state.sprite_x,
  args.state.sprite_y, args.state.sprite_size,
  args.state.sprite_size, 'sprites/circle/black.png',
  args.state.direction]
  # Now that we have an extra variable to assign
  # when  a key is pressed we will change the
  # format of our if statements.We can have our
  # sprite look in the direction it is traveling.
  if args.inputs.keyboard.d
    args.state.sprite_x += args.state.sprite_movement_speed
    args.state.direction = 0
  end
  if args.inputs.keyboard.w
    args.state.sprite_y += args.state.sprite_movement_speed
    args.state.direction = 90
  end
  if args.inputs.keyboard.a
    args.state.sprite_x -= args.state.sprite_movement_speed
    args.state.direction = 180
  end
  if args.inputs.keyboard.s
    args.state.sprite_y -= args.state.sprite_movement_speed
    args.state.direction = 270
  end
  # Here we make the bounds equivalent to whatever
  # our desired boundary numbers are.
  screen_bound_y = 90
  screen_bound_x = 160
  # We could also set up lower bounds for our
  # sprite but lets stick with zero for now.
  if  args.state.sprite_y <= 0
    # If the circle y coordinate is less than
    # the bottom of the screen it will relocate
    # the sprite back to where it was before
    # it tried to leave the screen
    args.state.sprite_y= 1
  elsif  args.state.sprite_y >= screen_bound_y
    args.state.sprite_y = screen_bound_y-1
  elsif  args.state.sprite_x <= 0
    args.state.sprite_x = 1
  elsif  args.state.sprite_x >= screen_bound_x
    args.state.sprite_x = screen_bound_x-1
  end
  # We can shift the boundaries to whatever
  # we might desire. We could even create an area
  # inside the bounds that we can not move through.
  # This could be a wall, a tree, or even an npc.
end