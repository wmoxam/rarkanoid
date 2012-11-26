require File.dirname(__FILE__) + '/collision_methods'

class Ball
  include CollisionMethods

  attr_accessor :angle, :x, :y

  def initialize(image_path, window)
    @image = Gosu::Image.new(window, image_path, false)
    @width = @image.width
    @height = @image.height
    @window = window
    @state = nil
  end

  def draw
    @image.draw(@x, @y, ZOrder::Ball)
  end

  def update()
    return if bound_to_paddle?

    @x += @speed * Math.cos(@angle * Math::PI / 180)
    @y -= @speed * Math.sin(@angle * Math::PI / 180)

    @angle = if @last_touched == touching_wall
      @angle
    elsif touching_any_wall?
      (360 + (2 * wall_angle) - @angle) % 360
    else
      @angle
    end

    throw :out_of_bounds if out_of_bounds?
    
    @last_touched = touching_wall
  end

  def touching_wall
    if touching_container_right_side?
      :right
    elsif touching_container_left_side?
      :left
    elsif touching_container_top?
      :top
    else
      nil
    end
  end

  def wall_angle
    case touching_wall
    when :right
      90
    when :left
      270
    else # :top
      180
    end
  end

  def update_angle(thing)
    @angle = angle_from_touched_position(thing)
  end

  def angle_from_touched_position(thing)
    bounce_angle_multiplier = bounce_angle_multiplier_from_position(thing)

    if bounce_angle_multiplier >= 0.91 || bounce_angle_multiplier <= 0.09
      increase_speed
    end

    (90 * bounce_angle_multiplier) + if touching_top_left?(thing)
      90
    elsif touching_top_right?(thing)
      0
    elsif touching_bottom_left?(thing)
      180
    else
      270  # bottom right
    end
  end

  def bounce_angle_multiplier_from_position(thing)
    percentage_of_distance_to_edge_from_middle = (thing.mid_x - mid_x) / (thing.width.to_f / 2)

    if percentage_of_distance_to_edge_from_middle < 0
      [0.05, 1 + percentage_of_distance_to_edge_from_middle].max
    else
      [percentage_of_distance_to_edge_from_middle, 0.95].min
    end
  end

  def out_of_bounds?
    top > @window.height + 30  # add some room to see the ball disappear
  end

  def touching_container_right_side?
    right > @window.width
  end

  def touching_container_left_side?
    left < 0
  end

  def touching_container_top?
    top < 0
  end

  def touching_any_wall?
    !touching_wall.nil?
  end

  def increase_speed
    return if @speed >= 9
    @speed += 1
  end

  def decrease_speed
    return if @speed <= 3
    @speed -= 1
  end

  def bind_to_paddle!(paddle)
    paddle.bound_ball = self

    @state = :bound_to_paddle
    @speed = 0
    @bound_to_paddle = true
    @x = paddle.x + ((paddle.width * 3 )/ 4)
    @y = paddle.y - (paddle.height / 2) - @height / 2 + 2
    @angle = 45
    @last_touched = nil
  end

  def bound_to_paddle?
    @state == :bound_to_paddle
  end

  def unbind_from_paddle!
    @state = nil
    @speed = 5
  end
end
