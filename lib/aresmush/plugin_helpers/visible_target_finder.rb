module AresMUSH
  class VisibleTargetFinder
    def self.find(name, client, default = nil)
      if (!default.nil?)
        name = name || default
      end
      
      return client.char if (name.downcase == t("object.me"))

      loc_id = client.location
      return Room.find_one(loc_id) if (name.downcase == t("object.here"))

      contents = AresModel.contents(loc_id)
      Room.notify_if_not_exatly_one(client) { contents.select { |c| c["name_upcase"] == name.upcase } }
    end
  end
end