def tick args
  ticks = args.state.tick_count

  board_x = 50
  board_y = 60
  board_w = 50
  board_h = 50

  args.outputs.borders << [board_x,  board_y,
     board_w,  board_h, 0,   0,      0,  255]

  args.outputs.solids << [board_x+6, board_y+6,
    board_w-12, board_h-12, 35, 0, 50, 255]


  args.outputs.borders << [board_x+ticks*2,  board_y+ticks,
    board_w,  board_h, 200,   0,      0,  255]

  args.outputs.solids << [board_x+6+ticks*2, board_y+6+ticks,
    board_w-12, board_h-12, 200, 0, 0, 255]


  args.outputs.borders << [board_x+ticks,  board_y+ticks,
    board_w,  board_h, 0,   200,      0,  255]

  args.outputs.solids << [board_x+6+ticks, board_y+6+ticks,
    board_w-12, board_h-12, 0, 200, 0, 255]


  args.outputs.borders << [board_x,  board_y+ticks,
    board_w,  board_h, 0,   0,      200,  255]

  args.outputs.solids << [board_x+6, board_y+6+ticks,
    board_w-12, board_h-12, 0, 0, 200, 255]


  args.outputs.borders << [board_x+ticks,  board_y,
    board_w,  board_h, 0,   100,      100,  255]

  args.outputs.solids << [board_x+6+ticks, board_y+6,
    board_w-12, board_h-12, 0, 100, 100, 255]


  args.outputs.borders << [board_x+ticks*2,  board_y,
    board_w,  board_h, 100,   0,      200,  255]

  args.outputs.solids << [board_x+ticks*2+6, board_y+6,
    board_w-12, board_h-12, 100, 0, 200, 255]
end
