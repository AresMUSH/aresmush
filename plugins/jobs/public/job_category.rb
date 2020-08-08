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
    
    def set_roles(role_names)
      new_roles = []
      role_names.each do |r|
        role = Role.find_one_by_name(r)
        if (role)
          new_roles << role
        end
      end
      self.roles.replace new_roles
    end
    
  end
  
end