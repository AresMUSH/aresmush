module AresMUSH
  module Chargen
    def self.display_review_status(msg, error)
      "#{msg.ljust(50)} #{error}"
    end
  end
end