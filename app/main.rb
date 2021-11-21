# frozen_string_literal: true

$gtk.reset
R = 340
N = 72 * 3

def tick(args)
  (0..N).each do |i|
    theta = 2 * Math::PI * (i / N)
    y = R * Math.sin(theta)
    x = R * Math.cos(theta)
    y2 = R * Math.sin(2 * theta)
    x2 = R * Math.cos(2 * theta)
    args.outputs.lines << {
      x: x + 640,
      y: y + 360,
      x2: x2 + 640,
      y2: y2 + 360,
      r: 0,
      g: 0,
      b: 0,
      a: 255
    }
  end
end
