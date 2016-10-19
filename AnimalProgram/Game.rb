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
    
    #puts self.state().printString()
    
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
  end

  def advanceRight()
    self.state().advanceTo(self.state().current_node().getRightNodeFromDB(self.adb()))
  end
    
  
  
  def wordWithArticle(word)
 
    if (word =~ /^[aeiou]/i)  # word starts with a vowel
       article = "an"
     else
      article = "a"
     end
    return article + " " + word
  end
  

  def get_new_question_for_node
    # need to prompt for a new question and then edit the tree
    # we'll end up with two new nodes, a question node and an animal node
   
    lastAnimalName = self.state().current_node().text()
    
    puts "I don't know what animal you're thinking of. Help me update my database."
    print "Please type in the name of the animal > "

    newAnimalName = gets.chomp()  # delete newline
    
    print "You will need to type in a question that will distinguish between "
    print self.wordWithArticle(lastAnimalName)
    print " and "
    print self.wordWithArticle(newAnimalName) + ".\n"
    
    puts "The question should be TRUE for one animal and FALSE for the other."
    puts "After you enter the question, I will ask for which animal the question is true."
    print "> "

    newQuestion = gets.chomp()
 
    print "\nIs this question true for " + self.wordWithArticle(newAnimalName) + "?"
    
    trueForNewAnimal = self.promptForYesNo()
    
    self.updateTree(newAnimalName,newQuestion,trueForNewAnimal)
    

    
  end
  
  def updateTree(newAnimalName,newQuestion,trueForNewAnimal)
    newNodeId = self.adb().next_node_id()
    
    last_animal_node = self.state().current_node()
    last_question_node = self.state().parent_node()
    
    new_animal_node = LeafNode.new()
    newAnimalId = self.adb().next_node_id()
    new_animal_node.id=(newAnimalId)
    new_animal_node.text=(newAnimalName)
    
    new_question_node = BranchNode.new()
    newQuestionId = self.adb().next_node_id()
    new_question_node.id=(newQuestionId)
    new_question_node.text=(newQuestion)
    
#    puts "trueForNewAnimal = #{trueForNewAnimal}"
    if (trueForNewAnimal)
      new_question_node.left_id=(newAnimalId)
      new_question_node.right_id=(last_animal_node.id())
    else
      new_question_node.left_id=(last_animal_node.id())
      new_question_node.right_id=(newAnimalId)
    end
    
    self.updateExistingNodeWith(last_question_node,last_animal_node,new_question_node)
 
    # now persist the updates
  
    new_animal_node.createInDB(self.adb())
    new_question_node.createInDB(self.adb())
    last_question_node.updateInDB(self.adb())

  end
    
  def updateExistingNodeWith(parentNode,lastNode,newQuestionNode)
    if (lastNode.id() == parentNode.left_id())
      parentNode.left_id=(newQuestionNode.id())
    elsif (lastNode.id() == parentNode.right_id())
      parentNode.right_id=(newQuestionNode.id())
    else
      # exception
    end
    
  end
  
end

loop do
  game = Game.new()
  game.initializeGame()

  puts "Starting the Animal game"
  finishedGame = false
  
  while (!finishedGame) do
    print game.currentQuestion() + " > "

    answeredYes = game.promptForYesNo()

#    print "game state = "
#    print game.state().printString()
#    print "\n"
      
    if answeredYes
      if (game.state().isLeaf())  # yea!  we're done!
        puts "I guessed correctly. I must be very smart."
        finishedGame = true
      else
#        puts "advanceLeft"
        game.advanceLeft()

      end
    else  # player answered no to question
      puts "player answered no"
      if (!game.state().isLeaf()) # not at a leaf means we're at a branch
#        puts "advanceRight"
        game.advanceRight()

      else  # uh-oh.  got to the end of the questions and did not find the animal
        puts "need to get a new question"
        game.get_new_question_for_node()
        finishedGame = true

      end
    end
  end

  print "play again? > "
  keepGoing = game.promptForYesNo()
  if (!keepGoing)
    exit
  end

end