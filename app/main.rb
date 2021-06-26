$gtk.reset
def tick args
  # Because there is a game instance every frame,
  # we will need a way to save the changes from
  # frame to frame.
  # We can do this by creating a state variable.
  # State variables are best created in an
  # if statement for our purposes.
  # If we try to create them outside of the
  # if statement, it can result in the variable
  # being redeclared with it's starting value
  # every single frame.

  # So we create click_count. In this case,
  # if click_count doesnt exist we create it.
  if !args.state.click_count
    args.state.click_count = 0
  end
  args.state.click_count2 = 0 if !args.state.click_count2
  args.state.click_count3 ||= 0
  # These are 3 ways of doing the same thing

  # In this case we are making click_count,
  # to track how many clicks have occurred inside
  # the game window.
  # This allows a change the game state every time
  # a click occurs inside the window.
  # Clicking in the window now will reveal a
  # temporary message

  # Now we check to see if the click has returned
  # to the up position. Every time this occurs
  # we can increment click count by one.
  if args.inputs.mouse.up
    args.state.click_count += 1
    # We also need to reset mouse.up to 0.
    # we do this so the values dont continue
    # to increment uncontrollably.
    args.inputs.mouse.up = 0
  end

  # This is one of the many example of how you can
  # use inputs to receive information from the user.
  # In this case we are receiving a click from the
  # user and depending on how many mouse clicks
  # have occurred we will output
  # a different information onto the screen.
  # It's almost like a power point how we have set
  # it up. So, now each click will change
  # a component to the game window.

  # We can take input from any key, click or button
  # via the args.inputs.mouse, args.inputs.keyboard,
  # and args.inputs.controller expressions.
  # Adding key designations to keyboard and
  # controller expressions allow us to use
  # almost any key or button in our game.
  # From there we can add .up, .down, .held, .click
  # and all sorts of expressions to change the the
  # information we are obtaining from a press.
  # in the movement section we will see how we
  # can move a sprite with a key press.

  # click now in the window to reveal A New Tex
  # each click will reveal a new text.
  if args.state.click_count == 1
    args.outputs.labels << [80, 40,
    "A New Text", -5, 0, 200, 50, 200, 255]
  elsif args.state.click_count == 2
    args.outputs.labels << [20, 80,
    "Look a New Text", -5, 1, 70, 50, 250, 165]
  elsif args.state.click_count == 3
    args.outputs.labels << [120, 40,
    "Another New Text", -5, 1, 0, 250, 200, 255]
  elsif args.state.click_count == 4
    args.outputs.labels << [100, 20,
    "Text That's New", -5, 1, 200, 50, 0, 55]
  elsif args.state.click_count > 4
    args.outputs.labels << [80, 60,
    "This is very important", -5, 1, 00, 20, 00, 255]
    args.outputs.labels << [80, 40,
    "for creating a user interface",
    -5, 1, 0, 50, 0, 255]
    args.outputs.labels << [80, 20,
    "^_^", -5, 1, 20, 20, 20, 255]
  else
    args.outputs.labels << [80, 40,
    " Click now", -5, 1, 0, 0, 0, 255]
    args.outputs.labels << [80, 20,
    "^_^", -5, 1, 200, 250, 200, 255]
  end
end
# That's it, 5 clicks.
# Now before we move on the the next part
# try playing with some of the values.
# See what happens :P