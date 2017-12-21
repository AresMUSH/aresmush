module AresMUSH
  class Character
    attribute :cg_background
    attribute :is_approved, :type => DataType::Boolean
    attribute :chargen_locked, :type => DataType::Boolean
    attribute :chargen_stage, :type => DataType::Integer
    reference :approval_job, "AresMUSH::Job"
    attribute :bg_shared, :type => DataType::Boolean, :default => true

    collection :rp_hooks, "AresMUSH::RpHook"
    
    def is_approved?
      return true if is_admin?
      Chargen.is_enabled? ? self.is_approved : true
    end
    
    def background
      self.cg_background
    end
  end
  
  class RpHook < Ohm::Model
    include ObjectModel

    index :name
    
    reference :character, "AresMUSH::Character"
    attribute :name
    attribute :description
  end  
  
end