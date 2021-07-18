def tick(args)
  # define gravity
  args.state.gravity    = -1
  # place the player in the center of the
  # grid horizontally and on the floor (y = 0)
  args.state.player.x    ||= args.grid.w.half
  args.state.player.y    ||= 0
  args.state.player.size ||= 10
  args.state.player.dy   ||= 0

  args.state.player.action ||= :jumping
  args.state.jump.power           = 5
  args.state.jump.increase_frames = 15
  args.state.jump.increase_power  = 1

  args.outputs.sprites << {
    x: args.state.player.x -
       args.state.player.size.half,
    y: args.state.player.y,
    w: args.state.player.size,
    h: args.state.player.size,
    path: 'sprites/square/red.png'
  }

  if args.inputs.keyboard.key_down.space && (args.state.player.action == :standing)
    args.state.player.action = :jumping
    args.state.player.dy = args.state.jump.power
    current_frame = args.state.tick_count
    args.state.player.action_at = current_frame
  end

  if args.inputs.keyboard.key_held.space
    is_jumping = args.state.player.action == :jumping
    time_of_jump = args.state.player.action_at
    jump_elapsed_time = time_of_jump.elapsed_time
    time_allowed = args.state.jump.increase_frames
    if is_jumping && jump_elapsed_time < time_allowed
      power_to_add = args.state.jump.increase_power
      args.state.player.dy += power_to_add
    end
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
end
