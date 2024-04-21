module AresMUSH
  module FS3Skills
    class SheetTemplate < ErbTemplateRenderer
      
      attr_accessor :char, :client, :section
      
      def initialize(char, client, section = nul)
        @char = char
        @client = client
        @section = section
        super File.dirname(__FILE__) + "/sheet.erb"
      end
     
      def approval_status
        Chargen.approval_status(@char)
      end
      
      def luck
        @char.luck.floor
      end
      
      def show_section(section)
        sections = ['attributes', 'action', 'background', 'languages', 'advantages']
        return true if self.section.blank?
        return true if !sections.include?(section)
        return true if !sections.include?(self.section)
        return section == self.section
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
      
      def advantages
        list = []
        @char.fs3_advantages.sort_by(:name, :order => "ALPHA").each_with_index do |l, i|
          list << format_skill(l, i)
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
      
      def format_attr(a, i)
        linebreak = i % 2 == 1 ? "" : "%r"
        if (@client.screen_reader)
          return "#{linebreak}#{a.name}: #{a.rating_name} :: "
        end
        name = "%xh#{a.name}:%xn"
        rating_text = "#{a.rating_name}"
        rating_dots = a.print_rating
        "#{linebreak}#{left(name, 14)} #{left(rating_dots, 8)} #{left(rating_text,16)}"
      end
      
      def format_skill(s, i, show_linked_attr = false)
        linked_attr = show_linked_attr ? print_linked_attr(s) : ""
        linebreak = i % 2 == 1 ? "" : "%r"
        
        if (@client.screen_reader)
          return "#{linebreak}#{s.name}: #{s.rating_name} #{linked_attr} :: "
        end
                
        name = "%xh#{s.name}:%xn"
        rating_text = "#{s.rating_name}#{linked_attr}"
        rating_dots = s.print_rating
        "#{linebreak}#{left(name, 14)} #{left(rating_dots, 8)} #{left(rating_text, 16)}"
      end
      
      def print_linked_attr(skill)
        apt = FS3Skills.get_linked_attr(skill.name)
        !apt ? "" : " %xh%xx(#{apt[0..2].upcase})%xn"
      end
      
      def section_line(title)
        @client.screen_reader ? title : line_with_text(title)
      end
    end
  end
end