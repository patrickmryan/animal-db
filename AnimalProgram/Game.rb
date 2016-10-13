require 'rubygems'
require 'couchrest'
require './AnimalDB.rb'

class Game
  
  def initialize
    ##puts "initializing a Game instance"
    @adb = nil
  end
  
  attr_accessor :adb
  
  def initializeGame
    
    #puts "starting"
    self.adb=(AnimalDB.new())
    self.adb().initializeTree()

  end
  
  
end


game = Game.new()
game.initializeGame()

