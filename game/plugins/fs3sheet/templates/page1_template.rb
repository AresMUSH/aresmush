<<<<<<< HEAD
module AresMUSH
  module Sheet
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
        
        text << quirks_display()
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
      
      def quirks_display
        text = quirks_title()
        @char.fs3_quirks.each do |k, v|
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
        if (@char.on_roster?)
          status = "%xb%xh#{t('sheet.rostered')}%xn"
        elsif (@char.idled_out)
          status = "%xr%xh#{t('sheet.idled_out', :status => @char.idled_out)}%xn"
        elsif (!@char.is_approved?)
          status = "%xr%xh#{t('sheet.unapproved')}%xn"
        else
          status = "%xg%xh#{t('sheet.approved')}%xn"
        end        
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
=======
module AresMUSH
  module FS3Sheet
    class SheetPage1Template < AsyncTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char, client)
        @char = char
        super client
      end
      
      def build
        text = header_display()
        text << "%l2%r"

        text << aptitudes_display()
        text << "%r"
        
        text << action_skills_display()
        text << "%r"

        if (FS3Skills.advantages_enabled?)
          text << advantages_display()
          text << "%r"
        end
        
        text << expertise_display()

        text << interests_display()

        text << languages_display()
        
        text << hooks_display()
        text << "%r"

        text << goals_display()
        text << "%r%R"
        
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
      
      def aptitudes_display
        text = format_section_title t('sheet.aptitudes_title')
        @char.fs3_aptitudes.keys.sort.each_with_index do |a, i| 
          text << format_attr(a, i)
        end
        
        text
      end
        
      def action_skills_display
        text = format_section_title t('sheet.action_skills_title')
        @char.fs3_action_skills.keys.sort.each_with_index do |s, i| 
           text << format_skill(s, i)
         end
        
        text
      end
      
      def advantages_display
        text = format_section_title t('sheet.advantages_title')
        @char.fs3_advantages.keys.sort.each_with_index do |s, i| 
           text << format_skill(s, i)
         end
        
        text
      end
      
      def expertise_display
        display_list t('sheet.expertise_title'), @char.fs3_expertise
      end
      
      def interests_display
        display_list t('sheet.interests_title'), @char.fs3_interests
      end
      
      def languages_display
        display_list t('sheet.languages_title'), @char.fs3_languages, false
      end
      
      def hooks_display
        text = format_section_title t('sheet.hooks_title')
        @char.hooks.each do |k, v|
          text << "%R%xh#{k}:%xn #{v}"
        end
        text
      end
      
      def goals_display
        text = format_section_title t('sheet.goals_title')
        @char.goals.each do |k, v|
          text << "%R%xh#{k}:%xn #{v}"
        end
        text
      end
      
          
      def footer_display
        xp_title = "%xh#{t('sheet.xp_title')}%xn"
        luck_title = "%xh#{t('sheet.luck_title')}%xn"
        
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
        related_apt = print_related_apt(s)
        linebreak = i % 2 == 1 ? "" : "%r"
        "#{linebreak}#{left(name, 16)} #{related_apt} #{left(dots,16)}"
      end
      
      def format_section_title(title)
        center(" %xh#{title}%xn ", 78, '-')
      end
      
      def print_related_apt(skill)
        apt = FS3Skills.get_related_apt(@char, skill)
        apt.nil? ? "" : "(#{apt[0..2]})"
      end
      
      def display_list(title, list, show_related_apt = true)
        text = format_section_title(title)
        list.sort.each_with_index do |l, i|
          linebreak = i % 2 == 1 ? "" : "%r"
          if (show_related_apt)
            related_apt = " #{print_related_apt(l)}"
          else
            related_apt = ""
          end
          skill = "#{l}#{related_apt}"
          text << "#{linebreak}#{left(skill, 39)}"
        end
        text << "%R"
        text
      end
    end
  end
>>>>>>> upstream/master
end