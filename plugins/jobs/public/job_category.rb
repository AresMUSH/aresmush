module AresMUSH
  
  class JobCategory  < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    attribute :color
    attribute :template
    
    set :roles, "AresMUSH::Role"
    collection :jobs, "AresMUSH::Job"
    
    index :name_upcase
    before_save :save_upcase
    
    def save_upcase
      self.name_upcase = self.name ? self.name.upcase : nil
    end
  end
  
end