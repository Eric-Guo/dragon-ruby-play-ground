def tick args
  ticks = args.state.tick_count
  text_w, text_h = args.gtk.calcstringbox(ticks.to_s, 50)

  board_w = text_w
  board_h = text_h
  board_x = (1280 - board_w) / 2
  board_y = (720 - board_h) / 2

  args.outputs.labels << [board_x+board_w, board_y + board_h, ticks, 50, 2, 153, 33, 255, 255]
  args.outputs.lines << [board_x, board_y, board_x + board_w, board_y + board_h, 100, 100, 100, 255]
  args.outputs.lines << [board_x, board_y + board_h, board_x + board_w, board_y, 50, 50, 50, 255]

  args.outputs.borders << [board_x, board_y, board_w, board_h, 0, 0, 200, 255]
  args.outputs.solids << [board_x+1, board_y+1, board_w-2, board_h-2, 180, 255, 255, 75]
end
