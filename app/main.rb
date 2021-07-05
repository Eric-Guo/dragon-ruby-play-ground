# As you have seen in the tech demo these expressions can do a lot.
# Now that you have seen the tech demo, its time to show you how it all works.

# By default args is what we tend to use as the main object which the rest of the game will run on.
def tick args

  # For an example we are going to create an interface with the expressions shown in the demo.
  # To show each element one at a time we are going to create an if statement to separate each step
  # This way we can see each element introduced individually as to not get too overwhelming.

  #-----------Ticks
  # First we are going to want a variable to represent the tick count there are 60 ticks per second
  # Ticks also represent the number of frames of the game that exist consecutively per second
  ticks = args.state.tick_count # Having a variable lets us bypass using the whole expression going forward.

  # The tick count is useful.
  # It allows us to know how many instances of the game have ran,
  # it gives us a sense of time for our game,
  # and because game will update every frame,
  # it will allow us to differentiate actions depending on the current frame.

  # Something it can also allow for is the animation sprites and environments.
  # Unfortunately we wont have time to go over that, so expect a later tutorial to cover that.

  #----------- Mouse clicks and inputs
  # One more declaration we are going to for the tutorial is click count
  # Because there is a game instance every frame,
  # we need a way to save the changes from frame to frame
  # We can do this by creating a state variable.
  # State variables are best created in an if statement for our purposes.
  # If we try to create them outside of the if statement,
  # it can result in the variable being redeclared with it's starting value every frame.

  # So we create click_count
  # In this case, if click_count doesnt exist we create it.
  if !args.state.click_count

    args.state.click_count = 0
  end

  # We are making click_count, to track how many clicks have occurred inside the game window.
  # Using this we are able to change the game state every time a click occurs inside the window.
  # Clicking on it now will reveal a temporary message from further in the tutorial.

  # Now we check to see if the click has returned to the up position.
  # Every time this occurs we can increment click count by one.
  if args.inputs.mouse.up
    args.state.click_count += 1
    # We also need to reset mouse.up to 0 so it doesn't continuously increment click_count every frame.
    args.inputs.mouse.up = 0
  end
  # This is one of the many example of how you can use inputs to receive information from the user.
  # In this case we are receiving a click from the user
  # and depending on the number of clicks we are outputting different information onto the screen.
  # The way we set it up, it's kind of like a power point in that each click adds an additional component.

  # We can take input from any key, click or button via the
  # args.inputs.mouse, args.inputs.keyboard, and args.inputs.controller expressions.
  # Adding key designations to keyboard and controller expressions allow us to use
  # almost any key or button in our game.
  # From there we can add .up, .down, .held, .click
  # and all sorts of expressions to change the the information we are obtaining from a press.

  # There will be direct example in the sprite section of the tutorial

