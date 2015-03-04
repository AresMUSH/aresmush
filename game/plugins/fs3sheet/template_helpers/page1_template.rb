module AresMUSH
  module Sheet
    class SheetPage1Template
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
        right(t('sheet.abilities_page_title'), 28)
      end
      
      def attributes
        attrs = @char.fs3_attributes
        attrs.keys.each_with_index.map { |a, i| format_attr(a, i)}
      end

      def action_skills
        skills = @char.fs3_action_skills
        skills.keys.each_with_index.map { |s, i| format_skill(s, i)}
      end
      
      def background_skills
        skills = @char.fs3_background_skills
        skills.keys.each_with_index.map { |s, i| format_skill(s, i)}
      end
      
      def languages
        @char.fs3_languages.join(", ")
      end
      
      def quirks
        @char.fs3_quirks.each.map { |k, v| "%xh#{k}%xn - #{v}"}
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
      
      def quirks_title
        format_section_title t('sheet.quirks_title')
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
        "#{linebreak}#{left(name, 18)} #{left(dots,18)}"
      end
      
      def format_skill(s, i)
        name = "%xh#{s}:%xn"
        rating = FS3Skills.ability_rating(@char, s)
        dots = FS3Skills.print_skill_rating(rating)
        ruling_attr = FS3Skills.get_ruling_attr(@char, s)[0]
        linebreak = i % 2 == 1 ? "" : "%r"
        "#{linebreak}#{left(name, 18)} (#{ruling_attr}) #{left(dots,18)}"
      end
      
      def format_section_title(title)
        center(" %xh#{title}%xn ", 78, '-')
      end
    end
  end
end