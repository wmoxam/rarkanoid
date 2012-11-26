class Block
  include CollisionMethods

  WIDTH = 30
  HEIGHT = 20

  attr_accessor :width, :height, :x, :y

  def initialize(base_dir, config, x, y, window)
  	@tile = Gosu::Image.new(window, base_dir + '/' + config["tile"], true)
  	@x = x
  	@y = y
  	@width = WIDTH # blocks are fixed dimensions
  	@height = HEIGHT
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
  	@tile.draw(@x, @y, ZOrder::Block)
  end
end