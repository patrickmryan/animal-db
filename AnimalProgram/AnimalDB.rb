require 'rubygems'
require 'couchrest'

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
  end
  
  attr_reader :animaldb

  def getFirstNode
    doc = self.animaldb().get(@ROOT_ID)
    # we know that the first actual animal node is at the left pointer of the root node

    
    #keys = ['_id', 'text', 'left_id', 'right_id']
    #keys.each do | key |
    #  print key, " => ", doc[key], ", "
    #end
    #print "\n"    
    #exit
    
    
  end

  def openDB
    server = CouchRest.new()
    @animaldb = server.database!(@ANIMALDB_NAME)

  end

  
  def createNew
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

    self.openDB()

    @couchdb.save_doc(node0)
    @couchdb.save_doc(node1)
    
  end

  def open
    # check to see if it exists
    # if not, initialize with basic tree
  end

  def close
  end

  def next_node_id
    return Time.now().to_f().to_s()  # time now, in milliseconds
  end
  
end
