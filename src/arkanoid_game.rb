require File.dirname(__FILE__) + '/ball'
require File.dirname(__FILE__) + '/paddle'
require File.dirname(__FILE__) + '/collision_methods'

class ArkanoidGame < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Ruby Arkanoid!"
    @bg = Gosu::Image.new(self, "assets/bg.png", true)
    @ball = Ball.new('assets/ball.png', self)
    @paddle = Paddle.new('assets/paddle.png', self)
    @ball.bind_to_paddle! @paddle

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def draw
    @bg.draw(0, 0, ZOrder::Background)
    @ball.draw
    @paddle.draw
    @font.draw("RArkanoid (ESC to exit) x: #{@ball.x.to_i}, y: #{@ball.y.to_i}, angle: #{@ball.angle}", 8, height - 30, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def update
    close if button_down? Gosu::KbEscape

    catch :out_of_bounds do
      @paddle.handle_input
      @ball.update(@paddle)
      return
    end
    @paddle.reset!
    @ball.bind_to_paddle! @paddle
  end
end

module ZOrder
  Background, Ball, Paddle, UI = *0..3
end