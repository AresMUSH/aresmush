module AresMUSH
  module Who

    # TODO - Move to IC Module
    def self.is_ic?(char)
      char["status"] == "IC"
    end

  end
end