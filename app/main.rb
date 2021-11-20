$gtk.reset

def tick(args)
  clear_target = args.state.tick_count.zero? || args.inputs.keyboard.key_down.space
  args.render_target(:accumulation).clear_before_render = clear_target
  args.render_target(:accumulation).lines << {
    x: 640,
    y: 360,
    x2: args.inputs.mouse.x,
    y2: args.inputs.mouse.y,
    r: 0,
    g: 0,
    b: 0,
    a: 255
  }

  args.outputs.sprites << [ 0, 0, 1280, 720, :accumulation]
end