######################################################
  # So where do we start?
  # We already have.

  # To get some actual output onto the screen though, we will start with labels,
  # but there are many other expressions
  # that you can expect to find in the dragonruby gametoolkit (gtk).
  # These expressions are: labels, lines, borders, solids, sprites, inputs, outputs, keyboard, mouse, and controller
  # There are many other expressions with more added with every update, but i am going to start with these.

  #----------- Labels

  # Our first label will be placed onto the top right corner of the screen.

  # This is the if statement that will change what pops up onto the screen
  # Each time we click the mouse.
  # If you haven't clicked once yet, CLICK NOW!
  if args.state.click_count == 1

    # To create a label with the gtk we will need to use the following array format:
    #                        X     Y    TEXT                    SIZE   ALIGNMENT   RED     GREEN   BLUE   ALPHA   FONT FILE
    args.outputs.labels << [1000, 720, "This is a temp msg", 5, 0, 200, 050, 100, 175, "fonts/coolfont.ttf"]
  end

  # The parameters start with the coordinate, x and y,
  # followed by the text in quotations that you want outputted,
  # each of which is to be separated by a comma.
  # After that we have the text size, alignment, of which 1 will center your text on the coordinates,
  # followed by red, green, and blue saturation.
  # Finally, the alpha is the transparency,
  # which needs to be set at 255 to be solid, and lastly is font with the extension .ttf.

  #

  # Click!
  if args.state.click_count > 2
    # we are going to replace this temp message with the tick count in the corner.
    # It will help us keep track of how many instances of the game have ran among other things.
    args.outputs.labels << [1000, 720, ticks, 25, 0, 200, 050, 100, 25]
  end

  # Click!
  if args.state.click_count > 3
    # We can leave off parameters if you dont need them as well.
    # Leaving them off will set them to a default value.
    args.outputs.labels << [640, 700, "This is a game", 0, 1] # This will be the title for the game.
  end

  # Click!
  if args.state.click_count > 4
    # We can also use a hash, which is a more readable version, that sometimes has more functionality.
    args.outputs.labels << {
        x: 10,
        y: 710,
        text: "Lives:",
        size_enum: -3,
        alignment_enum: 0,
        r: 155,
        g: 50,
        b: 50,
        a: 255,
        font: "fonts/manaspc.ttf"
    }
  end
  # Most of the expressions have a more readable version like this
  # which can help when you are just starting out.
  # Hashes may be more readable, but they are harder on performance.
  # Arrays are faster and easier to compile.
  # It's more efficient to use arrays, so once the developer gets use to them,
  # unless hashes are needed for functionality, arrays are the go to.

  #----------- Lines
  # Click!
  if args.state.click_count > 5
    # The next expression we will go through is lines:
    #                       X1  Y1    X2     Y2      RED   GREEN   BLUE  ALPHA
    args.outputs.lines << [ 0,  600,  1280,  600,    0,    0,      0,    255]
  end
  # Lines are different but a little less complicated.
  # The first 4 fields are the x/y coordinate beginning and end points.
  # x1, y1 are the origin points, and x2, y2 are the end points to the line.
  # Just like with labels you can change the color of the line.
  # You can even make it invisible or transparent using alpha if you want.

  # The Line also has a hash

  # Click!
  if args.state.click_count == 7
    args.outputs.lines << {
        x: 0,
        y: 0,
        x2: 1280,
        y2: 720,
        r: 0,
        g: 255,
        b: 0,
        a: 255
    }
    args.outputs.lines << [0, 720, 1280, 0]
  end

  # So far so good.
  # Our user interface is looking alright.
  # I think we could make the title more distinct however.

  #----------- Solids and boarders

  # For this we are going to use some boarders and solids.
  # Lets declare some values.
  # Remember that the coordinate for the title label were: 640, 700
  # and alignment was selected to center the text.
  # Often you will want to play with the coordinate to get things where you want them.
  # We shall create a couple variables to assist in this process.
  board_x = 540
  board_y = 668
  board_w = 200
  board_h = 45
  echo = 4 # Echo is going to represent a slight modification to the original values
  # our echo value will allow us to change additional solids and boarders to make the background more distinct
  # Click!
  if args.state.click_count > 7

    #                        X         Y         WIDTH     HEIGHT   RED  GREEN   BLUE  ALPHA
    args.outputs.borders << [board_x, board_y, board_w, board_h, 0, 0, 200, 255]
  end

  # Boarders and solids are like lines, but they start at the desired coordinate and then have
  # a width and height.
  # X, Y are the coordinates and w and h are width and height.
  # Similarly to the other expressions we also have alignment and color.


  # Click!
  if args.state.click_count > 8
    # Here we have the additional borders at an offset of size echo
    args.outputs.borders << [board_x - echo, board_y - echo, board_w + echo * 2, board_h + echo * 2, 200, 0, 0, 255]
  end
  if args.state.click_count > 9
    args.outputs.solids << [board_x - echo, board_y - echo, board_w + echo * 2, board_h + echo * 2, 35, 0, 50, 255]
  end

  echo -= 5
  # Changing the echo here can allow to create a depth effect
  # or add layers to the background of the title

  # Click!
  if args.state.click_count > 9
    args.outputs.solids << {
        x: board_x - echo,
        y: board_y - echo,
        w: board_w + echo * 2,
        h: board_h + echo * 2,
        r: 25,
        g: 100,
        b: 40,
        a: 255
    }
    echo = 10
    args.outputs.solids << [board_x - 4, board_y - echo, board_w + echo + 4, board_h + echo + 4, 0, 35, 0, 20]
    # This is a very basic shadow to show how these might be done.
    # It doesnt look great but if we used a similar looking sprite
    # with rounded edges we might get a better effect
  end

  # Now that our tittle is more distinct, our rough user interface is done for the movement.
  # The next steps will cover sprites, movement and wrapping.
end
