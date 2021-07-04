$gtk.reset
def tick args
  # Now, if we want our sprite to wrap we need
  # simply to have the sprites coordinates
  # change to the opposite side of the screen
  # when it goes out of bounds or off
  # the screen. This can also allow you to
  # make barriers too as we have seen.
  screen_bound_y = 90
  screen_bound_x = 160
  if  args.state.sprite_y <= 0
    # If the circle y coordinate is less than
    # the bottom of the screen it will relocate
    # the sprite to the top of the screen.
    args.state.sprite_y= screen_bound_y
  elsif  args.state.sprite_y >= screen_bound_y
    args.state.sprite_y = 1
  elsif  args.state.sprite_x <= 0
    args.state.sprite_x = screen_bound_x
  elsif  args.state.sprite_x >= screen_bound_x
    args.state.sprite_x = 1
  end
  # Down here we have the extra code we have
  # already discussed during this tutorial but
  # is necessary for this part of the tutorial
  if !args.state.sprite_x
    args.state.sprite_x = 120
    args.state.sprite_y = 80
    args.state.sprite_size = 10
    args.state.sprite_movement_speed = 1
    args.state.direction = 90
  end
  args.outputs.sprites << [args.state.sprite_x, args.state.sprite_y,
  args.state.sprite_size, args.state.sprite_size,
  'sprites/circle/black.png', args.state.direction]
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
end