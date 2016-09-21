module AresMUSH
  module Idle
    module Api
      def self.active_chars
        Idle.active_chars
      end
      
      def self.idled_status(char)
        char.idled_out
      end
    end
  end
end