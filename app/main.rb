def tick(args)
  ticks = args.state.tick_count

  args.outputs.labels << {
    x: 80, y: 60, text: ticks,
    size_enum: 3, alignment_enum: 0,
    r: 200, g: 050, b: 100, a: 125 }
end
