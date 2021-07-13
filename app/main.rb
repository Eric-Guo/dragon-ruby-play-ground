HEIGHT = 200

DEGREES_TO_RADIANS = Math::PI / 180

INRADIUS = HEIGHT / 2
CENTERX = 1280 / 2
CENTERY = 720 / 2

def tick(args)
  slider(args)

  sideNum = $sliderValue
  angle = 360 / sideNum
  sidelength = 2 * INRADIUS * Math.tan((180 / sideNum) * DEGREES_TO_RADIANS)

  # Center Crosshair
  printme = []
  @crosshair ||= [{ x: CENTERX - 10, y: CENTERY, x2: CENTERX + 10, y2: CENTERY },
                  { x: CENTERX, y: CENTERY - 10, x2: CENTERX, y2: CENTERY + 10 }]
  printme << @crosshair

  sides = []
  referencePoint = [CENTERX - (sidelength / 2), CENTERY - INRADIUS]
  angleIndex = 0
  sideNum.each do
    newPoint = pointAtAngleDistance(point: referencePoint, angle: angleIndex, distance: sidelength)
    sides << { x: referencePoint[0], y: referencePoint[1], x2: newPoint[0], y2: newPoint[1] }
    referencePoint = newPoint
    angleIndex += angle
  end

  printme << sides

  args.outputs.lines << printme
end

def pointAtAngleDistance(point:, angle:, distance:)
  x2 = point[0] + (distance * Math.cos(angle * DEGREES_TO_RADIANS))
  y2 = point[1] + (distance * Math.sin(angle * DEGREES_TO_RADIANS))
  [x2, y2]
end

def slider(args)
  width = 300
  start = CENTERX - width / 2
  sliderLines = []

  $centerLine ||= { x: start, y: 150, x2: start + width, y2: 150 }
  sliderLines << $centerLine

  $sliderHandle ||= { x: start + width / 2 - 10, y: 125, w: 20, h: 50 }

  if args.inputs.mouse
    $sliderHandle[:x] = args.inputs.mouse.x - 10
    $sliderHandle[:x] = start if $sliderHandle[:x] < start
    $sliderHandle[:x] = start + width - 20 if $sliderHandle[:x] > (start + width)
  end

  $sliderValue = ($sliderHandle[:x] - start) / 20
  $sliderValue = $sliderValue.round(0)

  args.outputs.borders << $sliderHandle

  args.outputs.lines << sliderLines
end
