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

  def overlap_right?(thing)
    right < thing.right && right >= thing.left && touching_y?(thing)
  end

  def overlap_left?(thing)
    left > thing.right && left <= thing.left && touching_y?(thing)
  end

  def overlap_top?(thing)
    top <= thing.bottom && top >= thing.top && touching_x?(thing)
  end

  def overlap_bottom?(thing)
    bottom >= thing.top && bottom < thing.bottom && touching_x?(thing)
  end

  # which edge is being touched the most
  def touching_edge(thing)
    { :right  => right_edge_overlap(thing),
      :left   => left_edge_overlap(thing),
      :top    => top_edge_overlap(thing),
      :bottom => bottom_edge_overlap(thing),
    }.max_by {|k,v| v }.first
  end

  def right_edge_overlap(thing)
    return 0 unless overlap_right?(thing)
    [bottom, thing.bottom].min - [top, thing.top].max
  end

  def left_edge_overlap(thing)
    return 0 unless overlap_left?(thing)
    [bottom, thing.bottom].min - [top, thing.top].max
  end

  def top_edge_overlap(thing)
    return 0 unless overlap_top?(thing)
    [right, thing.right].min - [left, thing.left].max
  end

  def bottom_edge_overlap(thing)
    return 0 unless overlap_bottom?(thing)
     [right, thing.right].min - [left, thing.left].max
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
