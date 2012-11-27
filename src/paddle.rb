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
      -8
    elsif @window.button_down?(Gosu::KbRight) && right < @window.width
      8
    else
      0
    end

    @x += delta
    @bound_ball.x += delta if @bound_ball

    release_ball! if @window.button_down?(Gosu::KbSpace)
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

  def angle_from_touched_position(ball)
    bounce_angle_multiplier = bounce_angle_multiplier_from_position(ball)
    edge_hit = bounce_angle_multiplier >= 0.91 || bounce_angle_multiplier <= 0.09

    [(90 * bounce_angle_multiplier) + if ball.touching_top_left?(self)
      90
    elsif ball.touching_top_right?(self)
      0
    elsif ball.touching_bottom_left?(self)
      180
    else
      270  # bottom right
    end, edge_hit]
  end

  def bounce_angle_multiplier_from_position(ball)
    percentage_of_distance_to_edge_from_middle = (mid_x - ball.mid_x) / (width.to_f / 2)

    if percentage_of_distance_to_edge_from_middle < 0
      [0.05, 1 + percentage_of_distance_to_edge_from_middle].max
    else
      [percentage_of_distance_to_edge_from_middle, 0.95].min
    end
  end
end