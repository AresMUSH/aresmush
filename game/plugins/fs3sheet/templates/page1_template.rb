module AresMUSH
  module FS3Sheet
    class SheetPage1Template
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
      end
      
      def display
        text = header_display()
        text << "%l2%r"

        text << attributes_display()
        text << "%r"
        
        text << action_skills_display()
        text << "%r"

        text << background_skills_display()
        text << "%r"

        text << languages_display()
        text << "%r"
        
        text << hooks_display()
        text << "%r%r"
        
        text << footer_display()
        text << "%r"
        text << "%l1"
        
        text
      end
      
      def header_display
        text = "%l1%r"
        text << "%xh#{name}%xn #{approval_status} #{page_title}%r"
        
        text
      end
              
      def attributes_display
        text = attributes_title()
        @char.fs3_attributes.keys.each_with_index do |a, i| 
          text << format_attr(a, i)
        end
        
        text
      end
        
      def action_skills_display
        text = action_skills_title()
        @char.fs3_action_skills.keys.each_with_index do |s, i| 
           text << format_skill(s, i)
         end
        
        text
      end
      
      def background_skills_display
        text = background_skills_title()
        @char.fs3_background_skills.keys.each_with_index do |s, i| 
           text << format_skill(s, i)
         end
        
        text
      end
      
      def languages_display
        text = languages_title()
        text << "%r"
        text << @char.fs3_languages.join(", ")
        
        text
      end
      
      def hooks_display
        text = hooks_title()
        @char.fs3_hooks.each do |k, v|
           text << "%R%xh#{k}%xn - #{v}"
         end
        
        text
      end
      
      def footer_display
        "#{xp_title} #{xp} #{luck_title} #{luck}"
      end
      
      def name
        left(@char.name, 25)
      end
      
      def approval_status
        status = Chargen.approval_status(@char)
        center(status, 23)
      end
      
      def page_title
        right(t('sheet.abilities_page_title'), 28)
      end
      
      def xp
        @char.xp.to_s.ljust(40)
      end
      
      def luck
        @char.luck
      end
      
      def attributes_title
        format_section_title t('sheet.attributes_title')
      end

      def action_skills_title
        format_section_title t('sheet.action_skills_title')
      end
      
      def background_skills_title
        format_section_title t('sheet.background_skills_title')
      end
      
      def languages_title
        format_section_title t('sheet.languages_title')
      end
      
      def hooks_title
        format_section_title t('sheet.hooks_title')
      end
      
      def xp_title
        "%xh#{t('sheet.xp_title')}%xn"
      end
      
      def luck_title
        "%xh#{t('sheet.luck_title')}%xn"
      end
      
      def format_attr(a, i)
        name = "%xh#{a}:%xn"
        rating = FS3Skills.ability_rating(@char, a)
        dots = FS3Skills.print_attribute_rating(rating)
        linebreak = i % 2 == 1 ? "" : "%r"
        "#{linebreak}#{left(name, 21)} #{left(dots,16)}"
      end
      
      def format_skill(s, i)
        name = "%xh#{s}:%xn"
        rating = FS3Skills.ability_rating(@char, s)
        dots = FS3Skills.print_skill_rating(rating)
        ruling_attr = FS3Skills.get_ruling_attr(@char, s)[0]
        linebreak = i % 2 == 1 ? "" : "%r"
        "#{linebreak}#{left(name, 17)} (#{ruling_attr}) #{left(dots,16)}"
      end
      
      def format_section_title(title)
        center(" %xh#{title}%xn ", 78, '-')
      end
    end
  end
end