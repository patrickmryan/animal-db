require './AnimalDB.rb'

class GameNode
  def initialize
    @id = 0
    @left_id = 0
    @right_id = 0
    @parent_id = 0
    @text = ''
  end
  
  attr_accessor :id, :left_id, :right_id, :parent_id, :text
  
  def printString
    return self.class.name() +
      " {id = #{@id}, left_id = #{@left_id}, right_id = #{@right_id}, text = #{@text}, parent_id = #{@parent_id}"
  end
  
  def getLeftNodeFromDB(db)
    return db.getNodeFromId(self.left_id())
  end

  def getRightNodeFromDB(db)
    return db.getNodeFromId(self.right_id())
  end

    
end