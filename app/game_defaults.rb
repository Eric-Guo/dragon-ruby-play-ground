# frozen_string_literal: true

class Game
  def defaults
    defaults_fiddle
    defaults_game
  end

  def defaults_fiddle
    state.sprite.width                        = 34
    state.sprite.height                       = 18
    state.momentum_toward_normal              = 1.04
    state.momentum_away_from_normal           = 0.96
    state.momentum_decay_out_of_drift         = 0.98
    state.momentum_decay_in_drift             = 0.99
    state.drift_minimum                       = 0.1
    state.drift_maximum                       = 0.5
    state.steering_wheel_range                = (PI.fdiv 4).round 4
    state.steering_wheel_delta_in_drift       = 3500.0
    state.steering_wheel_delta_out_of_drift   = 3400.0
    state.steering_wheel_delta_drifting       = (PI.fdiv state.steering_wheel_delta_in_drift).round 4
    state.steering_wheel_delta_not_drifting   = (PI.fdiv state.steering_wheel_delta_out_of_drift).round 4
    state.steering_wheel_reset_perc           = 0.5
    state.camera.scale                        = 1.5
    state.auto_break_speed_degredation        = 0.90
    state.auto_break_steering_threshold       = 0.01
    state.acceleration_deceleration_ratio     = 0.01
    state.min_speed                           = 1.3
    state.turn_magnitude                      = 1.0
  end

  def defaults_game
    return if state.tick_count != 0

    load_map!
    reset_game!
  end

  def reset_game_full!
    reset_persisted!
    reset_game!
  end

  def reset_persisted!
    state.time = 0
    state.death_count = 0
    state.death_at = 0
    state.won = false
    state.won_at = nil
    state.clock = 0
  end

  def reset_game!
    reset_persisted! if state.won

    state.deaths ||= []
    state.deaths.reject! { |d| d.stones.any? { |s| s.lifetime && s.lifetime <= 0 } }
    state.god_mode               = :disabled
    state.x                      = 155
    state.y                      = 730
    state.angle_r                = 0
    state.steering               = :released
    state.steer_angle_r          = 0.0
    state.drift_percentage_right = 0.0
    state.drift_percentage_left  = 0.0
    state.auto_break_at          = nil
    state.drift_mode             = :off
    state.low_speed              = 3
    state.high_speed             = 4
    state.gear                 ||= :low
    state.gear_changed_at        = state.tick_count
    state.clock                ||= 0
    state.death_at             ||= 0
    state.won                    = false
    state.won_at                 = nil
    state.drift_percentage_left  = 0
    state.drift_percentage_right = 0
    state.drift_sound_debounce   = 0
    state.car_after_images       = []
    state.smoke                  = []
    state.laps                 ||= []
    state.death_count          ||= 0
    state.camera.target_center_x = 6160
    state.camera.target_center_y = 5830
    state.camera.center_x ||= 0
    state.camera.center_y ||= 0
    state.camera.car_x    ||= state.x
    state.camera.car_y    ||= state.y
    state.god_mode_edit_target = :track
    state.checkpoint_reached_render_queue = []
    state.new_record = false

    args.state.buttons ||= [
      args.layout.rect(row: 8, col: 0, w: 4, h: 4, merge: { m: :left }),
      args.layout.rect(row: 8, col: 4, w: 4, h: 4, merge: { m: :right }),
      args.layout.rect(row: 8, col: 20, w: 4, h: 4, merge: { m: :drift })
    ]

    state.checkpoint_markers ||= state.checkpoint_points.map do |c|
      new_checkpoint_prism_stones c.x, c.y, :white
    end

    state.gear = :low
    state.speed = 0

    state.input_occurred = false

    if state.last_checkpoint
      state.x = state.last_checkpoint.x + state.sprite.width
      state.y = state.last_checkpoint.y + state.sprite.height
      state.angle_r = state.last_checkpoint.angle_r
    end

    state.best_time = get_best_time default: nil
  end

  def get_best_time(default:)
    best_time   = gtk.read_file 'data/best-time.txt'
    best_time ||= 0
    best_time   = best_time.to_i
    best_time   = default if best_time.zero?
    best_time
  end
end
