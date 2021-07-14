def tick(args)
  args.state.player.x ||= 1280/2
  args.state.player.y ||= 720/2
  args.state.player.w ||= 16
  args.state.player.h ||= 16
  args.outputs.sprites << {
    x: args.state.player.x,
    y: args.state.player.y,
    w: args.state.player.w,
    h: args.state.player.h,
    path: 'sprites/square/green.png'
  }
  if args.inputs.keyboard.right
    args.state.player.x += 2
  elsif args.inputs.keyboard.left
    args.state.player.x -= 2
  end
  if args.inputs.keyboard.up
    args.state.player.y += 2
  elsif args.inputs.keyboard.down
    args.state.player.y -= 2
  end
  # make sure the player's x and y position
  # are clamped to the the grid's minimum and
  # maximum width and height
  args.state.player.x = args.state.player.x.clamp(
    args.grid.left,
    args.grid.right - args.state.player.w
  )
  args.state.player.y = args.state.player.y.clamp(
    args.grid.bottom,
    args.grid.top - args.state.player.h
  )
end
