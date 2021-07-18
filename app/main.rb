def tick(args)
  # place the player in the center of the
  # grid horizontally and on the floor (y = 0)
  args.state.player.x    ||= args.grid.w.half
  args.state.player.y    ||= 0
  args.state.player.size ||= 10
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
