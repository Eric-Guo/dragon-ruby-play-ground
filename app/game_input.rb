# frozen_string_literal: true

class Game
  def input
    input_game_over
    input_game
    input_god_mode
  end

  def input_game_over
    return unless state.won
    return if state.won_at && state.won_at.elapsed_time < 60

    reset_game! if inputs.mouse.click
  end

  def input_gear
    gear = nil

    if args.inputs.keyboard.key_down.up || args.inputs.keyboard.key_down.h
      gear = :high
    elsif args.inputs.keyboard.key_down.down || args.inputs.keyboard.key_down.l
      gear = :low
    end

    if gear && state.gear != gear
      state.gear = gear
      state.gear_changed_at = state.tick_count
    end

    if gtk.platform? :mobile && inputs.finger_right
      b = args.state.buttons.find { |b| inputs.finger_right.inside_rect? b }
      args.outputs.primitives << b.border!(r: 255, g: 255, b: 255, a: 255) if b

      drift_down = false
      if b && b.m == :speed && (state.gear_changed_at.elapsed_time > 60)
        state.gear = if state.gear == :low
                       :high
                     else
                       :low
                     end
        state.gear_changed_at = state.tick_count
      end
    end
  end

  def input_game
    if inputs.keyboard.key_down.r
      state.last_checkpoint = nil
      state.clock = 0
      state.death_count = 0
      state.death_at = 0
      reset_game!
    end

    input_gear

    return if state.clock - state.death_at < 30

    turn_magnitude = 1.0

    if inputs.controller_one.left_analog_x_perc.abs.positive?
      turn_magnitude = inputs.controller_one.left_analog_x_perc * 1.15
    end

    drift_down      = !inputs.keyboard.space.nil?    ||
                      !inputs.controller_one.r1.nil? ||
                      !inputs.controller_one.r2.nil?

    left_down       = !inputs.left.nil?  || !inputs.keyboard.j.nil?
    right_down      = !inputs.right.nil? || !inputs.keyboard.k.nil?

    state.turn_magnitude = turn_magnitude

    if gtk.platform? :mobile
      if inputs.finger_left
        b = args.state.buttons.find { |b| inputs.finger_left.inside_rect? b }
        args.outputs.primitives << b.border!(r: 255, g: 255, b: 255, a: 255) if b
        if b && b.m == :left
          state.input_occurred = true
          left_down = true
          right_down = false
        elsif b && b.m == :right
          state.input_occurred = true
          left_down = false
          right_down = true
        end
      end

      if inputs.finger_right
        b = args.state.buttons.find { |b| inputs.finger_right.inside_rect? b }
        args.outputs.primitives << b.border!(r: 255, g: 255, b: 255, a: 255) if b

        drift_down = false
        if b && b.m == :drift
          state.input_occurred = true
          drift_down = true
        end
      end
    end

    if left_down
      state.input_occurred = true
      state.steering = :left
    elsif right_down
      state.input_occurred = true
      state.steering = :right
    else
      state.steering = :released
    end

    if drift_down
      state.input_occurred = true
      state.drift_mode = :on
    else
      state.drift_mode = :off
    end
  end

  def input_god_mode
    input_god_mode_enabled
    input_god_mode_toggle
  end

  def input_god_mode_enabled
    return if state.god_mode != :enabled

    input_god_mode_enabled_mouse
    input_god_mode_enabled_keyboard
  end

  def input_god_mode_enabled_mouse
    return unless inputs.mouse.click

    case state.god_mode_edit_target
    when :track
      if inputs.keyboard.x
        to_delete = state.track_points.find do |r|
          inputs.mouse.inside_rect?(relative_to_car(x: r.x - 30, y: r.y - 30, w: 60, h: 60))
        end

        if to_delete
          state.track_points.reject! { |p| p.x == to_delete.x && p.y == to_delete.y }
          state.track_rects = state.track_points.map do |p|
            Rect.new x: p.x - 30, y: p.y - 30, w: 60, h: 60, primitive_marker: :border
          end
          save_map!
        end
      else
        point = [inputs.mouse.x + state.x - 640, inputs.mouse.y + state.y - 360]
        state.track_points << point
        state.track_rects = state.track_points.map do |p|
          Rect.new x: p.x - 30, y: p.y - 30, w: 60, h: 60, primitive_marker: :border
        end
        state.x = point.x
        state.y = point.y
        save_map!
      end
    when :checkpoint
      if inputs.keyboard.x
        to_delete = state.checkpoint_points.find do |r|
          inputs.mouse.inside_rect?(relative_to_car(x: r.x - 30, y: r.y - 30, w: 60, h: 60))
        end

        if to_delete
          state.checkpoint_points.reject! { |p| p.x == to_delete.x && p.y == to_delete.y }
          state.checkpoint_rects = state.checkpoint_points.map do |p|
            Rect.new x: p.x - 30, y: p.y - 30, w: 60, h: 60, angle_r: p.angle_r, primitive_marker: :border
          end
          save_map!
        end
      else
        point = { x: inputs.mouse.x + state.x - 640, y: inputs.mouse.y + state.y - 360, angle_r: state.angle_r }
        state.checkpoint_points << point
        state.checkpoint_rects = state.checkpoint_points.map do |p|
          Rect.new x: p.x - 30, y: p.y - 30, w: 60, h: 60, angle_r: p.angle_r, primitive_marker: :border
        end
        state.x = point.x
        state.y = point.y
        save_map!
      end
    end
  end

  def input_god_mode_enabled_keyboard
    load_map! if inputs.keyboard.key_down.e

    if inputs.keyboard.space
      state.angle_r += inputs.left_right * 0.01
    else
      multiplier = if inputs.keyboard.shift
                     1
                   elsif inputs.keyboard.f
                     10
                   else
                     5
                   end
      if inputs.keyboard.key_down.up ||
         inputs.keyboard.key_down.down ||
         inputs.keyboard.key_held.up ||
         inputs.keyboard.key_held.down
        state.y += inputs.keyboard.up_down * multiplier
      end

      if inputs.keyboard.key_down.left ||
         inputs.keyboard.key_down.right ||
         inputs.keyboard.key_held.left ||
         inputs.keyboard.key_held.right
        state.x += inputs.keyboard.left_right * multiplier
      end
    end

    if inputs.keyboard.key_down.tab
      state.god_mode_edit_target = if state.god_mode_edit_target == :track
                                     :checkpoint
                                   else
                                     :track
                                   end
    end

    if inputs.keyboard.key_down.c
      state.checkpoint_rects = state.checkpoint_points.map do |p|
        r = { x: p.x - 30, y: p.y - 30, w: 60, h: 60, angle_r: p.angle_r }
        r.angle_r = state.angle_r if car_collision_rect.inside_rect? r
        r
      end
      save_map!
    end
  end

  def input_god_mode_toggle
    return unless inputs.keyboard.key_down.g

    state.god_mode = if state.god_mode == :disabled
                       :enabled
                     else
                       :disabled
                     end
  end
end
