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
    
    puts self.state().printString()
    
  end
  
  def currentQuestion
    return self.state().current_node().text()
  end
  
  def promptForYesNo
    loop do
      print " > "
      answer = gets
      if (answer =~ /^\s*y/i)
        return true
      elsif (answer =~ /^\s*n/i)
        return false
      end
      puts "please answer yes or no"
    end
  end
  
  def advanceLeft()
    self.state().advanceTo(self.state().current_node().getLeftNodeFromDB(self.adb()))

    #self.advanceTo(self.state().current_node().getLeftNodeFromDB(self.adb()))

    #nextNode = self.state().current_node().getLeftNodeFromDB(self.adb())
    #self.state.moveCurrentToParent()
    #self.state().current_node(nextNode)    
  end

  def advanceRight()
    self.state().advanceTo(self.state().current_node().getRightNodeFromDB(self.adb()))
  end
    

  
end


game = Game.new()
game.initializeGame()

loop do
  print game.currentQuestion() + " > "
  
  answeredYes = game.promptForYesNo()
  
  if answeredYes
    if (game.state().isLeaf())  # yea!  we're done!
      puts "I guessed correctly. I must be very smart."
    else
      #self.play_game_from_node(current_node,current_node.getYes())
      puts "advanceLeft"
      game.advanceLeft() 
      
      
    end
  else  # player answered no to question
    puts "player answered no"
    if (!game.state().isLeaf()) # not at a leaf means we're at a branch
      #self.play_game_from_node(current_node,current_node.getNo())
      puts "advanceRight"
      game.advanceRight()
      
    else  # uh-oh.  got to the end of the questions and did not find the animal
      puts "need to get a new question"
      ###self.get_new_question_for_node(parent_node,current_node)
      
      # get text
      
      # give to game to do update
      
      #exit
    end
  end  
    
  puts "exiting"
  exit
  
  
  
end