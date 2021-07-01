def tick args
  # Often it is necessary to play with the
  # coordinates to get things in their
  # desired locations. We shall create a
  # couple variables to assist in this process.
  board_x = 50
  board_y = 60
  board_w = 20
  board_h = 20

  # Boarders and solids are like lines, but they
  # start at the desired coordinate and then have
  # a width and height. X and Y are the coordinates.
  # W and H are width and height.
  # Similarly to the other expressions
  # we also have alignment color and transparency.

  #                        X         Y
  args.outputs.borders << [board_x,  board_y,
  #  WIDTH     HEIGHT   RED  GREEN   BLUE  ALPHA
     board_w,  board_h, 0,   0,      200,  255]

  # solids are organized pretty much the same
  # way as boarders. The only difference is
  # that they portray a solid color.
  args.outputs.solids << [board_x+1, board_y+1,
  board_w-2, board_h-2, 35, 0, 50, 255]

  # As before, you can play around with the values
  # to see how things in the window change
end
