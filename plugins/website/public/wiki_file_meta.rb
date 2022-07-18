module AresMUSH
  class WikiFileMeta < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :folder
    attribute :description
    
    index :name
    index :folder
    
    reference :uploaded_by, "AresMUSH::Character"
    
    
    def self.find_meta(folder, name)
      return nil if !folder || !name
      WikiFileMeta.find(name: name, folder: folder).first
    end
    
    def author_name
      self.uploaded_by ? self.uploaded_by.name : ''
    end
  end
end