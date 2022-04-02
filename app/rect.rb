# frozen_string_literal: true

class Rect
  attr_rect

  attr :angle_r, :r, :g, :b, :a, :primitive_marker

  def initialize(x:, y:, w:, h:, primitive_marker:, angle_r: 0, r: 0, g: 0, b: 0, a: 255)
    @x                = x
    @y                = y
    @w                = w
    @h                = h
    @angle_r          = angle_r
    @r                = r
    @g                = g
    @b                = b
    @a                = a
    @primitive_marker = primitive_marker
  end

  def blendmode_enum
    nil
  end

  def merge(opts)
    Rect.new x: opts.x                || @x,
             y: opts.y                || @y,
             w: opts.w                || @w,
             h: opts.h                || @h,
             angle_r: opts.angle_r || @angle_r,
             r: opts.r                || @r,
             g: opts.g                || @g,
             b: opts.b                || @b,
             a: opts.a                || @a,
             primitive_marker: opts.primitive_marker || @primitive_marker
  end
end
