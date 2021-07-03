def tick args
  # There are many extra parts to hashes some are
  # self explanatory others might seem strange
  # Test them to see what they do.
  # We do not have enough time this tutorial
  # to explore them, but future tutorials will.
  args.outputs.sprites << {
    x: 80,
    y: 40,
    w: 10,
    h: 10,
    path: "sprites/circle/black.png",
    angle: 0,
    a: 255,
    r: 255,
    g: 255,
    b: 255,
    # These we wont be touching in this tutorial,
    # but they are extremely useful. \/ \/ \/
    source_x:  0,
    source_y:  0,
    source_w: -1,
    source_h: -1,
    flip_vertically: false,
    flip_horizontally: false,
    angle_anchor_x: 0.5,
    angle_anchor_y: 1.0
  }
  # Whats this checkers pattern?
  # This is what happens when your path doesnt
  # lead to a file or destination without a
  # compatible file. No sprite exists of the
  # designated name in the designated path,
  # so it outputs a place holder.
end