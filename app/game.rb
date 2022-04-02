# frozen_string_literal: true

class Game
  attr_gtk

  def tick
    defaults
    render
    input
    calc
  end

  def steering_wheel_delta
    return state.steering_wheel_delta_drifting if state.drift_mode == :on

    state.steering_wheel_delta_not_drifting
  end

  def car_collision_rect
    {
      x: state.x - 5,
      y: state.y - 5,
      w: 10,
      h: 10,
      r: 255
    }
  end

  def load_map!
    track_points_serialization = gtk.read_file 'data/map.txt'
    state.track_points = track_points_serialization.each_line.map do |l|
      tokens = l.strip.split(',')
      { x: tokens[0].to_i, y: tokens[1].to_i }
    end
    state.track_rects = state.track_points.map { |p| { x: p.x - 30, y: p.y - 30, w: 60, h: 60 } }

    checkpoint_points_serialization = gtk.read_file 'data/checkpoints.txt'
    state.checkpoint_points = checkpoint_points_serialization.each_line.map do |l|
      tokens = l.strip.split(',')
      { x: tokens[0].to_i, y: tokens[1].to_i, angle_r: tokens[2].to_f }
    end

    state.checkpoint_rects = state.checkpoint_points.map do |p|
      { x: p.x - 30, y: p.y - 30, w: 60, h: 60, angle_r: p.angle_r }
    end
  end

  def save_map!
    track_points_serialization = state.track_points.map do |p|
      "#{p.x.to_i},#{p.y.to_i}"
    end
    gtk.write_file 'data/map.txt', track_points_serialization.join("\n")

    checkpoint_points_serialization = state.checkpoint_points.map do |p|
      "#{p.x.to_i},#{p.y.to_i},#{p.angle_r}"
    end

    gtk.write_file 'data/checkpoints.txt', checkpoint_points_serialization.join("\n")
  end

  def relative_to_car_camera(point, dx: 0, dy: 0)
    return nil if !point.x || !point.y

    point.merge x: point.x - state.camera.car_x + 640 + dx,
                y: point.y - state.camera.car_y + 360 + dy
  end

  def relative_to_car(point, dx: 0, dy: 0)
    return nil if !point.x || !point.y

    point.merge x: point.x - state.x + 640 + dx,
                y: point.y - state.y + 360 + dy
  end

  def new_prism_stones(loc_x = state.x, loc_y = state.y, type = %i[green blue teal red yellow].sample)
    loc_x -= 16
    loc_y -= 16
    Marker.new loc_x, loc_y, type
  end

  def new_checkpoint_prism_stones(loc_x = state.x, loc_y = state.y, type = %i[green blue teal red yellow].sample)
    loc_x -= 16
    loc_y -= 16
    Marker.new loc_x, loc_y, type, spawn: false
  end
end
