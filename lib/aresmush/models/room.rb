module AresMUSH
  class Room    
    include MongoMapper::Document
    
    key :name
    has_many :exits, :class_name => 'AresMUSH::Exit', :foreign_key => :source_id
    has_many :characters, :class_name => 'AresMUSH::Character'
  end
end
