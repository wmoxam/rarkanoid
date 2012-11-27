require File.dirname(__FILE__) + '/ball'
require File.dirname(__FILE__) + '/paddle'
require File.dirname(__FILE__) + '/level'
require File.dirname(__FILE__) + '/block'
require File.dirname(__FILE__) + '/collision_methods'

class ArkanoidGame < Gosu::Window
  attr_accessor :dbg

  def initialize
    super 640, 480, false
    self.caption = "Ruby Arkanoid!"
    
    @levels = Level.load_all(self)
    @level = @levels.first
    @ball = Ball.new('assets/ball.png', self)
    @paddle = Paddle.new('assets/paddle.png', self)
    @ball.bind_to_paddle! @paddle


    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def draw
    @level.draw
    @ball.draw
    @paddle.draw
    @font.draw("RArkanoid (ESC to exit) x: #{@ball.x.to_i}, y: #{@ball.y.to_i}, angle: #{@ball.angle}  ::: #{dbg}", 8, height - 30, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def update
    close if button_down? Gosu::KbEscape

    catch :out_of_bounds do
      @paddle.handle_input
      @ball.update

      @ball.update_angle(@paddle) if @ball.touching?(@paddle)
      @ball.update_angle(@level.last_collided_block) if @level.had_block_collision?(@ball)

      return
    end
    @paddle.reset!
    @ball.bind_to_paddle! @paddle
  end
end

module ZOrder
  Background, Ball, Paddle, Block, UI = *0..4
end