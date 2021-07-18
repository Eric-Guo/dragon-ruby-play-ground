def tick(args)
  # define gravity
  args.state.gravity    = -1
  # place the player in the center of the
  # grid horizontally and on the floor (y = 0)
  args.state.player.x    ||= args.grid.w.half
  args.state.player.y    ||= 0
  args.state.player.size ||= 10

  # define dy for the player
  args.state.player.dy   ||= 0
  # define jump power
  args.state.jump.power = 10
  # keep track of the player's current action
  args.state.player.action ||= :standing

  # set dy equal to jump power if space is pressed
  if args.inputs.keyboard.key_down.space
    args.state.player.dy = args.state.jump.power
    args.state.player.action = :jumping
  end

  # reset the player's y and dy if r
  # is pressed on the keyboard
  if args.inputs.keyboard.key_down.r
    args.state.player.y  = 0
    args.state.player.dy = 0
  end

  # apply gravity and dy if the player is jumping
  if args.state.player.action == :jumping
    args.state.player.y  += args.state.player.dy
    args.state.player.dy += args.state.gravity
  end
  # set the action to :standing when
  # the player hits the ground
  if args.state.player.y < 0
    args.state.player.y      = 0
    args.state.player.action = :standing
  end

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
