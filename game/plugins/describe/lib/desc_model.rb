module AresMUSH
  
  module Detailable
    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
    end
    
    module ClassMethods
      def register_data_members
        set :details, "AresMUSH::Detail"
      end
    end
    
    def has_detail?(name)
      !!detail(name)
    end
    
    def detail(name)
      details.find(name: name).first
    end
  end
  
  class Detail < Ohm::Model
    include ObjectModel

    attribute :name
    attribute :description
    
    index :name
  end
      
  class Outfit < Ohm::Model
    include ObjectModel
    
    attribute :name
    attribute :description
    reference :character, "AresMUSH::Character"
    
    index :name
  end
  
  class Character
    include Detailable

    attribute :description
    attribute :shortdesc
    collection :outfits, "AresMUSH::Outfit"
    
    def has_outfit?(name)
      !!outfit(name)
    end
    
    def outfit(name)
      outfits.find(name: name).first
    end
  end
  
  class Room
    include Detailable

    attribute :description
    attribute :shortdesc
    attribute :sceneset
    attribute :sceneset_time, DataType::Time
  end
  
  class Exit
    include Detailable

    attribute :description
    attribute :shortdesc
  end    
end
