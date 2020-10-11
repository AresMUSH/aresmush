module AresMUSH
  module OOCTime
    
    def self.timezone_aliases
      {
        "EST" => "America/New_York",
        "EDT" => "America/New_York",
        "CST" => "America/Chicago",
        "MST" => "America/Denver",
        "PST" => "America/Los_Angeles",
        "AST" => "Canada/Atlantic",
        "GMT" => "Greenwich"
      }
    end
    
    def self.convert_timezone_alias(zone)
      zone = "#{zone}"
      if (OOCTime.timezone_aliases.has_key?(zone.upcase))
        return OOCTime.timezone_aliases[zone.upcase]
      else
        return zone
      end
    end
  end
end