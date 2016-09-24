module AresMUSH
  module FS3Sheet
    class SheetPage1Template < ErbTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char, client)
        @char = char
        super File.dirname(__FILE__) + "/sheet_page1.erb"
      end
     
      def approval_status
        Chargen::Api.approval_status(@char)
      end
      
      def xp
        FS3XP::Api.xp(@char).to_s
      end
      
      def luck
        FS3Luck::Api.luck(@char).floor.to_s
      end
      
      def aptitudes
       list = []        
        @char.fs3_aptitudes.keys.sort.each_with_index do |a, i| 
          list << format_attr(a, i)
        end   
        list     
      end
        
      def action_skills
        list = []
        @char.fs3_action_skills.keys.sort.each_with_index do |s, i| 
           list << format_skill(s, i)
        end
        list
      end
      
      def languages
        list = []
        @char.fs3_languages.each_with_index do |l, i|
           list << format_list_item(l, i)
        end
        list
      end
      
      def hooks
        list = []
        @char.hooks.each do |k, v|
          list << "%xh#{k}:%xn #{v}"
        end
        list
      end
      
      def format_attr(a, i)
        name = "%xh#{a}:%xn"
        rating = FS3Skills.ability_rating(@char, a)
        dots = FS3Skills.print_aptitude_rating(rating)
        linebreak = i % 2 == 1 ? "" : "%r"
        "#{linebreak}#{left(name, 16)} #{left(dots,22)}"
      end
      
      def format_skill(s, i)
        name = "%xh#{s}:%xn"
        rating = FS3Skills.ability_rating(@char, s)
        dots = FS3Skills.print_skill_rating(rating)
        linked_attr = print_linked_attr(s)
        linebreak = i % 2 == 1 ? "" : "%r"
        "#{linebreak}#{left(name, 16)} #{linked_attr} #{left(dots,16)}"
      end
      
      def print_linked_attr(skill)
        apt = FS3Skills.get_linked_attr(@char, skill)
        apt.nil? ? "" : "(#{apt[0..2]})"
      end
      
      def format_list_item(item, i)
        linebreak = (i % 2 == 1) ? "" : "%r"
        "#{linebreak}#{item}"
      end
    end
  end
end