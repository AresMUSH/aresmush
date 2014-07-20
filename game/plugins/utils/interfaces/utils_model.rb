module AresMUSH
  class Character
    
    field :autospace, :type => String
    
    # TODO - Not Implemented Yet.  Will move to the grab password command to set it.
    def grab_password
      "1234SimpleMUUser"
    end
  end
end