require 'rubygems'
require 'couchrest'
require './AnimalDB.rb'
require './GameState.rb'

class Game
  
  def initialize
    ##puts "initializing a Game instance"
    @adb = nil
  end
  
  attr_accessor :adb, :state
  
  def initializeGame
    
    #puts "starting"
    self.adb=(AnimalDB.new())
    self.adb().initializeTree()

    aState = GameState.new()
    root = self.adb().getRootNode()
    left = root.getLeftNodeFromDB(self.adb())
    aState.parent_node=(root)
    aState.current_node=(left)
    self.state=(aState)
    
  end
  
  
end


game = Game.new()
game.initializeGame()

