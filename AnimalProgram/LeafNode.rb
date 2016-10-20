require './GameNode.rb'

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