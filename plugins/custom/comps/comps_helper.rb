module AresMUSH
  module Custom

    def self.handle_comps_given_achievement(char)
      char.update(comps_given: char.comps_given + 1)
      [ 1, 10, 20, 50, 100 ].each do |count|
        if (char.comps_given >= count)
          if (count == 1)
            message = "Gave a comp."
          else
            message = "Gave #{count} comps."
          end
          Achievements.award_achievement(char, "gave_comps_#{count}", 'comp', message)
        end
      end
    end

  end
end
