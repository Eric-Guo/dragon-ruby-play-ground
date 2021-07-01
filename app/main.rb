$gtk.reset
def tick args
  ticks = args.state.tick_count
  args.outputs.labels << [64, 70, ticks, -5, 1, 0, 160,
  0, 255]
  args.outputs.lines << [37, 55, 86, 73, 100, 100, 100, 255]
  args.outputs.lines << [37, 74, 86, 56, 50, 50, 50, 255]

  board_x = 36
  board_y = 54
  board_w = 52
  board_h = 21

  args.outputs.borders << [board_x, board_y, board_w,
  board_h, 0, 0, 200,  255 ]
  args.outputs.solids << [board_x+1, board_y+1,
  board_w-2, board_h-2, 35, 0, 50, 255]
end
