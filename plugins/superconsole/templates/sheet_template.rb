module AresMUSH
  module SuperConsole
    class SheetTemplate < ErbTemplateRenderer

      attr_accessor :char

      def initialize(char, client)
        @char = char
        super File.dirname(__FILE__) + "/sheet.erb"
      end
# --------------------------------------------
# General Sheet Items
      def game_name
        Global.read_config("game","name")
      end
# --------------------------------------------

# --------------------------------------------
# Sheet Info Section


      def approval_status
        SuperConsole.approval_status(@char)
      end
      def char_class
        @char.group("class") || "Unknown"
      end
      def archetype
        @char.group("archetype") || "Unknown"
      end
      def race
        @char.group("race") || "Unknown"
      end
      def age
        age = @char.age
        age == 0 ? "--" : age
      end
      def level
        @char.console_level
      end
      def oversoul_type
        type = @char.console_oversoul_type
        if type == nil
          "Unknown"
        else
          type
        end
      end
      def guild
        guild = @char.guildlist.first
        if (!guild)
          "Unknown"
        else
          guild.titlecase
        end
      end
      def level_cleared
        "0"
      end
# --------------------------------------------
# --------------------------------------------
# Sheet Attribute Section

# --------------------------------------------
      def attrs
       list = []
        @char.console_attributes.sort_by(:name, :order => "ALPHA").each_with_index do |a, i|
          list << format_attr(a, i)
        end
        list
      end

      def format_attr(a, i)
        name = "%x15#{a.name}:%xn"
        linebreak = i % 2 == 1 ? "" : "%r"
        lb2 = i == 0 ? "" : "#{linebreak}"
        spacebreak = i % 2 == 0 ? "  " : ""
        rating = "#{a.rating}"
        "#{lb2}#{left(name, 34)} #{right(rating,3)}#{spacebreak}"
      end

      def abils_learned
       list = []
       stats = @char.console_skills.sort_by(:name, :order => "Alpha")
       filtered = stats.select{ |x,_| x.learned == true}
            filtered.each_with_index do |a, i|
            list << format_skill(a, i)
        end
              list
      end

      def abils_learning
       list = []
       stats = @char.console_skills.sort_by(:name, :order => "Alpha")
       filter = stats.select{ |x,_| x.learned == false}
       filtered = filter.select{ |x,_| x.learnpoints >= 1}
            filtered.each_with_index do |a, i|
            list << format_skill(a, i)
        end
              list
      end
      def format_skill(a, i)
        name = "%x15#{a.name}:%xn"
        linebreak = i % 2 == 1 ? "" : "%r"
        lb2 = i == 0 ? "" : "#{linebreak}"
        spacebreak = i % 2 == 0 ? "  " : ""
        rating = "#{a.rating}"
        "#{lb2}#{left(name, 34)} #{right(rating,3)}#{spacebreak}"
      end

      def health_pool_bar
        @char.health_bar
      end
      def mana_pool_bar
        @char.mana_bar
      end
      def stamina_pool_bar
        @char.stamina_bar
      end
      def limit_pool_bar
        @char.limit_bar
      end
      def limit_max
        100
      end
      def stamina_max
        base = Global.read_config("superconsole","base_stamina")
        vit = SuperConsole.find_ability(@char,"Vitality").rating
        spi = SuperConsole.find_ability(@char,"Spirit").rating
        lvl = @char.level
        avg = ((vit + spi) / 2).floor
        vitdbl = avg * 2
        hplvl = lvl * vitdbl
        basehp = base + avg
        modhp = 0
        hplvl + basehp + modhp
      end
      def mana_max
        base = Global.read_config("superconsole","base_mana")
        vit = SuperConsole.find_ability(@char,"Magic").rating
        lvl = @char.level
        vitdbl = vit * 2
        hplvl = lvl * vitdbl
        basehp = base + vit
        modhp = 0
        hplvl + basehp + modhp
      end
      def health_max
        base = Global.read_config("superconsole","base_health")
        vit = SuperConsole.find_ability(@char,"Vitality").rating
        lvl = @char.level
        vitdbl = vit * 2
        hplvl = lvl * vitdbl
        basehp = base + vit
        modhp = 0
        hplvl + basehp + modhp
      end
      def pretty_stamina
        hp = stamina_max
        len = "#{hp}".length
        if len > 3
          Custom.commify(hp)
        else
          hp
        end
      end
      def pretty_mana
        hp = mana_max
        len = "#{hp}".length
        if len > 3
          Custom.commify(hp)
        else
          hp
        end
      end
      def pretty_health
        hp = health_max
        len = "#{hp}".length
        if len > 3
          Custom.commify(hp)
        else
          hp
        end
      end
    end
  end
end
