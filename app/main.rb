def tick args
  # Wow that's a big sprite!

  # Sprites can act as a character, npc, building,
  # wall, bullet, or basically anything graphical
  # that you want them to be.
  # Its easy to make a simple interface using
  # lines, borders, and solids, but sprites will
  # fill your game with colors and fantastic
  # moving parts.

  # Lets start with a simple sprite such as a circle:
  SIZE = 100
  # Declaring size helps us manipulate it later.
  #                         X    Y    W      H
  args.outputs.sprites << [ 20,  20,  SIZE,  SIZE,
  # Location/Path
  'sprites/circle/black.png',
  # Angle  Alpha  Red    Green  Blue
    45,    200,   10,    230,   15]
  # Important to note here is the back slash is
  # used for the location of the png. Different
  # systems work differently when tracing a location.
  # The gtk uses back slashes for location.
  # It's important to use the correct path,
  # otherwise... well you will see ;)

  # If we use the method from above we have the
  # sprites X, and Y coordinates,then the Length
  # and With in pixels. Following this, we have
  # the location of the file of the sprite.
  # Then the Angle, which rotates counter clockwise
  # starting at 3 O'clock. We use degrees instead
  # of radians, because...
  # Well it's so much more intuitive and easy
  # isn't it? Following the angle is the 3 color
  # saturation's red, green, and blue,
  # and last of all is the alpha value.

  # Sprites will continue on the next step.
end