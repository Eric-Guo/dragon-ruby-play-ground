# frozen_string_literal: true

BOARD_W = 50
BOARD_H = 50

def box_color(num)
  [
    [0, 0, 0, 255],
    [200, 0, 0, 255],
    [0, 200, 0, 255],
    [0, 0, 200, 255],
    [0, 100, 100, 255],
    [100, 0, 200, 255],
    [0, 60, 70, 250],
    [10, 50, 40, 255],
    [60, 0, 50, 255]
  ][num]
end

def tick(args)
  ticks = args.state.tick_count

  board_x = 50
  board_y = 60

  draw_box(args, board_x, board_y, 0, ticks)
  draw_box(args, board_x, board_y, 1, ticks)
  draw_box(args, board_x, board_y, 2, ticks)
  draw_box(args, board_x, board_y, 3, ticks)
  draw_box(args, board_x, board_y, 4, ticks)
  draw_box(args, board_x, board_y, 5, ticks)
  draw_box(args, board_x, board_y, 6, ticks)
  draw_box(args, board_x, board_y, 7, ticks)
  draw_box(args, board_x, board_y, 8, ticks)
end

def lerp(start, stop, step)
  (1.0 - step) * start + step * stop
end

def draw_box(args, board_x, board_y, box_num, ticks)
  box_color = box_color(box_num)

  leap_ticks = lerp(0, 280,
                    (Math.sin(2 * ticks / 200) + 1) / 2)

  case box_num
  when 0
    x = board_x
    y = board_y
  when 1
    x = board_x + leap_ticks * 4
    y = board_y + leap_ticks
  when 2
    x = board_x + leap_ticks * 2
    y = board_y + leap_ticks
  when 3
    x = board_x
    y = board_y + leap_ticks
  when 4
    x = board_x + leap_ticks * 2
    y = board_y
  when 5
    x = board_x + leap_ticks * 4
    y = board_y
  when 6
    x = board_x + leap_ticks * 2
    y = board_y + leap_ticks * 2
  when 7
    x = board_x
    y = board_y + leap_ticks * 2
  when 8
    x = board_x + leap_ticks * 4
    y = board_y + leap_ticks * 2
  end

  args.outputs.borders << [x, y,
                           BOARD_W, BOARD_H] + box_color

  draw_solid(args, x, y, box_color)
end

def draw_solid(args, board_x, board_y, box_color)
  args.outputs.solids << [board_x + 6, board_y + 6,
                          BOARD_W - 12, BOARD_H - 12] + box_color
end
