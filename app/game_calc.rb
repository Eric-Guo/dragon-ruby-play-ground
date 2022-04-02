# frozen_string_literal: true

class Game
  def calc
    if state.god_mode == :enabled
      state.camera.car_x = state.x
      state.camera.car_y = state.y
      return
    end
    return if state.won

    state.clock += 1
    calc_camera
    calc_steering
    calc_physics
    calc_smoke
    calc_car
    calc_game_over
    calc_prism_stones
  end

  def calc_camera
    state.camera.target_center_x = -((state.angle_r.to_degrees + 90).vector_x * 340)
    state.camera.target_center_y = ((state.angle_r.to_degrees + 90).vector_y * 260)
    state.camera.center_x += (state.camera.target_center_x - state.camera.center_x) * 0.01
    state.camera.center_y += (state.camera.target_center_y - state.camera.center_y) * 0.01
    target_x = state.x - (state.angle_r.to_degrees + 90).vector_x * sprites_car.w
    target_y = state.y - (state.angle_r.to_degrees + 90).vector_y * sprites_car.h
    dx = target_x - state.camera.car_x
    dy = target_y - state.camera.car_y
    movement_speed = state.death_at.elapsed_time(state.clock).fdiv(30)**2
    movement_speed = 1.0 if movement_speed > 1.0
    state.camera.car_x += dx * 0.05 * movement_speed if dx.abs > 1
    state.camera.car_y += dy * 0.05 * movement_speed if dy.abs > 1
  end

  def calc_steering
    steer_speed = steering_wheel_delta * state.turn_magnitude.abs

    # steering improves when auto breaking
    if auto_break?
      steer_speed *= 3.0
      state.auto_break_at = state.clock
    end

    case state.steering
    when :right
      state.steer_angle_r = state.steer_angle_r - steer_speed if state.steer_angle_r > state.steering_wheel_range * -1.0
    when :left
      state.steer_angle_r = state.steer_angle_r + steer_speed if state.steer_angle_r < state.steering_wheel_range
    when :released
      if state.drift_mode == :off
        if state.steer_angle_r.negative?
          state.steer_angle_r = state.steer_angle_r + steering_wheel_delta * state.steering_wheel_reset_perc
        elsif state.steer_angle_r.positive?
          state.steer_angle_r = state.steer_angle_r - steering_wheel_delta * state.steering_wheel_reset_perc
        end
      end
    end

    state.steer_angle_r = state.steer_angle_r.round(4).to_f
  end

  def auto_break?
    return false if state.drift_mode == :on

    # auto break if player is counter steering hard in the opposite direction of the car
    if    state.steering == :left  && state.steer_angle_r <= state.auto_break_steering_threshold * -1
      return true
    elsif state.steering == :right && state.steer_angle_r >= state.auto_break_steering_threshold
      return true
    end

    false
  end

  def calc_physics
    target_speed = if state.gear == :high
                     state.high_speed
                   else
                     state.low_speed
                   end

    if auto_break?
      state.speed *= state.auto_break_speed_degredation
    else
      ds = target_speed - state.speed
      state.speed += ds * state.acceleration_deceleration_ratio
    end

    state.speed = state.min_speed if state.speed < state.min_speed

    if state.drift_mode == :on
      if    state.steer_angle_r.positive?
        state.drift_percentage_right *= state.momentum_toward_normal
        state.drift_percentage_left  *= state.momentum_away_from_normal
      elsif state.steer_angle_r.negative?
        state.drift_percentage_right *= state.momentum_away_from_normal
        state.drift_percentage_left  *= state.momentum_toward_normal
      else
        state.drift_percentage_right *= state.momentum_decay_out_of_drift
        state.drift_percentage_left  *= state.momentum_decay_out_of_drift
      end
    else
      state.drift_percentage_right   *= state.momentum_decay_out_of_drift
      state.drift_percentage_left    *= state.momentum_decay_out_of_drift
    end

    if state.drift_mode == :on && state.drift_percentage_right < state.drift_minimum
      state.drift_percentage_right  = state.drift_minimum
    end
    if state.drift_mode == :on && state.drift_percentage_left < state.drift_minimum
      state.drift_percentage_left   = state.drift_minimum
    end

    state.drift_percentage_right  = state.drift_maximum if state.drift_percentage_right > state.drift_maximum
    state.drift_percentage_left   = state.drift_maximum if state.drift_percentage_left  > state.drift_maximum

    state.drift_percentage_right  = state.drift_percentage_right.round(4)
    state.drift_percentage_left   = state.drift_percentage_left.round(4)
  end

  def calc_smoke
    state.smoke.each do |p|
      p.w += 4
      p.h += 4
      p.x -= 2
      p.y -= 2
      p.x -= p.dx
      p.y -= p.dy
      p.a -= 2
    end
    state.smoke.reject! { |p| p.a <= 0 }
    return unless state.tick_count.zmod?(6)

    if state.drift_mode == :on
      state.smoke << sprites_smoke_new
    elsif auto_break?
      state.smoke << (sprites_smoke_new smoke_speed_ratio: 0.1)
    end
  end

  def sprites_smoke_new(smoke_speed_ratio: 0.25)
    angle = 90 + (state.angle_r.to_degrees * -1)
    sprites_car.merge x: state.x - state.sprite.width / 2 - angle.vector_x * state.sprite.width * 0.75,
                      y: state.y - state.sprite.height / 2 - angle.vector_y * state.sprite.height * 0.75 + sprites_car.h / 2,
                      dx: angle.vector_x * smoke_speed_ratio,
                      dy: angle.vector_y * smoke_speed_ratio,
                      angle: angle,
                      a: 255,
                      path: "sprites/smoke-#{(state.tick_count % 10 % 3) + 1}.png"
  end

  def calc_car
    velocity_x     = state.speed * Math.sin(state.angle_r + state.steer_angle_r) * (1.0 - state.drift_percentage_right - state.drift_percentage_left)
    velocity_y     = state.speed * Math.cos(state.angle_r + state.steer_angle_r) * (1.0 - state.drift_percentage_right - state.drift_percentage_left)

    normal_x_right = state.speed * Math.sin((PI / 2.0) - state.angle_r) * state.drift_percentage_right
    normal_y_right = state.speed * Math.cos((PI / 2.0) - state.angle_r) * state.drift_percentage_right * -1.0

    normal_x_left  = state.speed * Math.sin((PI / 2.0) - state.angle_r) * state.drift_percentage_left  * -1.0
    normal_y_left  = state.speed * Math.cos((PI / 2.0) - state.angle_r) * state.drift_percentage_left

    state.x       += velocity_x + normal_x_right + normal_x_left
    state.y       += velocity_y + normal_y_right + normal_y_left

    state.angle_r -= state.steer_angle_r
  end

  def calc_prism_stones
    state.deaths.each(&:tick)

    state.checkpoint_markers.each(&:tick)

    state.checkpoint_reached_render_queue.each do |c|
      c.a -= 2
      c.x -= 4
      c.y -= 4
      c.w += 8
      c.h += 8
    end

    state.checkpoint_reached_render_queue.reject! { |c| c.a < 1 }

    state.death_stones_render_queue = state.deaths
                                           .find_all { |c| stone_in_scene? c }
                                           .flat_map do |c|
                                             c.stones.map { |stone| relative_to_car_camera stone }.compact
                                           end.to_a

    state.checkpoint_stones_render_queue = state.checkpoint_markers
                                                .find_all { |c| stone_in_scene? c }
                                                .flat_map do |c|
                                                  c.stones.map { |stone| relative_to_car_camera stone }.compact
                                                end.to_a
  end

  def calc_game_over
    checkpoint_reached = state.checkpoint_rects.find { |c| c.intersect_rect? car_collision_rect }

    if checkpoint_reached && state.last_checkpoint != checkpoint_reached
      state.last_checkpoint = checkpoint_reached
      state.knows_the_controls = true
      state.checkpoint_reached_at = state.tick_count if (state.clock - state.death_at) > 60
      state.checkpoint_reached_render_queue << {
        x: checkpoint_reached.x + 16,
        y: checkpoint_reached.y + 16,
        w: 32,
        h: 32,
        a: 200,
        path: 'sprites/white-stone.png'
      }
    end

    if state.track_rects.length > 1 && (state.track_rects.last.intersect_rect? car_collision_rect)
      state.won = true
      state.won_at = state.tick_count
      state.laps.unshift state.clock.fdiv(60)
      state.last_checkpoint = nil
      if state.clock <= (get_best_time default: state.clock)
        state.new_record = true
        gtk.write_file 'data/best-time.txt', state.clock.to_s
      end

      state.last_checkpoint = nil
      state.clock = 0
      state.death_count = 0
      state.death_at = 0
      reset_game!
    elsif state.track_rects.none? { |c| c.intersect_rect? car_collision_rect }
      state.death_at = state.clock
      state.death_count += 1
      state.deaths.shift if state.deaths.length > 5
      state.deaths << new_prism_stones if state.input_occurred
      if state.last_checkpoint
        reset_game!
      else
        reset_game_full!
      end
    end
  end
end
