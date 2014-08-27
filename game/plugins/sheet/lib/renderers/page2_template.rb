module AresMUSH
  module Sheet
    class SheetPage2Template
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
      end
      
      def name
        left(@char.name, 25)
      end
      
      def approval_status
        status = @char.is_approved ? 
        "%xg%xh#{t('sheet.approved')}%xn" : 
        "%xr%xh#{t('sheet.unapproved')}%xn"
        center(status, 23)
      end
      
      def page_title
        right(t('sheet.page2_title'), 28)
      end
      
      def attributes
        attrs = @char.fs3_attributes
        attrs.keys.each_with_index.map { |a, i| format_attr(attrs, a, i)}
      end

      def action_skills
        skills = @char.action_skills
        skills.keys.each_with_index.map { |s, i| format_skill(skills, s, i)}
      end
      
      def attributes_title
        format_section_title t('fs3skills.attributes_title')
      end

      def action_skills_title
        format_section_title t('fs3skills.action_skills_title')
      end
      
      def format_attr(attrs, a, i)
        name = "%xh#{a}:%xn"
        rating = FS3Skills.print_attribute_rating(attrs[a])
        linebreak = i % 2 == 0 ? "" : "%r"
        "#{left(name, 18)} #{left(rating,18)}#{linebreak}"
      end
      
      def format_skill(skills, s, i)
        name = "%xh#{s}:%xn"
        rating = FS3Skills.print_skill_rating(skills[s])
        linebreak = i % 2 == 0 ? "" : "%r"
        "#{left(name, 18)} #{left(rating,18)}#{linebreak}"
      end
      
      def format_section_title(title)
        center(" %xh#{title}%xn ", 78, '-')
      end
    end
  end
end