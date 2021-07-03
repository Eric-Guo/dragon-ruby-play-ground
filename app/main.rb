$gtk.reset
def tick args
  # First we need to create variables for our
  # sprites. We want to do this in a way that
  # it check if the object exists or not.
  # Its nice that in ruby we do not need to
  # declare a variable.  We can simply check
  # if it exists or not and then assign a
  # value if it does in fact not exist.
  args.state.sprite_x ||= 10
  args.state.sprite_y ||= 10
  args.state.sprite_size ||= 10
  # Doing this establishes the values for x and y.
  # Because they are an object of state, the
  # values will carry over from one tick/frame
  # to another.
  args.outputs.sprites << [args.state.sprite_x,
  args.state.sprite_y, args.state.sprite_size,
  args.state.sprite_size, 'sprites/circle/black.png']
  # Using these variables that are carried from
  # frame to frame lets us change them when ever
  # we need to.

  # For example we can have them change based on
  # the current tick count.
  args.state.sprite_x = (args.state.sprite_x + args.state.tick_count/4000)%160 if args.state.sprite_x
  args.state.sprite_y =  (args.state.sprite_y + args.state.tick_count/4000)%90 if args.state.sprite_y
  # This will move the sprite depending on the tick
  #count as you can see. This situation will also
  # speed up the circles movement as more ticks pass.
  args.outputs.labels << [50, 50, args.state.tick_count]
  # A little jank I know, but i assure you it can
  # be a useful techneque. If we have a sprites
  # location varry depending on the frame, we can
  # use this to establish a patrolling npc or monster.
  # All we need to add is some if statements.
  # Often we will need to play with values until
  # we see a desirable outcome. In this case we
  # could play with the initial values or how we
  # are changing them to create movement that is
  # much more smooth and predictable.
  # Feel free to play with this to see
  # some varring and interesting affects.
end