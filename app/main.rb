# http://fiddle.dragonruby.org/?tutorial=https://gist.github.com/amirrajan/83c368bfc4f153abdfba995458d8943a

def tick(args)
  defaults args
  render args
  input args
  calc args
end

def defaults(args)
  args.state.colors       = %i[red orange green blue indigo violet]
  args.state.box.size     = 50
  args.state.box.speed    = 2
  args.state.box.x      ||= args.grid.w.half - args.state.box.size.half
  args.state.box.y      ||= args.grid.h.half - args.state.box.size.half
  args.state.box.dx     ||= [1, -1].sample
  args.state.box.dy     ||= [1, -1].sample
  args.state.box.status ||= :moving
  set_box_color args    unless args.state.box.color
end

def render(args)
  args.outputs.sprites << [
    args.state.box.x,
    args.state.box.y,
    args.state.box.size,
    args.state.box.size,
    "sprites/square/#{args.state.box.color}.png"
  ]
end

def input(args)
  return unless args.inputs.keyboard.key_down.space

  args.state.box.status = if args.state.box.status == :moving
                            :stopped
                          else
                            :moving
                          end
end

def calc(args)
  return unless args.state.box.status == :moving

  args.state.box.x += args.state.box.dx * args.state.box.speed
  args.state.box.y += args.state.box.dy * args.state.box.speed

  if (args.state.box.x + args.state.box.size) > args.grid.w
    args.state.box.x  = args.grid.w - args.state.box.size
    args.state.box.dx = -1
    set_box_color args
  elsif args.state.box.x.negative?
    args.state.box.x  = 0
    args.state.box.dx = 1
    set_box_color args
  end

  if (args.state.box.y + args.state.box.size) > args.grid.h
    args.state.box.y  = args.grid.h - args.state.box.size
    args.state.box.dy = -1
    set_box_color args
  elsif args.state.box.y.negative?
    args.state.box.y  = 0
    args.state.box.dy = 1
    set_box_color args
  end
end

def set_box_color(args)
  args.state.box.color = (args.state.colors - [args.state.box.color]).sample
end
