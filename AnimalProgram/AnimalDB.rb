require 'rubygems'
require 'couchrest'
require './GameNode.rb'

class AnimalDB
  #
  # schema
  #    id
  #    text  (contains either the name of an animal or a question)
  #    left_id  (points to the Yes answer)
  #    right_id (points to the No answer)
  #
  # root node has id == '0'
  #
  # Note: Arch. decision is to not read entire tree into memory.  Leave tree in db.
  # Retrieve nodes as needed.
  #
  #
  def initialize
    @ANIMALDB_NAME = 'animal_db'
    @ROOT_ID = '0'
    @animaldb = nil
    @server = nil
  end

  attr_accessor :animaldb, :server

  def serverURL
    #return 'https://814ab5b5-b609-48ad-a316-6b4d671dc9bb-bluemix.cloudant.com/'
    
    #return 'https://814ab5b5-b609-48ad-a316-6b4d671dc9bb-bluemix:201f803ecbcb17255862ce2aa46bc9e9a6f3be0cabd0441d0d14ad86e0f419c3@814ab5b5-b609-48ad-a316-6b4d671dc9bb-bluemix.cloudant.com'
    
    return "https://2d86c541-ddb2-4c7e-a594-e0de57b97af0-bluemix:5f46bdc73d62e5c2b58b7492c98f6ac9aad65f89f7e144bd424cf0aed8cfeccf@2d86c541-ddb2-4c7e-a594-e0de57b97af0-bluemix.cloudant.com"
    
  end
  
  def getDocFromId(node_id)
    return self.animaldb().get(node_id)
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
    if ((doc['left_id'] != '') || (doc['right_id'] != ''))
      # if either of these is nonempty, then this is a branch
      node = BranchNode.new()
    else
      node = LeafNode.new()
    end

    #    node.id=(doc['_id'])
    #    node.left_id=(doc['left_id'])
    #    node.right_id=(doc['right_id'])
    #    node.text=(doc['text'])
    #    node.rev=(doc['_rev'])

    node.updateFromDoc(doc)

    return node

  end

  def getRootNode
    return self.getNodeFromId(@ROOT_ID)

  end

  def openDB
    url = self.serverURL()
    #print "opening " + url + "\n"
    self.server=(CouchRest.new(url))
    @animaldb = self.server().database!(@ANIMALDB_NAME)

  end

  def createNewTree
    node1 = LeafNode.new()
    node1.id=(self.next_node_id())
    node1.text=('cat')

    node0 = BranchNode.new()
    node0.id=(@ROOT_ID)
    node0.left_id=(node1.id())

    node0.createInDB(self)
    node1.createInDB(self)

  end

  def initializeTree
    # check to see if it exists
    # if not, initialize with basic tree

    self.openDB()

    node0_doc = self.getRootNode()
    if (node0_doc == nil)
      #      puts "node 0 not found, creating new tree"
      self.createNewTree()
    else
      #      puts "node 0 found, not creating new tree"
    end

  end

  def close
  end

  def next_node_id
    return self.server().next_uuid()

  end

  def initialState
    state = GameState.new
    state.current_node_id(@ROOT_ID)
    state.parent_node_id(@ROOT_ID)
  end

end

