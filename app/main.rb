def tick args
  # The next expression we will go through is lines:
  #                       X1  Y1    X2
  args.outputs.lines <<  [0,  90,   160,
  # Y2    RED   GREEN   BLUE  ALPHA
    0,    0,    0,      0,    255]
  # Lines are different but a little less
  # complicated. The first 4 fields are the
  # x/y coordinate beginning and end points.
  # x1, y1 are the origin points, and x2, y2
  # are the end points to the line. Just like with
  # labels we can change the color of the line.
  # We can even make it invisible or transparent
  # using alpha if we want.

  # The Line also has a hash
  args.outputs.lines << {
    x: 0,
    y: 0,
    x2: 160,
    y2: 90,
    r: 0,
    g: 255,
    b: 0,
    a: 255
  }
  # Play around with the values and you can see how
  # it affects the lines
end
