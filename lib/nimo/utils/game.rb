module Nimo
  
  # Helper method to create and show a new GameWindow with a construction block.
  # 
  # Example, from simplest.rb:
  # 
  #   Nimo::Game("Simplest", 640, 480) do
  #     screen :game do
  #       quad :with => { :width => 20, :height => 20, :color => Gosu::white } do
  #         # Code ommited.
  #       end
  #       when_key(Gosu::Button::KbEscape) { exit }
  #     end
  #   end
  #   
  def self.Game(title, width, height, &blk)
    window = Nimo::GameWindow.new(title, width, height)
    window.instance_eval(&blk) if block_given?
    window.show
    return window
  end
  
end