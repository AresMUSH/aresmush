module AresMUSH
  module Utils
    module Api
      def self.grab(client, char, msg)
        edit_prefix = "#{char.edit_prefix} "
        client.emit "#{edit_prefix}#{msg}"
      end
    end
  end
end