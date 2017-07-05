module AresMUSH
  module Utils
    def self.grab(client, char, msg)
      prefix = char.utils_edit_prefix ? "#{char.utils_edit_prefix} " : ""
      client.emit_raw "#{prefix}#{msg}"
    end
  end
end