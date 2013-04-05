module AresMUSH
  module Who

    # TODO - move to interfaces
    def self.is_ic?(char)
      char["status"] == "IC"
    end

  end
end