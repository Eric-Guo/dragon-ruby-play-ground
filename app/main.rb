# The text from the gist has been loaded.
# Click the Run game! button to execute the code.

# http://fiddle.dragonruby.org?share=https://gist.github.com/amirrajan/2f63f4d2fc97a81b087e6b4e6bd5bd92

def tick args
    xa = 100 + ((args.state.tick_count) % 300)
    xb = 550 + ((args.state.tick_count/2) % 357)
    xc = 440 + ((args.state.tick_count) % 413)
    xd = 1000 - ((args.state.tick_count / 3) % 988)
    ya = 300 + ((args.state.tick_count) % 351)
    yb = 400 + (args.state.tick_count % 277)
    yc = 700 - (args.state.tick_count % 699)
    yd = 700 - ((args.state.tick_count / 3) % 601)

#   args.outputs.lines << bezier(xa, ya,
#                               xb, yb,
#                               xc, yc,
#                               xd, yd,
#                               0)

  args.outputs.lines << bezier(xa, ya,
                               xb, yb,
                               xc, yc,
                               xd, yd,
                               30)
end


def bezier x1, y1, x2, y2, x3, y3, x4, y4, step
  step ||= 0
  color = [0, 0, 0]
  points = points_for_bezier [x1, y1], [x2, y2], [x3, y3], [x4, y4], step

  points.each_cons(2).map do |p1, p2|
    [*p1, *p2, color]
  end
end

def points_for_bezier p1, p2, p3, p4, step
  if step == 0
    [p1, p2, p3, p4]
  else

    t_step = 1.fdiv(step + 1)
    t = 0
    t += t_step
    points = []
    while t < 1
      points << [
        b_for_t(p1.x, p2.x, p3.x, p4.x, t),
        b_for_t(p1.y, p2.y, p3.y, p4.y, t),
      ]
      t += t_step
    end

    [
      p1,
      *points,
      p4
    ]
  end
end

def b_for_t v0, v1, v2, v3, t
  pow(1 - t, 3) * v0 +
  3 * pow(1 - t, 2) * t * v1 +
  3 * (1 - t) * pow(t, 2) * v2 +
  pow(t, 3) * v3
end

def pow n, to
  n ** to
end


