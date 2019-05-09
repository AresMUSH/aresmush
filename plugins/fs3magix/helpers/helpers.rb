module AresMUSH

  module FS3Magix

    def self.is_enabled?
      !Global.plugin_manager.is_disabled?("fs3magix")
    end

    def self.magix_blurb
      Global.read_config("fs3magix", "magix_blurb")
    end
  end
end
