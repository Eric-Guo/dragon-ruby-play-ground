def tick(a)
  o = a.outputs
  o.background_color = [0] * 3
  27.times do |i|
    v = i + a.state.tick_count / 60
    s = Math.sin(v)
    s2 = 2 * Math.sin(v + 1)
    p = (0..8).map do |n|
      z = ((n / 4).to_i % 2 - 7 + s) / 600
      [(n % 2 - 5 + i % 9) / z + 640, ((n / 2).to_i % 2 + s2) / z + 360]
    end
    o.lines << p.combination(2).map do |k, l|
      [*k, *l, i * 36, (i * s * 9), (i * s2 * 9)]
    end
  end
end
