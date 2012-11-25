class Paddle
  include CollisionMethods

  attr_accessor :width, :height, :x, :y

  def initialize(image_path, window)
    @image = Gosu::Image.new(window, image_path, false)
    @width = @image.width
    @height = @image.height
    @window = window
    @bound_ball = nil
    reset!
  end

  # only one ball bound at a time
  def bound_ball=(ball)
    release_ball! if @bound_ball
    @bound_ball = ball
  end

  def draw
    @image.draw(@x, @y, ZOrder::Paddle)
  end

  def handle_input
    delta = if @window.button_down?(Gosu::KbLeft) && left > 0
      -5
    elsif @window.button_down?(Gosu::KbRight) && right < @window.width
      5
    else
      0
    end

    @x += delta
    @bound_ball.x += delta if @bound_ball

    if @window.button_down?(Gosu::KbSpace)
      release_ball!
    end
  end

  def release_ball!
    return unless @bound_ball
    @bound_ball.unbind_from_paddle!
    @bound_ball = nil 
  end

  def reset!
    @x = 200
    @y = 400
  end
end
