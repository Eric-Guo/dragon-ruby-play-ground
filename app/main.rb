# frozen_string_literal: true

def tick(args)
  args.outputs.background_color = [63, 63, 63]
  args.outputs.debug << [10, 720, "FPS #{args.gtk.current_framerate.round}"].label

  clear_target = args.state.tick_count.zero? || args.inputs.keyboard.key_down.space || args.inputs.mouse.click
  args.render_target(:accumulation).clear_before_render = clear_target
  unless args.state.tick_count.zero?
    args.render_target(:accumulation).solids << [args.inputs.mouse.x, args.inputs.mouse.y, 100, 100, rand(255),
                                                 rand(255), rand(255)]
    args.render_target(:accumulation).borders << [args.inputs.mouse.x, args.inputs.mouse.y, 100, 100, rand(255),
                                                  rand(255), rand(255)]
  end

  args.outputs.sprites << [0, 0, 1280, 720, :accumulation]
end
