module AresMUSH
  class WikiPageVersion < Ohm::Model
    include ObjectModel
    
    attribute :text    
    reference :wiki_page, "AresMUSH::WikiPage"
    reference :character, "AresMUSH::Character"
    
    def author_name
      self.character ? self.character.name : "--"
    end
  end
end