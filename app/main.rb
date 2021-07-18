def tick(args)
  # place the player in the center of the
  # grid horizontally and on the floor (y = 0)
  args.state.player.x    ||= args.grid.w.half
  args.state.player.y    ||= 0
  args.state.player.size ||= 10

  # define dy for the player
  args.state.player.dy   ||= 0
  # define jump power
  args.state.jump.power = 10

  # set dy equal to jump power if space is pressed
  if args.inputs.keyboard.key_down.space
    args.state.player.dy = args.state.jump.power
  end

  # reset the player's y and dy if r
  # is pressed on the keyboard
  if args.inputs.keyboard.key_down.r
    args.state.player.y  = 0
    args.state.player.dy = 0
  end

  # increase the player's y by dy every frame
  args.state.player.y += args.state.player.dy

  # render the player on the screen
  # taking into consideration the player's
  # size to center them
  args.outputs.sprites << {
    x: args.state.player.x -
       args.state.player.size.half,
    y: args.state.player.y,
    w: args.state.player.size,
    h: args.state.player.size,
    path: 'sprites/square/red.png'
  }
end
