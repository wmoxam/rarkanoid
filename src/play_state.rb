class PlayState < Chingu::GameState
  attr_accessor :dbg
  
  def initialize
    super
      
    @levels = Level.load_all

    @font = Gosu::Font.new($window, Gosu::default_font_name, 20)

    self.input = {esc: :exit}
  end
  
  def setup
    @level = @levels.first
    @ball = Ball.new('assets/ball.png')
    @paddle = Paddle.new('assets/paddle.png')
    @ball.bind_to_paddle! @paddle
    @paddle.input = { holding_left: :move_left, 
                      holding_right: :move_right,
                      space: :release_ball! }
  end
  
  def draw
    return unless $window
    @level.draw
    @ball.draw
    @paddle.draw
    @font.draw("RArkanoid (ESC to exit) x: #{@ball.x.to_i}, y: #{@ball.y.to_i}, angle: #{@ball.angle}  ::: #{dbg}", 8, $window.height - 30, ZOrder::UI, 1.0, 1.0, 0xffffff00)
    super
  end
  
  def exit
    $window.close
  end

  def update
    super rescue nil
    
    catch :out_of_bounds do
      @ball.update

      @ball.update_angle(@paddle) if @ball.touching?(@paddle)
      @ball.update_angle(@level.last_collided_block) if @level.had_block_collision?(@ball)

      return
    end
    @paddle.reset!
    @ball.bind_to_paddle! @paddle
  end
end