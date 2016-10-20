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
  end
  
  attr_accessor :id, :left_id, :right_id, :parent_id, :text
   
  def doc
    return {
          '_id' => self.id(),
          'text' => self.text(),
          'left_id' => self.left_id(),
          'right_id' => self.right_id()
        }
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
    doc = self.doc()
    #puts "updateInDB " + doc.to_s
    
    oldDoc = adb.getDocFromId(doc['_id'])  # get the current doc, including version, so I can delete it
    adb.animaldb().delete_doc(oldDoc)
    adb.animaldb().save_doc(doc)

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

