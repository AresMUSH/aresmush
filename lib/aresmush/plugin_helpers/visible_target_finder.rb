module AresMUSH
  class VisibleTargetFinder
    def self.find(name, client, default = nil)
      if (!default.nil?)
        name = name || default
      end
      
      return client.char if (name.downcase == t("object.me"))

      loc_id = client.location
      return Room.find_one(loc_id) if (name.downcase == t("object.here"))

      contents = ContentsFinder.find(loc_id)
      contents = contents.select { |c| c["name_upcase"] == name.upcase }
      SingleResultSelector.select(contents, client)
    end
  end
end