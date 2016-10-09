module AresMUSH
  module Utils
    module Api
      def self.grab(client, char, msg)
        prefix = char.utils_edit_prefix ? "#{char.utils_edit_prefix} " : ""
        client.emit_raw "#{prefix}#{msg}"
      end
    end
  end
end