require 'rubygems'
require 'couchrest'

class AnimalPage
  
  def initialize
    
    db = AnimalDB.new()
    db.createNew()
        
  end
  
  def openingPage
  end
  
  def questionPage
  end
  
  def newAnimalPage
  end
  
end