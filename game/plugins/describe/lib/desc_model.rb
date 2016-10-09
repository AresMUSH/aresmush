module AresMUSH
  
  module Describable
    def self.included(base)
      base.send :extend, ClassMethods   
      base.send :register_data_members
    end
    
    module ClassMethods
      def register_data_members
        before_delete :delete_descs
      end
    end
    
    
    def delete_descs
      descs =  Description.find(parent_id: self.id).combine(parent_type: self.class.to_s)
      descs.each { |d| d.delete }
    end
    
    def descs_of_type(type)
      Description.find(parent_id: self.id)
        .combine(parent_type: self.class.to_s)
        .combine(desc_type: type)
    end
    
    def create_desc(type, desc, name = nil)
      Description.create(name: name, 
          desc_type: type,
          description: desc, 
          parent_type: self.class.to_s, 
          parent_id: self.id)
    end
        
    # -------------------------------
    # Current
    # -------------------------------
    
    def description
      current = current_desc
      current ? current.description : nil
    end

    def current_desc
      descs_of_type(:current).first
    end
    
    def current_desc=(desc)
      if (description)
        description.update(description: desc)
      else
        create_desc(:current, desc)
      end
    end
      
    # -------------------------------
    # Details
    # -------------------------------
    def has_detail?(name)
      !!detail(name)
    end
    
    def detail(name)
      details.find(name: name).first
    end
    
    def details
      descs_of_type(:detail)
    end
  end

  class Description < Ohm::Model
    include ObjectModel

    attribute :name
    attribute :description
    attribute :parent_id
    attribute :parent_type
    attribute :desc_type
    
    index :name
    index :parent_id
    index :parent_type
    index :desc_type
  end

  class SceneSet < Ohm::Model
    include ObjectModel
    attribute :set
    attribute :time, DataType::Time
    reference :room, "AresMUSH::Room"
  end
  
  class Character
    include Describable
    
    def shortdesc
      descs_of_type("short").first
    end
    
    # -------------------------------
    # Outfits
    # -------------------------------
    
    def has_outfit?(name)
      !!outfit(name)
    end
    
    def outfit(name)
      outfits.find(name: name).first
    end
    
    def outfits
      descs_of_type(:outfit)
    end
  end
  
  class Room
    include Describable

    reference :scene_set, "AresMUSH::SceneSet"
    
    before_delete :delete_scene_set
    
    def delete_scene_set
      self.scene_set.delete if self.scene_set
    end
    
  end
  
  class Exit
    include Describable
  end    
end
