module CollisionMethods
  def touching?(thing)
    touching_x?(thing) && touching_y?(thing) 
  end

  def touching_x?(thing)
    right >= thing.left && left <= thing.right
  end

  def touching_y?(thing)
    bottom >= thing.top && top <= thing.bottom
  end

  def touching_left?(thing)
    right >= thing.left && mid_x <= thing.mid_x && touching_y?(thing)
  end

  def touching_right?(thing)
    mid_x >= thing.mid_x && left <= thing.right && touching_y?(thing)
  end

  def touching_top?(thing)
    bottom >= thing.top && mid_y <= thing.mid_y
  end

  def touching_bottom?(thing)
    mid_y >= thing.mid_y && top <= bottom
  end

  def touching_top_left?(thing)
    touching_left?(thing) && touching_top?(thing)
  end

  def touching_top_right?(thing)
    touching_right?(thing) && touching_top?(thing)
  end

  def touching_bottom_left?(thing)
    touching_left?(thing) && touching_bottom?(thing)
  end

  def touching_bottom_right?(thing)
    touching_right?(thing) && touching_bottom?(thing)
  end

  def mid_x
    @x + (@width / 2)
  end

  def mid_y
    @y + (@height / 2)
  end

  def left
    @x
  end

  def right
    @x + @width
  end

  def top
    @y
  end

  def bottom
    @y + @height
  end
end
