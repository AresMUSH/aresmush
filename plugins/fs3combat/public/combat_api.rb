module AresMUSH
  module FS3Combat
    def self.is_enabled?
      !Global.plugin_manager.is_disabled?("fs3combat")
    end
  end
end
