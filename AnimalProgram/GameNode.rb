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
  
  def to_s
    return this.printString()
  end
  
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

  def createInDB(adb)
    doc = self.doc()
    puts "createInDB " + doc.to_s
    adb.animaldb().save_doc(doc)
  end
  
  def updateInDB(adb)
    doc = self.doc()
    puts "updateInDB " + doc.to_s
    
    oldDoc = adb.getDocFromId(doc['_id'])  # get the current doc, including version, so I can delete it
    
    #adb.animaldb().update_doc(doc)
    adb.animaldb().delete_doc(oldDoc)
    adb.animaldb().save_doc(doc)

  end
  
    
end