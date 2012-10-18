class Paddle
  include CollisionMethods

  attr_accessor :width, :height

  def initialize(image_path, window)
    @image = Gosu::Image.new(window, image_path, false)
    @width = @image.width
    @height = @image.height
    @window = window
    reset!
  end

  def draw
    @image.draw(@x, @y, ZOrder::Paddle)
  end

  def handle_input
    if @window.button_down?(Gosu::KbLeft) && left > 0
      @x -= 5
    end

    if @window.button_down?(Gosu::KbRight) && right < @window.width
      @x += 5
    end
  end

  def reset!
    @x = 200
    @y = 400
  end
end
