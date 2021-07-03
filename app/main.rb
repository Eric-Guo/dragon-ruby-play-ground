$gtk.reset
def tick args
  # For us to set up movement of our circle,
  # we are going to want to first set up the
  # starting location of our sprite.
  if !args.state.sprite_x
    # we have our basic x/y variables
    args.state.sprite_x = 100
    args.state.sprite_y = 80
    # here is the size
    args.state.sprite_size = 10
    # and finally the movement speed.
    # this will determine how many pixels per
    # frame the sprite will move while the key
    # is pressed
    args.state.sprite_movement_speed = 1
  end
  args.outputs.sprites << [args.state.sprite_x,
  args.state.sprite_y, args.state.sprite_size,
  args.state.sprite_size, 'sprites/circle/black.png']
  # For key functions we want to use args.inputs.keyboard.
  # after the last dot the desired key is typed.

  # There are many ways to write the following, but
  # this particular way should serve our purposes.
  # in this case we have the x coordinate increasing when d is pressed
  # and decreasing when a is pressed. similarly we have
  # y increasing when w is pressed and decreasing when s is pressed
  # now our circle will move like a character in a game.
  args.state.sprite_x += args.state.sprite_movement_speed if args.inputs.keyboard.d
  args.state.sprite_x -= args.state.sprite_movement_speed if args.inputs.keyboard.a
  args.state.sprite_y += args.state.sprite_movement_speed if args.inputs.keyboard.w
  args.state.sprite_y -= args.state.sprite_movement_speed if args.inputs.keyboard.s
end