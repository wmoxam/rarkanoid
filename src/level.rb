require 'yaml'

class Level < Chingu::GameObject
  attr_accessor :last_collided_block

  def initialize(base_dir, config)
    super()
    
    @base_dir = base_dir
    @config = config
    
    @image = Gosu::Image[@base_dir + '/' + @config["background"]]
    
    y = 3
  	@blocks = @config["rows"].collect do |row|
      x = 3
      block_row = row.split(//).collect do |symbol|
        block = Block.get_block(symbol, x, y)
        x += Block::WIDTH + 3
        block
      end

      y += Block::HEIGHT + 3

      block_row 
    end.flatten.compact
    @last_collided_block = nil
    
  end
  
  def draw
    @image.draw(0, 0, ZOrder::Background)
    @blocks.each {|b| b.draw }
  end

  def self.load_all
  	Dir["data/levels/*/config.yaml"].collect do |config_file|
  	  new(File.dirname(config_file), YAML.load_file(config_file))
    end
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