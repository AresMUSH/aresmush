module AresMUSH
  class WikiPageVersion < Ohm::Model
    include ObjectModel
    
    attribute :text    
    reference :wiki_page, "AresMUSH::WikiPage"
  end
end