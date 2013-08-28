class ArkanoidGame < Chingu::Window
  def initialize
    super 640, 480, false
    self.caption = "Ruby Arkanoid!"
    
    switch_game_state(PlayState.new)
  end
end