# frozen_string_literal: true

# self editor
$gtk.reset
$mapfile = '/app/main.rb'
$file_source = $gtk.read_file($mapfile).each_line.to_a
$reload_tick = 0

def tick(args)
  if args.state.tick_count.zero?
    args.state.cursor.row = 0
    args.state.cursor.col = 0
    args.state.cursor.y_offset = $gtk.logical_height
    wide_char = args.gtk.calcstringbox(' ' * 100)
    args.state.char_dims = [wide_char[0] / 100.0, wide_char[1]]
    args.state.cursor.time_moved = 0
    args.state.y_offset = $gtk.logical_height
  end

  process_inputs(args)
  display(args)
  $reload_tick += 1
end

def save_file
  puts 'saving file'
  $gtk.write_file($mapfile, $file_source.join(''))
end

def process_direction_keys(args, key, &proc)
  held_time_elapsed = args.state.tick_count - args.state.cursor.time_moved
  if args.inputs.keyboard.key_down.send(key)
    args.state.cursor.time_moved = args.state.tick_count
    proc.call
  elsif args.inputs.keyboard.key_held.send(key)
    proc.call if held_time_elapsed > 30 && (held_time_elapsed % 5).zero?
    args.state.cursor.held = true
  elsif args.inputs.keyboard.key_up.send(key)
    args.state.cursor.time_moved = args.state.tick_count
  end
end

def apply_shift(key)
  return key.upcase if ('a'..'z').include?(key)

  {
    '1' => '!'
  }.fetch(key, key)
end

def process_save_press(args)
  if (args.inputs.keyboard.key_down.s || args.inputs.keyboard.key_held.s) &&
     (args.inputs.keyboard.key_down.control || args.inputs.keyboard.key_held.control)
    save_file
    return true
  end
  false
end

def process_enter_press(args)
  if args.inputs.keyboard.key_down.enter
    line = current_line(args)

    if args.state.cursor.col >= current_line(args).size - 1
      $file_source.insert(args.state.cursor.row + 1, "\n")
    else
      $file_source[args.state.cursor.row] = "#{line[0..args.state.cursor.col - 1]}\n"
      $file_source.insert(args.state.cursor.row + 1, line[args.state.cursor.col - 1..-1])
    end
    args.state.cursor.row += 1
    args.state.cursor.col = 0
    return true
  end
  false
end

def process_backspace_press(args)
  if args.inputs.keyboard.key_down.backspace
    if args.state.cursor.col.positive?
      current_line(args).tap { |s| s.slice!(args.state.cursor.col - 1) }
      args.state.cursor.col -= 1
    elsif args.state.cursor.row.positive?
      prev_row_len = $file_source[args.state.cursor.row - 1].size
      $file_source[args.state.cursor.row - 1] =
        $file_source[args.state.cursor.row - 1][0...-1] + current_line(args)
      $file_source.delete_at(args.state.cursor.row)
      args.state.cursor.row -= 1
      args.state.cursor.col = prev_row_len - 1
    end
    return true
  end
  false
end

def process_character_press(args)
  if args.inputs.keyboard.key_down.raw_key && args.inputs.keyboard.key_down.raw_key < 127 && args.inputs.keyboard.raw_key >= 32
    curr_char = if args.inputs.keyboard.shift
                  apply_shift(args.inputs.keyboard.key_down.char)
                else
                  args.inputs.keyboard.key_down.char
                end
    if args.state.cursor.col >= current_line(args).size - 1
      current_line(args).insert(current_line(args).size - 1,
                                ' ' * (1 + args.state.cursor.col - current_line(args).size) + curr_char)
    else
      current_line(args).insert(args.state.cursor.col, curr_char)
    end
    args.state.cursor.col += 1
  end
  false
end

def current_line(args)
  $file_source[args.state.cursor.row]
end

def process_direction_press(args)
  args.state.cursor.held = false
  process_direction_keys args, :down do
    args.state.cursor.row += 1
    args.state.y_offset += 200 if computer_cursor_y(args) < 100
  end
  process_direction_keys args, :up do
    args.state.cursor.row = [args.state.cursor.row - 1, 0].max
    args.state.y_offset -= 200 if computer_cursor_y(args) > $gtk.logical_height - 100
  end
  process_direction_keys args, :left do
    args.state.cursor.col = [args.state.cursor.col - 1, 0].max
  end
  process_direction_keys args, :right do
    args.state.cursor.col += 1
  end
end

def process_inputs(args)
  return if $reload_tick < 60
  return if process_direction_press(args)
  return if process_save_press(args)
  return if process_enter_press(args)
  return if process_backspace_press(args)
  return if process_character_press(args)

  args.state.y_offset -= 5 * args.inputs.mouse.wheel.y if args.inputs.mouse.wheel
end

def computer_cursor_y(args)
  args.state.y_offset - (args.state.cursor.row + 1) * args.state.char_dims[1]
end

def display(args)
  left_margin = 30
  cursor_borders = 100

  # draw cursoe
  cursor_x_pos = left_margin + args.state.cursor.col * args.state.char_dims[0]
  cursor_y_pos = computer_cursor_y(args)

  if ((args.state.tick_count - args.state.cursor.time_moved) / 30).to_i.even? || args.state.cursor.held
    args.outputs.solids << {
      x: cursor_x_pos - 2, y: cursor_y_pos,
      w: 3, h: args.state.char_dims[1], r: 255
    }
  end

  # draw text
  curr_y = args.state.y_offset
  $file_source.each do |line|
    curr_y -= args.state.char_dims[1]
    args.outputs.labels << {
      x: left_margin, y: curr_y + args.state.char_dims[1],
      text: line,
      size_enum: args.state.font.size, font: args.state.font.name
    }
  end
end
