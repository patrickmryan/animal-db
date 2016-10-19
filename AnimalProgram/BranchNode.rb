require './GameNode.rb'

class BranchNode < GameNode
  def isLeaf
    return false
  end
end