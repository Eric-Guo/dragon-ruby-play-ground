# frozen_string_literal: true

class Point
  attr :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class SimpleSprite
  attr_sprite

  def initialize(x, y, w, h, path, a, r = 255, g = 255, b = 255)
    @x    = x
    @y    = y
    @w    = w
    @h    = h
    @path = path
    @a    = a
    @r    = r
    @g    = g
    @b    = b
  end

  def merge(opts)
    SimpleSprite.new opts.x || @x,
                     opts.y || @y,
                     opts.w || @w,
                     opts.h || @h,
                     @path,
                     @a,
                     opts.r || @r,
                     opts.g || @g,
                     opts.b || @b
  end
end

class StoneSprite
  attr_sprite

  attr :origin_x, :origin_y, :type, :w, :h, :t, :still, :current_t, :lifetime, :spawning

  def initialize(origin_x:, origin_y:, type:, still:, t:, dx:, dy:, dw:, dh:, a:, spawning:)
    @origin_x  = origin_x
    @origin_y  = origin_y
    @x         = origin_x
    @y         = origin_y
    @path      = "sprites/#{type}-stone.png"
    @type      = type
    @still     = still
    @t         = t
    @dx        = dx
    @dy        = dy
    @dw        = dw
    @dh        = dh
    @w         = 32
    @h         = 32
    @a         = a
    @current_t = 0
    @lifetime  = 60 * 60
    @spawning  = spawning
  end

  def tick
    if @spawning
      @x -= @dw / 2
      @y -= @dh / 2
      @w += @dw
      @h += @dh
      @a = ((@t - @current_t).fdiv @t) * 255
      @current_t += 1
      return
    end

    return if @still

    if @current_t == @t
      @x         = @origin_x
      @y         = @origin_y
      @current_t = 0
    else
      @y         += @dy * 3
      @x         += @dx * 3
      @current_t += 1
    end

    @a = ((@t - @current_t).fdiv @t) * 255
  end

  def merge(point)
    SimpleSprite.new point.x, point.y, @w, @h, @path, @a
  end
end

class Marker
  attr :center, :stones

  def initialize(x, y, type, spawn: true)
    @center = Point.new x, y
    if spawn
      @stones = [
        (StoneSprite.new origin_x: x, origin_y: y, type: type, still: true,  t: 60,  dx: 0, dy: 0,    dw: 4 * 8,
                         dh: 4 * 8, a: 255, spawning: true),
        (StoneSprite.new origin_x: x, origin_y: y, type: type, still: true,  t: 240, dx: 0, dy: 0,    dw: 0, dh: 0,
                         a: 255, spawning: false),
        (StoneSprite.new origin_x: x, origin_y: y, type: type, still: false, t: 120, dx: 0, dy: 0.25, dw: 0, dh: 0,
                         a: 0, spawning: false),
        (StoneSprite.new origin_x: x, origin_y: y, type: type, still: false, t: 137, dx: 0, dy: 0.2,  dw: 0, dh: 0,
                         a: 0, spawning: false)
      ]
    else
      @stones = [
        (StoneSprite.new origin_x: x, origin_y: y, type: type, still: true,  t: 240, dx: 0, dy: 0,    dw: 0, dh: 0,
                         a: 255, spawning: false),
        (StoneSprite.new origin_x: x, origin_y: y, type: type, still: false, t: 120, dx: 0, dy: 0.25, dw: 0, dh: 0,
                         a: 0, spawning: false),
        (StoneSprite.new origin_x: x, origin_y: y, type: type, still: false, t: 137, dx: 0, dy: 0.2,  dw: 0, dh: 0,
                         a: 0, spawning: false)
      ]
    end
  end

  def tick
    @stones.each(&:tick)
    @stones.reject! { |s| s.spawning && s.a <= 1 }
  end
end
