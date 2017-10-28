module AresMUSH
  class WebApp
    get '/roster/?' do
      group = Global.read_config("website", "character_gallery_group") || "Faction"
      @roster = Character.all.select { |c| c.on_roster? }.group_by { |c| c.group(group) || "" }
      erb :"idle/roster_index"
    end
  end
end
