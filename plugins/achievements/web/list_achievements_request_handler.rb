module AresMUSH
  module Achievements
    class ListAchievementsRequestHandler
      def handle(request)
        icon_types = Global.read_config('achievements', 'types')
        
        Achievements.all_achievements.sort_by { |k, v| [v['type'], v['message']] }
          .map { |k, v| {
          name: k,
          message: (v['message'] % { count: "XXX" }),
          type: v['type'],
          type_icon: icon_types["#{v['type']}"] || "fa-question",
          chars: Achievement.all.select { |a| a.name == k }.sort_by { |a| [ 0 - a.count, a.character.name ] }
            .map { |a| {
              name: a.character.name,
              count: a.count > 0 ? a.count : nil }
            }
          }}
      end
    end
  end
end