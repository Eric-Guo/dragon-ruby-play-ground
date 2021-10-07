# frozen_string_literal: true
$t=0
TICK do |a|
  if (t = $t += 1) % 270 == 1
    (X = rand 1280
     Y = rand 720
     A = rand(3) * r = 90
     B = rand(r) + 50
     C = [[q = 220, r, r], [q, s = 150, 5], [r, r, q], [r, s, s]].sample)
  end
  C.x += u = t.sin
  C.y += v = t.cos
  B.times { |n| sld!(X + (w = A + t).sin * n, Y + w.cos * n, (1 + u) * 30 + 5, (1 + v) * 30 + 5, C) }
  (h = a.outputs[:scene]).clear_before_render, h.w, h.h = p
end
