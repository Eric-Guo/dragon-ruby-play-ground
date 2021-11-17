GRID_SIZE = 20
GRID_WIDTH = $gtk.args.grid.w / GRID_SIZE
GRID_HEIGHT = $gtk.args.grid.h / GRID_SIZE

class Snake
  def initialize
    @direction = :right
    @speed = 20
    @logical_x = GRID_WIDTH / 2
    @logical_y = GRID_HEIGHT / 2
    @length = 0
    @body = []
    @fruit = random_fruit
  end

  def tick(args)
    handle_input(args)
    handle_move(args)
    handle_fruit
  end

  def handle_input(args)
    inputs = args.inputs

    case
    when inputs.right then @direction = :right
    when inputs.left then @direction = :left
    when inputs.up then @direction = :up
    when inputs.down then @direction = :down
    end
  end

  def handle_move(args)
    return unless args.tick_count % @speed == 0

    if @length > @body.length
      @body << head
    elsif @body.length > 0
      @body.shift
      @body << head
    end

    case @direction
    when :right then @logical_x += 1
    when :left then @logical_x -= 1
    when :up then @logical_y += 1
    when :down then @logical_y -= 1
    end
  end

  def handle_fruit
    return unless head == @fruit

    @length += 1
    @speed -= 1
    @fruit = random_fruit
  end

  def random_fruit
    [
      rand(GRID_WIDTH),
      rand(GRID_HEIGHT)
    ]
  end

  def to_p
    [section(head, { r: 0, g: 0, b: 0 })] +
      @body.map { |pos| section(pos) } +
      [section(@fruit, { r: 200, g: 12, b: 12 })]
  end

  def section(pos, color = { r: 12, g: 100, b: 12 })
    { x: pos.x * GRID_SIZE, y: pos.y * GRID_SIZE, w: GRID_SIZE, h: GRID_SIZE }.merge(color).solid!
  end

  def head
    [@logical_x, @logical_y]
  end
end

$snake = Snake.new

def tick(args)
  $snake.tick(args)
  args.outputs.primitives << $snake.to_p
end
