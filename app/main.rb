# frozen_string_literal: true

class Button
  attr_accessor :text

  def initialize(x, y, text)
    @x = x
    @y = y
    @w = 65
    @h = -65
    @text = text
    @color = [245, 245, 220]
  end

  def show
    [[@x, @y, @w, @h, @color].solid, [@x + 20, @y - 10, @text, 12].label]
  end

  def clicked?
    (@x..(@x + @w)).include?($gtk.args.inputs.mouse.x) &&
      ((@y + @h)..@y).include?($gtk.args.inputs.mouse.y)
  end
end

class Calculator
  VALUES = [['7', '8', '9', '*'],
            ['4', '5', '6', '/'],
            ['1', '2', '3', '-'],
            ['0', '.', '=', '+']].freeze
  def initialize
    @x = 426
    @y = 90
    @w = 426
    @h = 540
    @unit_color = [123, 123, 110]
    @operand1 = ''
    @operand2 = ''
    @operation = ''
    @clear_next = false
    @buttons = generate_buttons
    @display_text = '0'
  end

  def show
    [[@x, @y, @w, @h, @unit_color].solid, @buttons.map(&:show),
     [500, 550, 275, -65, [56, 93, 56]].solid,
     [500 + 270, 550 - 20, '8.8.8.8.8.8.8.8.8.8.8.', 3, 2, [0, 0, 0, 35],
      '/fonts/DSEG7ModernMini-Regular.ttf'].label,
     [500 + 270, 550 - 20, @display_text, 3, 2, [0, 0, 0, 255],
      '/fonts/DSEG7ModernMini-Regular.ttf'].label]
  end

  def check_buttons
    @buttons.each do |b|
      next unless b.clicked?

      case b.text
      when ('0'..'9') then handle_digit(b.text)
      when '.' then @display_text += '.' unless @display_text.include? '.'
      when '=' then calculate
      else handle_operation(b.text)
      end
    end
  end

  private

  def handle_digit(digit)
    return if @display_text == '0' && digit == '0'

    @display_text = '' if @display_text == '0' || @clear_next
    return if @display_text.size > 10

    @clear_next = false
    @display_text += digit
  end

  def handle_operation(operation)
    @operation = operation
    @clear_next = true
    @operand1 = @display_text
  end

  def calculate
    @operand2 = @display_text
    @display_text = eval("#{@operand1} #{@operation} #{@operand2}").to_s[0, 12]
    @clear_next = true
    @operand1 = ''
    @operand2 = ''
    @operation = ''
  end

  def generate_buttons
    VALUES.flat_map.with_index do |row, y|
      row.map.with_index do |val, x|
        Button.new(500 + (x * 70), 450 - (y * 70), val)
      end
    end
  end
end

$calculator = Calculator.new
def tick(args)
  args.solids << [0, 0, 1280, 720, [23, 23, 23]]
  args.primitives << $calculator.show
  $calculator.check_buttons if args.inputs.mouse.click
end
