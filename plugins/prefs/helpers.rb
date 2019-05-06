module AresMUSH
  module Prefs
    def self.categories
      Global.read_config('prefs', 'categories') || []
    end
    
    def self.is_valid_setting?(setting)
      [ '+', '-', '~' ].include?(setting)
    end
    
  end
end