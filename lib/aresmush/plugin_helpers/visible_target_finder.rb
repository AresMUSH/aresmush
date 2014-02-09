module AresMUSH
  # TODO - REDO
  class VisibleTargetFinder
    def self.find(name, client)
      return FindResult.new(client.char, nil) if (name.downcase == t("object.me"))

      loc_id = client.location
      if (name.downcase == t("object.here"))
        room = Room.find_one(loc_id)
        return FindResult.new(room, nil)
      end

      contents = ContentsFinder.find(loc_id)
      contents = contents.select { |c| c["name_upcase"] == name.upcase }
      SingleResultSelector.select(contents)
    end
  end
end