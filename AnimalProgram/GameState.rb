class GameState
  def initialize
    @current_node = nil
    @parent_node = nil
  end
  
  attr_accessor :current_node, :parent_node
  
  def printString
    return self.class.name()  + 
    " { current = " + self.current_node().printString +
    ", parent = " + self.parent_node().printString, " }"
  end
  
  def isLeaf
    return this.current_node().isLeaf()
  end
  
  #def moveCurrentToParent
  #  self.parent_node=(self.current_node())
  #end
  
  def advanceTo(nextNode)
      self.parent_node=(self.current_node())
      self.current_node=(nextNode)      
  end
  
end