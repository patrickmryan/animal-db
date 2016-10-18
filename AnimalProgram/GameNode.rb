require 'rubygems'
require 'couchrest'
require './AnimalDB.rb'

class GameNode
  def initialize
    @id = 0
    @left_id = 0
    @right_id = 0
    @parent_id = 0
    @text = ''
  end
  
  def initialize(anId)
    self.initialize()
    self.id=(anId)
  end
  
  attr_accessor :id, :left_id, :right_id, :parent_id, :text
  
  
#  def getDocFromId(db,node_id)
# 
#     puts "retrieving node with id ", node_id
#     doc = db.get(node_id)
#     if (doc)
#       keys = ['_id', 'text', 'left_id', 'right_id']
#       keys.each do | key |
#         print key, " => ", doc[key], ", "
#       end
#       print "\n"
#     else
#       print "not found\n"
#     end
# 
#     return doc
# 
#   end
#   
#   def getNodeFromId(node_id)
#     doc = self.getDocFromId(node_id)
#     if (doc)
#       return self.nodeFromDoc(doc)
#     else
#       return nil
#     end
#   end
#   
#   def nodeFromDoc(doc)
#     node = nil
#     if ((doc['left_id'] != '') || (doc['right_id'] != ''))  
#       # if either of these is nonempty, then this is a branch
#       node = BranchNode.new(doc['_id'])
#     else
#       node = LeafNode.new(doc['_id'])
#     end
#     
#     #node.id=(doc['_id'])
#     node.left_id=(doc['left_id'])
#     node.right_id=(doc['right_id'])
#     node.text=(doc['text'])
#     return node
#     
#   end
  
  
  
  
  
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