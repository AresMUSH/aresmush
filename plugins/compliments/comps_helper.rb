module AresMUSH
  module Compliments

    def self.handle_comps_given_achievement(char)
      char.update(comps_given: char.comps_given + 1)
      [ 1, 10, 20, 50, 100 ].reverse.each do |count|
        if (char.comps_given >= count)
          Achievements.award_achievement(char, "gave_comps", count)
        end
      end
    end

    def self.get_comps(char)
      list = char.comps
      list = list.to_a.sort_by { |c| c.created_at }.reverse
      list[0...10].map { |c|
        {
          from: c.from,
          msg:  Website.format_markdown_for_html(c.comp_msg),
          date: OOCTime.format_date_for_entry(c.created_at)
        }}
    end

  end
end
