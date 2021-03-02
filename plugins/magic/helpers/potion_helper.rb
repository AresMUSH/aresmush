module AresMUSH
  module Magic

    def self.is_potion?(spell)
      spell_name = spell.titlecase
      is_potion = Global.read_config("spells", spell_name, "is_potion")
    end

    def self.find_potion_creating(char, potion)
      char.potions_creating.select { |a| a.name == potion }.first
    end

    def self.update_potion_hours(char)
        potions_creating = char.potions_creating
        potions_has = char.potions_has
        potions_creating.each do |p|
          hours_to_creation = p.hours_to_creation.to_i - 1
          if hours_to_creation < 1
            PotionsHas.create(name: p.name, character: char)
            message = t('magic.potion_completed', :potion => p.name)
            Mail.send_mail([char.name], t('magic.potion_completed_subj', :potion => p.name), message, nil)
            p.delete
          else
            p.update(hours_to_creation: hours_to_creation)
          end
        end
    end

    def self.potions_creating
      @char.potions_creating.to_a
    end

    def self.find_potion_has (char, potion)
      char.potions_has.select { |a| a.name == potion }.first
    end

    def self.get_potions(char)
      list = char.potions_has
      list.to_a.sort_by { |a| a.name }
        .each_with_index
          .map do |a, i|
            "#{ a.name }"
      end
    end

    def self.get_potions_creating(char)
      list = char.potions_creating
      list.to_a.sort_by { |a| a.name }
        .each_with_index
          .map do |a, i|
            "#{ a.name }"
      end
    end


    def self.handle_potions_made_achievement(char)
      char.update(potions_made: char.potions_made + 1)
      [ 1, 10, 20, 50, 100, 200 ].each do |count|
        if (char.potions_made >= count)
          # if (count == 1)
          #   message = "Made a potion."
          # else
          #   message = "Made #{count} potions."
          # end
          Achievements.award_achievement(char, "potions_made", count)
        end
      end
    end

    def self.handle_potions_used_achievement(char)
      char.update(potions_used: char.potions_used + 1)
      [ 1, 10, 20, 50, 100, 200 ].each do |count|
        if (char.potions_used >= count)
          # if (count == 1)
          #   message = "Used a potion."
          # else
          #   message = "Used #{count} potions."
          # end
          Achievements.award_achievement(char, "potions_used", count)
        end
      end
    end


  end
end
