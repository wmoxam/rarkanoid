require 'src/ball'
require 'src/paddle'
require 'src/collision_methods'

class ArkanoidGame < BasicGame
  def render(container, graphics)
    @bg.draw(0, 0)
    @ball.draw
    @paddle.draw
    graphics.draw_string("RArkanoid (ESC to exit) x: #{@ball.x.to_i}, y: #{@ball.y.to_i}, angle: #{@ball.angle}", 8, container.height - 30)
  end

  def init(container)
    @bg = Image.new('assets/bg.png')
    @ball = Ball.new('assets/ball.png', container)
    @paddle = Paddle.new('assets/paddle.png')
  end

  def update(container, delta)
    input = container.get_input
    container.exit if input.is_key_down(Input::KEY_ESCAPE)

    @paddle.handle_input(container, delta, input)
    @ball.update(container, delta, @paddle)
  end
end

