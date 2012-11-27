class Block
  include CollisionMethods

  WIDTH = 40
  HEIGHT = 25

  attr_accessor :width, :height, :x, :y

  def initialize(base_dir, config, x, y, window)
  	@tile = Gosu::Image.new(window, base_dir + '/' + config["tile"], true)
  	@x = x
  	@y = y
  	@width = WIDTH # blocks are fixed dimensions
  	@height = HEIGHT
  	@alive = true
  end

  def self.get_block(symbol, x, y, window)
  	config, base_dir = yaml_config(symbol)
  	return nil if config.nil?
  	new(base_dir, config, x, y, window)
  end

  def self.yaml_config(symbol)
  	@@yaml_config ||= {}
  	@@yaml_config[symbol] ||= begin
  	  config_file = "data/blocks/#{symbol}/config.yaml"
  	  return nil unless File.exists?(config_file)

  	  [YAML.load_file(config_file), File.dirname(config_file)]
  	end
  end

  def draw
  	@tile.draw(@x, @y, ZOrder::Block) if drawable?
  end

  def alive?
  	@alive
  end

  def drawable?
  	alive?
  end

  def touch!
  	@alive = false
  end

  def angle_from_touched_position(ball)
    [(360 + (2 * edge_angle(ball)) - ball.angle) % 360, false]
  end

  def edge_angle(ball)
    case touching_edge(ball)
    when :right
      90
    when :left
      270
    when :top
      90
    when :bottom
      180
    end
  end
end