RAYS = 128
SPLIT = 8
RAYSPERPASS = 4
CLEAR = 60
DRAW_RAYS = true

MAX = 500
ACCURACY = 2 # Accepts numbers 1 or 2. For some reason 3 or greater crashes? Lower is more accurate, but slower

DEGREES_TO_RADIANS = Math::PI / 180
ANGLE = 360 / RAYS

def clearRays
  $rayArray = []
end

def tick args

  mapStuff(args)

  # Raycasting
  $rayArray ||= []

  if args.state.tick_count.mod(CLEAR) == 0
    clearRays
  end

  passIDX = 0
  $splitIDX ||= 0
  $offset ||= 0

  until passIDX > RAYSPERPASS

    currentRay = $splitIDX * ( RAYS / SPLIT) + $offset
    currentAngle = ANGLE * currentRay

    $rayArray[currentRay] = calcRay(args, currentAngle)

    $splitIDX += 1

    if $splitIDX >= SPLIT
      $splitIDX = 0
      $offset += 1
    end

    passIDX += 1

    #labels = [passIDX, $splitIDX, $offset]
    #args.outputs.labels [500, 360, "#{labels}"]

  end

    if $offset > RAYS / SPLIT
      $offset = 0
    end

  playerBox = {x: $playerX, y: $playerY, w: $playerWidth, h: $playerWidth, r: 0, g: 255, b: 0, primitive_marker: :solid}

  # Print
  args.outputs.labels << {x: 20, y: 600, text: "Use arrow keys to move."}

  if DRAW_RAYS == true; args.outputs.primitives << $rayArray; end
  args.outputs.primitives << playerBox
  args.outputs.primitives << [1280 / 2, 700, "Rays: #{RAYS}, Split: #{SPLIT}, Pass: #{RAYSPERPASS}, Clear: #{CLEAR}, Draw: #{DRAW_RAYS}", 0, 1].label
  args.outputs.debug << args.gtk.framerate_diagnostics_primitives
end

def calcRay (args, angle)

  collision = false
  length = 0

  until collision or length == MAX
    maxX = $playerX + 16 + (length * Math.cos(angle * DEGREES_TO_RADIANS))
    maxY = $playerY + 16 + (length * Math.sin(angle * DEGREES_TO_RADIANS))

    line = {x: $playerX + 16, y: $playerY + 16, x2: maxX, y2: maxY}
    $obstacles.each { | obstacle |

    if obstacle.intersect_rect? [line[:x2], line[:y2], 1, 1]
      collision = true
    else
      length += ACCURACY
    end
  }
  end
  return line
end

# Make random numbers slightly easier
def randr (min, max)
  rand(max - min) + min
end

def mapStuff (args)
  # Spawn Obstacles
  $obstacles ||= []
  if $obstacles == []
    spawnQueue = 10
    until spawnQueue == 0
      $obstacles << {x: randr(0, 1280), y: randr(0, 720), w: randr(32, 256), h: randr(32, 256), r: 256, g: 0, b: 0, primitive_marker: :solid}
      spawnQueue -= 1
    end
  end

  # Print
  args.outputs.primitives << $obstacles

  # Define Player
  $playerX ||= 1280 / 2
  $playerY ||= 720 / 2
  $playerWidth ||= 32
  $playerSpeed ||= 5

  # Move Player
  initialx = $playerX
  initialy = $playerY

  if args.inputs.right
    $playerX += $playerSpeed
  end
  if args.inputs.left
    $playerX -= $playerSpeed
  end
  if args.inputs.up
    $playerY += $playerSpeed
  end
  if args.inputs.down
    $playerY -= $playerSpeed
  end
end
