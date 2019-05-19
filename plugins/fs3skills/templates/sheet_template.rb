module AresMUSH
  module FS3Skills
    class SheetTemplate < ErbTemplateRenderer

      attr_accessor :char

      def initialize(char, client)
        @char = char
        super File.dirname(__FILE__) + "/sheet.erb"
      end

      def approval_status
        Chargen.approval_status(@char)
      end

      def luck
        @char.luck.floor
      end

      def attrs
       list = []
        @char.fs3_attributes.sort_by(:name, :order => "ALPHA").each_with_index do |a, i|
          list << format_attr(a, i)
        end
        list
      end

      def action_skills
        list = []
        @char.fs3_action_skills.sort_by(:name, :order => "ALPHA").each_with_index do |s, i|
           list << format_skill(s, i, true)
        end
        list
      end

      def spells
        list = []
        @char.fs3_spells.sort_by(:level, :order => "ALPHA").each_with_index do |s, i|
           list << format_spell(s, i, true)
        end
        list
      end

      def background_skills
        list = []
        @char.fs3_background_skills.sort_by(:name, :order => "ALPHA").each_with_index do |s, i|
           list << format_adv_bg(s, i)
        end
        list
      end

      def languages
        list = []
        @char.fs3_languages.sort_by(:name, :order => "ALPHA").each_with_index do |l, i|
          list << format_language(l, i)
        end
        list
      end

      def advantages
        list = []
        @char.fs3_advantages.sort_by(:name, :order => "ALPHA").each_with_index do |l, i|
          list << format_language(l, i)
        end
        list
      end

      def use_advantages
        FS3Skills.use_advantages?
      end

      def specialties
        spec = {}
        @char.fs3_action_skills.each do |a|
          if (a.specialties)
            a.specialties.each do |s|
              spec[s] = a.name
            end
          end
        end
        return nil if (spec.keys.count == 0)
        spec.map { |spec, ability| "#{spec} (#{ability})"}.join(", ")
      end

      def format_attr(s, i, show_linked_attr = false)
          name = "%xh#{s.name}:%xn"
          linked_attr = show_linked_attr ? print_linked_attr(s) : "   "
          linebreak = i % 2 == 1 ? "" : "%r"
          rating_text = "#{s.rating_name}"
          rating = "%xh#{s.print_rating}%xn"
          "#{linebreak}#{left(name, 16)} [#{rating}] #{linked_attr} #{left(rating_text,12)}"
      end


      def format_skill(s, i, show_linked_attr = true)
          name = "%xh#{s.name}:%xn"
          linked_attr = show_linked_attr ? print_linked_attr(s) : "   "
          linebreak = i % 2 == 1 ? "" : "%r"
          rating_text = "#{s.rating_name}"
          rating = "%xh#{s.print_rating}%xn"
          "#{linebreak}#{left(name, 16)} [#{rating}] #{linked_attr} #{left(rating_text,12)}"
      end

      def format_adv_bg(s, i, show_linked_attr = false)
          name = "%xh#{s.name}:%xn"
          linked_attr = show_linked_attr ? print_linked_attr(s) : "   "
          linebreak = i % 2 == 1 ? "" : "%r"
          rating_text = "#{s.rating_name}"
          rating = "#{s.print_rating}"
          "#{linebreak}#{left(name, 16)} [#{rating}] #{linked_attr} #{left(rating_text,12)}"
      end

      def format_spell(s, i, show_linked_attr = false)
          name = "%xh#{s.name}%xn"
          linked_attr = show_linked_attr ? print_linked_attr(s) : "   "
          linebreak = i % 2 == 1 ? "" : "%r"
          rating_text = "#{s.level}"
          "#{linebreak}[#{rating_text}] #{left(name, 34)}"
      end

      def format_language(s, i, show_linked_attr = false)
          name = "%xh#{s.name}%xn"
          linked_attr = show_linked_attr ? print_linked_attr(s) : "   "
          linebreak = i % 2 == 1 ? "" : "%r"
          rating_text = ""
          "#{linebreak}#{left(name, 16)} #{left(rating_text, 20)}"
      end

      def print_linked_attr(skill)
        apt = FS3Skills.get_linked_attr(skill.name)
        !apt ? "" : "%xh%xx#{apt[0..2].upcase}%xn"
      end

      def dateofbirth
          dob = @char.demographic("birthdate")
          !dob ? "Unknown" : ICTime.ic_datestr(dob)
      end

      def origin
        @char.group("Origin") || "Unknown"
      end

      def element
        @char.group("Guiding Element") || "Unknown"
      end

      def callname
        @char.name || "Unknown"
      end

      def truename
        @char.demographic("truename") || "Unknown"
      end

      def age
        age = @char.age
        age == 0 ? "--" : age
      end

      def stage
        return "Foal" if age <= 17
        return "Pony" if age > 17
      end

      def game_name
        Global.read_config("game","name")
      end

      def xp_max
        Global.read_config("fs3skills","max_xp_hoard")
      end

      def luck_max
        Global.read_config("fs3skills","max_luck")
      end

      def valor_max
        attr = FS3Skills.ability_rating(@char,"Presence") + FS3Skills.ability_rating(@char,"Grit")
        adv = char.fs3_bonus_valor
        max = adv + attr
        max == 0 ? "1" : max
      end

      def valor_curr
        char.fs3_valor
      end

      def mana_max
        attr = FS3Skills.ability_rating(@char,"Presence") + FS3Skills.ability_rating(@char,"Grit") + FS3Skills.ability_rating(@char,"Wits") + FS3Skills.ability_rating(@char,"Reflexes") + FS3Skills.ability_rating(@char,"Perception") + FS3Skills.ability_rating(@char,"Brawn")
        adv = 0
        max = adv + attr
        max == 0 ? "1" : max
      end

      def mana_curr
        max = mana_max + chr.fs3_trained_mana
        dmg = char.fs3_mana
        cur = max - dmg
        cur
      end
    end
  end
end
