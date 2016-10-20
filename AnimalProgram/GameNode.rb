require 'rubygems'
require 'couchrest'
require './AnimalDB.rb'

class GameNode
  def initialize
    @id = ''
    @left_id = ''
    @right_id = ''
    @parent_id = ''
    @text = ''
    @rev = ''
  end

  attr_accessor :id, :left_id, :right_id, :parent_id, :text, :rev

  def doc
    theDoc = {
      '_id' => self.id(),
      'text' => self.text(),
      'left_id' => self.left_id(),
      'right_id' => self.right_id()
    }
    
    # only include _rev if it exists
    r = self.rev()
    if (r != '')
      theDoc['_rev'] = r
    end
    
    return theDoc
  end

  def questionText
    return self.text()
  end

  def to_s
    return self.class.name() +
    " {id = #{@id}, left_id = #{@left_id}, right_id = #{@right_id}, text = #{@text}}"
  end

  def getLeftNodeFromDB(db)
    return db.getNodeFromId(self.left_id())
  end

  def getRightNodeFromDB(db)
    return db.getNodeFromId(self.right_id())
  end

  def createInDB(adb)
    doc = self.doc()
    #puts "createInDB " + doc.to_s
    adb.animaldb().save_doc(doc)
  end

  def updateInDB(adb)
    oldDoc = adb.getDocFromId(self.id())
    # need _rev so that I can update
    self.rev=(oldDoc['_rev'])
    newDoc = self.doc()
    
    #print "oldDoc = " + oldDoc.to_s + "\n" 
    #print "newDoc = " + newDoc.to_s + "\n" 
     
    adb.animaldb().save_doc(newDoc)

  end

end

class BranchNode < GameNode
  def isLeaf
    return false
  end
end

class LeafNode < GameNode
  def questionText
    word = self.text()

    if (word =~ /^[aeiou]/i)  # word starts with a vowel
      article = "an"
    else
      article = "a"
    end
    return "Is it " + article + " " + word
  end

  def isLeaf
    return true
  end
end

