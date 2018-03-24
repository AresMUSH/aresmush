module AresMUSH
  class Character
    attribute :cg_background
    attribute :chargen_locked, :type => DataType::Boolean
    attribute :chargen_stage, :type => DataType::Integer
    reference :approval_job, "AresMUSH::Job"
    attribute :bg_shared, :type => DataType::Boolean, :default => true
    attribute :rp_hooks
    
    def is_approved?
      return true if is_admin?
      self.has_role?("approved")
    end
    
    def background
      self.cg_background
    end
  end
end