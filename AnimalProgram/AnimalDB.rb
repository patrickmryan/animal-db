require 'rubygems'
require 'couchrest'
require './GameNode.rb'
require './BranchNode.rb'
require './LeafNode.rb'

class AnimalDB
  #
  #  schema
  #    id
  #    text  (contains either the name of an animal or a question)
  #    left_id
  #    right_id
  #
  #  root node has id == 0
  #
  #  Note: Arch. decision is to not read entire tree into memory.  Leave tree in db. Retrieve nodes as needed.
  #
  #

  def initialize
    @ANIMALDB_NAME = 'animal_db'
    @ROOT_ID = '0'
    @animaldb = nil
    @server = nil
  end
  
  attr_accessor :animaldb, :server

  def getDocFromId(node_id)

    puts "retrieving node with id ", node_id
    doc = self.animaldb().get(node_id)
    if (doc)
      keys = ['_id', 'text', 'left_id', 'right_id']
      keys.each do | key |
        print key, " => ", doc[key], ", "
      end
      print "\n"
    else
      print "not found\n"
    end

    return doc

  end
  
  def getNodeFromId(node_id)
    doc = self.getDocFromId(node_id)
    if (doc)
      return self.nodeFromDoc(doc)
    else
      return nil
    end
  end
  
  def nodeFromDoc(doc)
    node = nil
    if ((doc['left_id'] != '') || (doc['right_id'] != ''))  
      # if either of these is nonempty, then this is a branch
      node = BranchNode.new()
    else
      node = LeafNode.new()
    end
    
    node.id=(doc['_id'])
    node.left_id=(doc['left_id'])
    node.right_id=(doc['right_id'])
    node.text=(doc['text'])
    return node
    
  end
  
  def getRootNode
    return self.getNodeFromId(@ROOT_ID)
    
  end

  def openDB
    self.server=(CouchRest.new())
    @animaldb = self.server().database!(@ANIMALDB_NAME)

  end

  
  def createNewTree
    node1_id = self.next_node_id()
    node1 = {
      '_id' => node1_id,
      'text' => 'Is it a cat',
      'left_id' => '',
      'right_id' => ''
    }

    node0 = {
      '_id' => @ROOT_ID,
      'text' => '',
      'left_id' => node1_id,
      'right_id' => ''
    }

    @animaldb.save_doc(node0)
    @animaldb.save_doc(node1)
    
  end

  def initializeTree
    # check to see if it exists
    # if not, initialize with basic tree
    
    self.openDB()
    
    node0_doc = self.getRootNode()
    if (node0_doc == nil)
      puts "node 0 not found, creating new tree"
      self.createNewTree()
    else
      puts "node 0 found, not creating new tree"
    end
    
  end

  def close
  end

  def next_node_id
    ##return Time.now().to_f().to_s()  # time now, in milliseconds
    return self.server().next_uuid()
    
  end
  
  def initialState
    state = GameState.new
    state.current_node_id(@ROOT_ID)
    state.parent_node_id(@ROOT_ID)
  end
  
  
end







