module AresMUSH
  class Character
    field :temp_link_codes, :type => Hash, :default => {}
    field :handle_profile, :type => String

    before_validation :save_handle

    def save_handle
      if (Global.api_router.is_master?)
        self.handle = "@#{self.name}"
        self.handle_privacy = Handles.privacy_public
      end
    end
  end
end