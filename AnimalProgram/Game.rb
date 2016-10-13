require 'rubygems'
require 'couchrest'


class Game
  def initializeGame
    
    puts "starting"
    adb = AnimalDB.new()
    adb.initializeTree()

  end
  
  
end


game = Game.new()
game.initializeGame()

