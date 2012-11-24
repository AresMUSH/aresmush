module AresMUSH
  module Describe
    def self.room_desc(room)
      desc = "#{room["name"]}\n#{room["desc"]}"
    end
  end
end
