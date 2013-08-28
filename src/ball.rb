require File.dirname(__FILE__) + '/collision_methods'

class Ball < Chingu::GameObject
  include CollisionMethods

  attr_accessor :angle, :x, :y

  def initialize(image_path)
    @image = Gosu::Image[image_path]
    @width = @image.width
    @height = @image.height
    @state = nil
  end

  def draw
    @image.draw(@x, @y, ZOrder::Ball)
  end

  def update
    super
    
    return if bound_to_paddle?

    @x += @speed * Math.cos(@angle * Math::PI / 180)
    @y -= @speed * Math.sin(@angle * Math::PI / 180)

    @angle = if touching_any_wall? && @last_touched == touching_wall
      case touching_wall
      when :right
        135
      when :left
        45
      when :top
        225
      end
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
    @angle, hit_edge = thing.angle_from_touched_position(self)
    increase_speed!
  end

    def out_of_bounds?
    top > $window.height + 30  # add some room to see the ball disappear
  end

  def max_x
    $window.width
  end

  def min_x
    0
  end

  def touching_container_right_side?
    right >= max_x
  end

  def touching_container_left_side?
    left <= min_x
  end

  def touching_container_top?
    top < 0
  end

  def touching_any_wall?
    !touching_wall.nil?
  end

  def increase_speed!
    return if @speed >= 9
    @speed += 0.5
  end

  def decrease_speed!
    return if @speed <= 3
    @speed -= 0.5
  end

  def bind_to_paddle!(paddle)
    paddle.bound_ball = self

    @state = :bound_to_paddle
    @speed = 0
    @bound_to_paddle = true
    @x = paddle.x + (paddle.width * 3.0 / 5.0)
    @y = paddle.y - (paddle.height / 2) - @height / 2 + 2
    @angle = 45
  end

  def bound_to_paddle?
    @state == :bound_to_paddle
  end

  def unbind_from_paddle!
    @state = nil
    @speed = 5
  end
end
