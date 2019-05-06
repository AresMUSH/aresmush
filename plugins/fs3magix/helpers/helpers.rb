module AresMUSH

  module FS3Magix

    def self.is_enabled?
      !Global.plugin_manager.is_disabled?("fs3magix")
    end

  end
end
