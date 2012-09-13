require 'src/collision_methods'

class Ball
  include CollisionMethods

  attr_accessor :angle, :x, :y

  def initialize(image_path, container)
    @image = Image.new(image_path)
    @width = @image.width
    @height = @image.height
    @container = container
    reset!
  end

  def draw
    @image.draw(@x, @y)
  end

  def update(container, delta, paddle)
    @container = container
    @x += 0.3 * delta * Math.cos(@angle * Math::PI / 180)
    @y -= 0.3 * delta * Math.sin(@angle * Math::PI / 180)

    @angle = if @last_touched == touching_wall
      @angle
    elsif touching_any_wall?
      (360 + (2 * wall_angle) - @angle) % 360
    else
      @angle
    end

    @last_touched = touching_wall

    if out_of_bounds?
      paddle.reset!
      reset!
    end

    if touching?(paddle)
      @angle = angle_from_touched_position(paddle)
    end
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

  def angle_from_touched_position(paddle)
    rand(90) + if touching_top_left?(paddle)
      90
    elsif touching_top_right?(paddle)
      0
    elsif touching_bottom_left?(paddle)
      180
    else
      270  # bottom right
    end
  end

  def out_of_bounds?
    top > @container.height + 30  # add some room to see the ball disappear
  end

  def touching_container_right_side?
    right > @container.width
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

  def reset!
    @x = 200
    @y = 200
    @angle = 45
    @last_touched = nil
  end
end
