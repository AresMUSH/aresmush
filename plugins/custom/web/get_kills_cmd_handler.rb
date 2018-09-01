module AresMUSH
  module Custom
    class GetKillsCmdHandler
      def handle(request)
        
        scoreboard = VictoryKill.all.select { |k| !k.character.idle_state }.group_by { |k| k.character }.sort_by { |char, victories| victories.count }.reverse
        scenes = VictoryKill.all.group_by { |k| k.scene }.sort_by { |scene, victories| scene.icdate }.reverse

        {
          scoreboard: scoreboard.each_with_index.map { |(char, victories), i| { char: { name: char.name, military_name: char.military_name, icon: Website.icon_for_char(char) }, kill_count: victories.count, index: i + 1 } },
          scenes: scenes.map { |scene, victories| { id: scene.id, title: scene.date_title, victories: victories.map { |v| { victory_name: v.victory, char: { name: v.character.name }  } } } }
        }
      end
    end
  end
end
