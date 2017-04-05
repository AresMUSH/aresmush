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
    
    def all_descs
      Description.find(parent_id: self.id).combine(parent_type: self.class.to_s)
    end
    
    def delete_descs
      self.all_descs.each { |d| d.delete }
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
    
    def print_json
      json = super
      all_descs.each do |d|
        json << "\r\ndescription: #{d.print_json}"
      end
      json
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
  
  class Character
    include Describable
    
    attribute :desc_notify, :type => DataType::Boolean, :default => true
    
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
  end
  
  class Exit
    include Describable
  end    
end
