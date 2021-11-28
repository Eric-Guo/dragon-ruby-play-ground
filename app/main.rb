# frozen_string_literal: true

def tick(args)
  args.outputs.background_color = [63, 63, 63]
  args.outputs.debug << [10, 720, "FPS #{args.gtk.current_framerate.round}"].label

  $gtk.reset if args.inputs.keyboard.key_down.space || args.inputs.mouse.click

  return if args.state.tick_count.zero?

  args.outputs.static_solids << [args.inputs.mouse.x, args.inputs.mouse.y, 100, 100, rand(255), rand(255), rand(255)]
  args.outputs.static_borders << [args.inputs.mouse.x, args.inputs.mouse.y, 100, 100, rand(255), rand(255), rand(255)]
end
