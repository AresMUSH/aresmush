module AresMUSH
  class Character < Ohm::Model
    include ObjectModel
    
    field :handle, :type => String
    field :handle_id, :type => String

    def self.find_one(name)
      find_any(name).first
    end
    
    def self.find_by_handle(name)
      return [] if !name
      Character.all.select { |c| (!c.handle ? "" : c.handle.downcase) == name.downcase }
    end
    
    def name_and_alias
      if (self.alias.blank?)
        name
      else
        "#{name} (#{self.alias})"
      end
    end
    
    def client
      Global.client_monitor.find_client(self)
    end
    
    def is_online?
      self.client
    end
    
    def self.random_link_code
      (0...8).map { (65 + rand(26)).chr }.join
    end 
  end
end
    