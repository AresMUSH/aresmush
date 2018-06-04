module AresMUSH

  # Deprecated - do not use.  
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
end