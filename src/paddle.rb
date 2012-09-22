class Paddle
  include CollisionMethods

  attr_accessor :width, :height

  def initialize(image_path)
    @image = Image.new(image_path)
    @width = @image.width
    @height = @image.height
    reset!
  end

  def draw
    @image.draw(@x, @y)
  end

  def handle_input(container, delta, input)
    if input.is_key_down(Input::KEY_LEFT) && left > 0
      @x -= 0.3 * delta
    end

    if input.is_key_down(Input::KEY_RIGHT) && right < container.width
      @x += 0.3 * delta
    end
  end

  def reset!
    @x = 200
    @y = 400
  end
end
