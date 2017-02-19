module AresMUSH
  module FS3Skills
    class SheetPage1Template < ErbTemplateRenderer
      
      attr_accessor :char
      
      def initialize(char, client)
        @char = char
        super File.dirname(__FILE__) + "/sheet_page1.erb"
      end
     
      def approval_status
        Chargen::Api.approval_status(@char)
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

      def background_skills
        list = []
        @char.fs3_background_skills.sort_by(:name, :order => "ALPHA").each_with_index do |s, i| 
           list << format_skill(s, i)
        end
        list
      end
      
      def languages
        list = []
        @char.fs3_languages.sort_by(:name, :order => "ALPHA").each_with_index do |l, i|
          list << format_skill(l, i)
        end
        list
      end
      
      def hooks
        list = []
        @char.fs3_hooks.sort_by(:name, :order => "ALPHA").each do |h|
          list << "%xh#{h.name}:%xn #{h.description}"
        end
        list
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
      
      def format_attr(a, i)
        name = "%xh#{a.name}:%xn"
        linebreak = i % 2 == 1 ? "" : "%r"
        rating_text = "#{a.rating_name}"
        "#{linebreak}#{left(name, 16)} #{left(rating_text,20)}"
      end
      
      def format_skill(s, i, show_linked_attr = false)
        name = "%xh#{s.name}:%xn"
        linked_attr = show_linked_attr ? print_linked_attr(s) : ""
        linebreak = i % 2 == 1 ? "" : "%r"
        rating_text = "#{s.rating_name}#{linked_attr}"
        "#{linebreak}#{left(name, 16)} #{left(rating_text, 20)}"
      end
      
      def print_linked_attr(skill)
        apt = FS3Skills.get_linked_attr(skill.name)
        !apt ? "" : " %xh%xx(#{apt[0..2].upcase})%xn"
      end
    end
  end
end