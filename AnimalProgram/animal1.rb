class AnimalGame

  def initialize
    self.initialize_game()
  end
  
  def initialize_game
    # very top node starts with nothing
    @top_node = BinaryNode.new(nil)

    # left node contains first actual question
    @top_node.setLeftNode(AnimalNode.new("cat"))

  end
  
  attr_reader :top_node

  def getTopNode ; return @top_node ; end



  def play_game_with_player(aPlayer)
    top = self.getTopNode()
    aPlayer.play_game_from_node(top,top.getLeftNode())
    
  end
   
end

class NullNode
  def isNull ; return true ; end
  def printString ; return "Null" ; end
  def getText ; return self.printString() ; end
end

class BinaryNode
  
  def initialize (aString)
    @left = nil
    @right = nil

  end

  def getLeftNode ; return @left ; end
  def getRightNode ; return @right ; end
  def isNull ; return false ; end

  def getYes ; return self.getLeftNode() ; end
  def getNo ; return self.getRightNode() ; end
  def setYes(node) ; self.setLeftNode(node) ; end
  def setNo(node) ; self.setRightNode(node) ; end

  def isLeaf
    return !(@left || @right)
  end

  def setLeftNode(aNode)
    @left = aNode
  end

  def setRightNode(aNode)
    @right = aNode
  end

  def replaceExistingNodeWith(oldThing,newThing)
    if (self.getYes() == oldThing)    # got here on a "yes"
      self.setYes(newThing)
      
    elsif (self.getNo() == oldThing)  # got here on a "no"
      self.setNo(newThing)
    else
      # probably should thrown an exception here
    end
  end

  
  attr_reader :left
  attr_reader :right

  def getText ; return "BinaryNode:" ; end
  def printString ; return self.getText() ; end

  def recursePrint ; self.recursePrintFromLevel(0); end
  
  def recursePrintFromLevel(spaces)
    spaces.times { print " " }
    print self.printString()

    if (self.isLeaf())
      print "\n"
    else
      print " { yes - "
      leftNode = self.getLeftNode()
      rightNode = self.getRightNode()
      
      if (leftNode)
        print leftNode.printString()
      else
        print "nil"
      end
      print ", no - "
      if (rightNode)
        print rightNode.printString()
      else
        print "nil"
      end
      print " }\n"
      
      if (leftNode)
        leftNode.recursePrintFromLevel(spaces+1)
      end     
      if (rightNode)
        rightNode.recursePrintFromLevel(spaces+1)
      end
    end
  end
  
end

class QuestionNode < BinaryNode

  def initialize(string)
    super
    @question = string
  end
  attr_reader :question

  def getText
    q = self.question()
    if (q !~ /\?$/)   # add a question mark if it's not there already
      q = q + "?"
    end
    return q
  end

  def printString
    return "QuestionNode: #{question}"
  end
  
end

class AnimalNode < BinaryNode

  def initialize(string)
    super
    @animal = string
  end
  
  attr_reader :animal

  def getText
    return self.question()
  end

  def question
    return "Is it " + self.articleAndName() + "?"
  end

  def articleAndName
    return self.article(self.animal()) + " " + self.animal()
  end
  
  def article(word)
    if (word =~ /^[aeiou]/i)  # word starts with a vowel
      return "an"
    else
      return "a"
    end
  end
  
  def yes ; return nil; end
  def no ; return nil; end

  def printString
    return "AnimalNode: #{animal}"
  end
  
end


class Player
  def play(game)
    game.play_game_with_player(self)
    
  end


  def play_game_from_node(parent_node,current_node)  # recursive method

    # display the question at this node
    puts current_node.getText()
   
    answeredYes = self.promptForYesNo()
    if answeredYes
      if (current_node.isLeaf())  # yea!  we're done!
        puts "I guessed correctly. I must be very smart."
      else
        self.play_game_from_node(current_node,current_node.getYes())
        
      end
    else  # player answered no to question
      if (!current_node.isLeaf()) # not at a leaf means we're at a branch
        self.play_game_from_node(current_node,current_node.getNo())
        
      else  # uh-oh.  got to the end of the questions and did not find the animal
        self.get_new_question_for_node(parent_node,current_node)

      end
    end  
      
  end

   
  def get_new_question_for_node(parent,lastAnimalNode)
    # need to prompt for a new question and then edit the tree
    # we'll end up with two new nodes, a question node and an animal node
   
    puts "I don't know what animal you're thinking of. Help me update my database."
    print "Please type in the name of the animal > "

    name = gets.chomp()  # delete newline
    newAnimalNode = AnimalNode.new(name)
    
    print "You will need to type in a question that will distinguish between "
    print lastAnimalNode.articleAndName()
    print " and "
    print newAnimalNode.articleAndName() + ".\n"
    puts "The question should be TRUE for one animal and FALSE for the other."
    puts "After you enter the question, I will ask for which animal the question is true."
    print "> "

    q = gets.chomp()
    newQuestionNode = QuestionNode.new(q)

    print "\nIs this question true for " + newAnimalNode.articleAndName() + "?"
    
    if (self.promptForYesNo())
      # true means question is true for the new animal
      newQuestionNode.setYes(newAnimalNode)
      newQuestionNode.setNo(lastAnimalNode)  
    else
      # false means the question is true for the existing animal
      newQuestionNode.setYes(lastAnimalNode)
      newQuestionNode.setNo(newAnimalNode)
    end

    # splice the two new nodes into the tree
    parent.replaceExistingNodeWith(lastAnimalNode,newQuestionNode)
    
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
  

  

end


print <<_END_

Welcome to the Animal Game.

Think of an animal.  I will ask yes/no questions to try to guess the animal. 

Please answer each question with a "y" or "n"
    
_END_


game = AnimalGame.new()

loop do
  thePlayer = Player.new()
  thePlayer.play(game)

  puts "game state ----"
  game.getTopNode.recursePrint()
  puts "---------------"
  
  print "play again? > "
  ans = gets
  if (ans !~ /^y/i)
    puts "goodbye"
    exit
  end
end