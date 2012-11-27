require 'yaml'

class Level
  attr_accessor :last_collided_block

  def initialize(base_dir, config, window)
  	@background = Gosu::Image.new(window, base_dir + '/' + config["background"], true)
    y = 3
  	@blocks = config["rows"].collect do |row|
      x = 3
      block_row = row.split(//).collect do |symbol|
        block = Block.get_block(symbol, x, y, window)
        x += Block::WIDTH + 3
        block
      end

      y += Block::HEIGHT + 3

      block_row 
    end.flatten.compact

    @last_collided_block = nil
  end

  def self.load_all(window)
  	Dir["data/levels/*/config.yaml"].collect do |config_file|
  	  new(File.dirname(config_file), YAML.load_file(config_file), window)
    end
  end

  def draw
  	@background.draw(0, 0, ZOrder::Background)
    @blocks.each(&:draw)
  end

  def had_block_collision?(ball)
    @blocks.select(&:alive?).each do |block|
      if ball.touching?(block)
        block.touch!
        @last_collided_block = block
        return true
      end
    end
    return false
  end
end