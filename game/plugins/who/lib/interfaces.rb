module AresMUSH
  module Who

    # TODO - Move to IC Module
    def self.is_ic?(char)
      puts char
      char["status"] == "IC"
    end

  end
end