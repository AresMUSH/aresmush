module AresMUSH
  module Idle
    module Api
      def self.active_chars
        Idle.active_chars
      end
      
      def self.idled_status(char)
        char.idle_status ? char.idle_status.status : nil
      end
    end
  end
end