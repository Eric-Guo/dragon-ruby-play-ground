def tick(args)
  # https://gist.github.com/amirrajan/83c368bfc4f153abdfba995458d8943a
  defaults(args)
  input(args)
  render(args)
  calc(args)
end

def input(_args)
  if !$gtk.args.inputs.keyboard.key_down.space
    nil
  else
    $state.box.status = if $state.box.status == :moving
                          :stopped
                        else
                          :moving
                        end
  end
end

def render(_args)
  $gtk.args.outputs.primitives << ({ x: $state.box.x, y: $state.box.y, w: $state.box.size,
                                     h: $state.box.size }).merge($state.box.color).to_solid
end

def list_get_random(t)
  t[rand(t.length)]
end

def calc(_args)
  if $state.box.status != :moving
    nil
  else
    $state.box.x = ($state.box.x + $state.box.dx * $state.box.speed)
    $state.box.y = ($state.box.y + $state.box.dy * $state.box.speed)
    if $state.box.x + $state.box.size > $gtk.args.grid.w
      $state.box.x = ($gtk.args.grid.w - $state.box.size)
      $state.box.dx = (-1)
      $state.box.color = (list_get_random($colors))
    elsif $state.box.x.negative?
      $state.box.x = 0
      $state.box.dx = 1
      $state.box.color = (list_get_random($colors))
    end
    if $state.box.y + $state.box.size > $gtk.args.grid.h
      $state.box.y = ($gtk.args.grid.h - $state.box.size)
      $state.box.dy = (-1)
      $state.box.color = (list_get_random($colors))
    elsif $state.box.y.negative?
      $state.box.y = 0
      $state.box.dy = 1
      $state.box.color = (list_get_random($colors))
    end
  end
end

def list_sublist_from_start_from_start(source, at1, at2)
  start = at1
  finish = at2
  source[start..finish]
end

def defaults(_args)
  $state.box.size ||= 50
  $state.box.speed ||= 1
  $state.box.status ||= :moving
  $state.box.x ||= ($gtk.args.grid.w_half - $state.box.size / 2)
  $state.box.y ||= ($gtk.args.grid.h_half - $state.box.size / 2)
  $state.box.dx ||= list_get_random((list_sublist_from_start_from_start([1, -1, nil], 0, 1)))
  $state.box.dy ||= list_get_random((list_sublist_from_start_from_start([1, -1, nil], 0, 1)))
  $state.box.color ||= list_get_random($colors)
end

$colors = []
$colors[0] = { r: 255, g: 0, b: 0, a: 255 }
$colors[1] = { r: 255, g: 165, b: 0, a: 255 }
$colors[2] = { r: 0, g: 255, b: 0, a: 255 }
$colors[3] = { r: 0, g: 0, b: 255, a: 255 }
$colors[4] = { r: 75, g: 0, b: 130, a: 255 }
$colors[5] = { r: 127, g: 0, b: 255, a: 255 }
