# frozen_string_literal: true

class Game
  def render
    outputs.background_color = [0, 0, 0]
    # render_won
    render_game
    render_mobile_controls
    render_instructions
    outputs.debug << { x: 1280 - 60, y: 60, text: gtk.current_framerate.to_sf.to_s, r: 255, g: 255, b: 255 }
  end

  def render_mobile_controls
    return unless gtk.platform? :mobile

    args.outputs.borders << args.state.buttons.map { |b| b.merge(r: 255, g: 255, b: 255, a: 80) }
  end

  def render_won
    return unless state.won

    outputs.labels << { x: 640, y: 380, text: 'you win!', size_enum: 5, alignment_enum: 1, r: 255, g: 255, b: 255 }
    outputs.labels << if state.new_record
                        { x: 640, y: 340, text: "time: #{format('%.2f', (state.clock.fdiv 60))}s (new record)", size_enum: 5,
                          r: 255, g: 255, b: 255, alignment_enum: 1 }
                      else
                        { x: 640, y: 340, text: "time: #{format('%.2f', (state.clock.fdiv 60))}s", size_enum: 5, r: 255,
                          g: 255, b: 255, alignment_enum: 1 }
                      end
    outputs.labels << if state.death_count.positive?
                        { x: 640, y: 300, text: "deaths: #{state.death_count.to_i}", size_enum: 5, r: 255, g: 255,
                          b: 255, alignment_enum: 1 }
                      else
                        { x: 640, y: 300, text: 'deaths: flawless victory', size_enum: 5, r: 255, g: 255, b: 255,
                          alignment_enum: 1 }
                      end

    outputs.labels << if gtk.platform? :mobile
                        { x: 640, y: 260, text: '(tap to go again)', size_enum: 5, r: 255, g: 255, b: 255,
                          alignment_enum: 1 }
                      else
                        { x: 640, y: 260, text: "(press 'r' to go again)", size_enum: 5, r: 255, g: 255, b: 255,
                          alignment_enum: 1 }
                      end
  end

  def render_god_mode
    return if state.won
    return if state.god_mode != :enabled

    outputs[:scene].borders << if state.god_mode_edit_target == :track
                                 { x: inputs.mouse.x - 30, y: inputs.mouse.y - 30, w: 60, h: 60, g: 255 }
                               else
                                 { x: inputs.mouse.x - 30, y: inputs.mouse.y - 30, w: 60, h: 60, r: 200, b: 255 }
                               end

    track_rects_alpha = 255
    checkpoint_rects_alpha = 80
    if state.god_mode_edit_target == :checkpoint
      track_rects_alpha = 80
      checkpoint_rects_alpha = 255
    end

    outputs[:scene].borders << state.track_rects.map do |t|
      relative_to_car_camera t.merge(g: 255, a: track_rects_alpha)
    end
    outputs[:scene].borders << state.checkpoint_rects.map do |c|
      relative_to_car_camera c.merge(r: 200, b: 255, a: checkpoint_rects_alpha)
    end
    outputs[:scene].borders << (relative_to_car_camera car_collision_rect)
    outputs[:scene].labels << if inputs.keyboard.x
                                { x: 30, y: 30.from_top, r: 255, g: 0, b: 0,
                                  text: "editing: #{state.god_mode_edit_target}" }
                              else
                                { x: 30, y: 30.from_top, r: 255, g: 255, b: 255,
                                  text: "editing: #{state.god_mode_edit_target}" }
                              end

    outputs[:scene].primitives << state.checkpoint_rects.map do |c|
      relative_to_car_camera sprites_car.merge(x: c.x + state.sprite.width / 2,
                                               y: c.y + state.sprite.height,
                                               g: 0,
                                               a: 128,
                                               angle: 90 - c.angle_r.to_degrees)
    end
  end

  def sprites_headlights
    { x: 0, y: 0, w: 408, h: 216, path: 'sprites/headlights.png' }
  end

  def sprites_spotlight
    # { x: 0, y: 0, w: 100, h: 100, path: :pixel, r: 0, g: 0, b: 0 }
    { x: 0, y: 0, w: 400, h: 400, path: 'sprites/spotlight.png' }
  end

  def sprites_brakelights
    { x: 0, y: 0, w: 40, h: 60, path: 'sprites/brakelights.png', a: 80 }
  end

  def render_lighted_scene
    outputs[:lighted_scene].w = 2560
    outputs[:lighted_scene].h = 1440
    outputs[:lighted_scene].background_color = [0, 0, 0, 0]

    args.outputs[:lighted_scene].sprites << { x: 0, y: 0, w: 2560, h: 1440, path: :lights, blendmode_enum: 0 }
    args.outputs[:lighted_scene].sprites << { x: 0, y: 0, w: 2560, h: 1440, path: :scene, blendmode_enum: 2 }
  end

  def render_lights
    outputs[:lights].w = 2560
    outputs[:lights].h = 1440
    outputs[:lights].background_color = [0, 0, 0, 0]

    outputs[:lights].primitives << state.death_stones_render_queue.map do |s|
      s.merge(x: s.x - s.w / 2,
              y: s.y - s.h / 2,
              w: s.w * 2,
              h: s.h * 2,
              r: 0,
              g: 0,
              b: 0)
    end

    outputs[:lights].primitives << state.checkpoint_stones_render_queue.map do |s|
      s.merge(x: s.x - s.w / 2,
              y: s.y - s.h / 2,
              w: s.w * 2,
              h: s.h * 2,
              r: 0,
              g: 0,
              b: 0)
    end

    car_center = { x: 640, y: 360 }

    outputs[:car_lights].background_color = [0, 0, 0, 0]
    outputs[:car_lights].sprites << sprites_spotlight.merge(x: car_center.x - sprites_spotlight.w / 2,
                                                            y: car_center.y - sprites_spotlight.h / 2,
                                                            angle: 0)

    args.outputs[:car_lights].sprites << sprites_headlights.merge(x: car_center.x + sprites_car.w / 2,
                                                                  y: car_center.y - sprites_headlights.h / 2, a: (state.clock - state.death_at))
    outputs[:lights].primitives << relative_to_car_camera(x: state.x - 640, y: state.y - 320 - sprites_car.h * 2, w: 1280, h: 720,
                                                          angle: 90 - state.angle_r.to_degrees,
                                                          path: :car_lights)

    outputs[:lights].primitives << { x: 0, y: 0, w: 2560, h: 1440, path: :pixel, a: 32, r: 0, g: 0, b: 0 }

    outputs[:lights].primitives << state.checkpoint_reached_render_queue.map do |c|
      relative_to_car c.merge(r: 0, g: 0, b: 0)
    end
  end

  def stone_in_scene?(s)
    return false if (s.center.x - state.camera.car_x).abs > 740
    return false if (s.center.y - state.camera.car_y).abs > 420

    true
  end

  def render_scene
    car_center = { x: 640, y: 360 }

    args.outputs[:car].background_color = [0, 0, 0, 0]
    local_sprite_car = sprites_car
    local_sprite_car.w_half = local_sprite_car.w / 2
    local_sprite_car.h_half = local_sprite_car.h / 2

    local_sprites_brakelights = sprites_brakelights
    local_sprites_brakelights.w_half = local_sprites_brakelights.w / 2
    local_sprites_brakelights.h_half = local_sprites_brakelights.h / 2

    a = 80
    if state.auto_break_at &&
       state.clock &&
       state.speed < 2.9 &&
       state.auto_break_at.elapsed_time(state.clock) < 30
      a = 255
    end

    args.outputs[:car].sprites << local_sprites_brakelights.merge(x: car_center.x - local_sprite_car.w_half - local_sprites_brakelights.w_half - 2,
                                                                  y: car_center.y - local_sprites_brakelights.h_half, a: a)

    args.outputs[:car].sprites << local_sprite_car.merge(x: car_center.x - local_sprite_car.w_half,
                                                         y: car_center.y - local_sprite_car.h_half,
                                                         angle: 0)

    args.outputs[:car].sprites << local_sprites_brakelights.merge(x: car_center.x - local_sprite_car.w_half - local_sprites_brakelights.w_half - 2,
                                                                  y: car_center.y - local_sprites_brakelights.h_half, a: 80)

    outputs[:scene].w = 2560
    outputs[:scene].h = 1440
    outputs[:scene].background_color = [0, 0, 0, 0]
    outputs[:scene].primitives << sprites_map_viewport

    render_god_mode

    outputs[:scene].primitives << state.checkpoint_stones_render_queue

    outputs[:scene].primitives << relative_to_car_camera(x: state.x - 640, y: state.y - 320 - local_sprite_car.h * 2, w: 1280, h: 720,
                                                         angle: 90 - state.angle_r.to_degrees,
                                                         path: :car, a: (state.clock - state.death_at))

    outputs[:scene].primitives << state.smoke.map { |smoke| relative_to_car_camera smoke }

    outputs[:scene].primitives << state.death_stones_render_queue
    outputs[:scene].primitives << state.checkpoint_reached_render_queue.map { |c| relative_to_car_camera c }
  end

  def render_game
    outputs.background_color = [0, 0, 0]

    return if state.won

    render_scene
    render_lights
    render_lighted_scene

    return if Kernel.global_tick_count.zero?

    outputs.sprites << if state.god_mode == :enabled
                         { x: 0,
                           y: 0,
                           w: 2560,
                           h: 1440,
                           path: :scene }
                       else
                         { x: 0 + sprites_scene_offset_x,
                           y: 0 + sprites_scene_offset_y,
                           w: 2560 * state.camera.scale,
                           h: 1440 * state.camera.scale,
                           path: :lighted_scene }
                       end

    outputs.primitives << if state.best_time
                            { x: 10, y: 10.from_top, r: 255, g: 255, b: 255,
                              text: "best: #{state.best_time.fdiv(60).to_sf}s" }
                          else
                            { x: 10, y: 10.from_top, r: 255, g: 255, b: 255, text: 'best: --' }
                          end

    laps_and_current = [state.clock.fdiv(60)] + state.laps
    outputs.primitives << laps_and_current.map_with_index do |l, i|
      y = (30 + i * 20).from_top
      a = (((y - 320) / 320) * 255).clamp(0, 180)
      lap_number = (laps_and_current.length - i)
      if lap_number < 10
        { x: 10, y: y, r: 255, g: 255, b: 255, text: "lap  #{lap_number}: #{l.to_sf}s", a: a }
      else
        { x: 10, y: y, r: 255, g: 255, b: 255, text: "lap #{lap_number}: #{l.to_sf}s", a: a }
      end
    end
  end

  def render_instructions
    return if gtk.platform? :mobile
    return if state.knows_the_controls

    outputs.labels << { x: 10,
                        y: 80,
                        text: 'turn:    LEFT/RIGHT',
                        size_enum: 0,
                        alignment_enum: 0,
                        a: 128,
                        r: 255,
                        g: 255,
                        b: 255 }

    outputs.labels << { x: 10,
                        y: 55,
                        text: 'drift:   SPACE',
                        size_enum: 0,
                        alignment_enum: 0,
                        a: 128,
                        r: 255,
                        g: 255,
                        b: 255 }
  end

  def sprites_car
    {
      x: -state.sprite.width / 2,
      y: -state.sprite.height / 2,
      w: state.sprite.width,
      h: state.sprite.height,
      path: 'sprites/86.png',
      angle: 90 + (state.angle_r.to_degrees * -1),
      rotation_anchor_x: 0.7,
      rotation_anchor_y: 0.5
    }
  end

  def sprites_map
    {
      x: 0,
      y: 0,
      w: 6400,
      h: 6400,
      path: 'sprites/map.png'
    }
  end

  def sprites_scene_offset_x
    -((1280 * state.camera.scale) - 1280).half - state.camera.center_x
  end

  def sprites_scene_offset_y
    -((720 * state.camera.scale) - 720).half - state.camera.center_y
  end

  def sprites_map_viewport
    x = 0
    y = 0
    w = 2560
    h = 1440
    source_x = state.camera.car_x - 640
    source_y = state.camera.car_y - 360

    if state.camera.car_x < 640
      source_x = 0
      x = 640 - state.camera.car_x
    end

    if state.camera.car_y < 720
      source_y = 0
      y = 360 - state.camera.car_y
    end

    x_offset = 6400 - (state.camera.car_x - 640)
    w = x_offset if x_offset < 2560

    y_offset = 6400 - (state.camera.car_y - 360)
    h = y_offset if y_offset < 1440

    {
      x: x,
      y: y,
      w: w,
      h: h,
      source_x: source_x,
      source_y: source_y,
      source_w: 2560,
      source_h: 1440,
      path: 'sprites/map.png'
    }
  end
end

$gtk.reset_sprite 'sprites/headlights.png'
