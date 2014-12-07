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
        right(t('sheet.profile_page_title'), 28)
      end
      
      def fullname_title
        format_field_title(t('sheet.fullname_title'))
      end

      def gender_title
        format_field_title(t('sheet.gender_title'))
      end

      def height_title
        format_field_title(t('sheet.height_title'))
      end

      def physique_title
        format_field_title(t('sheet.physique_title'))
      end

      def hair_title
        format_field_title(t('sheet.hair_title'))
      end

      def eyes_title
        format_field_title(t('sheet.eyes_title'))
      end

      def age_title
        format_field_title(t('sheet.age_title'))
      end

      def birthdate_title
        format_field_title(t('sheet.birthdate_title'))
      end
      
      def reputation_title
        "%xh#{t('sheet.reputation_title')}%xn #{t('sheet.reputation_subtitle')}"
      end
      
      def faction_title
        format_field_title(t('sheet.faction_title'))
      end
      
      def department_title
        format_field_title(t('sheet.department_title'))
      end
      
      def position_title
        format_field_title(t('sheet.position_title'))
      end
      
      def colony_title
        format_field_title(t('sheet.colony_title'))
      end
      
      def rank_title
        format_field_title(t('sheet.rank_title'))
      end
      
      def format_field_title(title)
        "%xh#{left(title, 12)}%xn"
      end
      
      def format_field(field)
        left("#{field}", 25)
      end
      
      def fullname
        format_field @char.fullname
      end
      
      def gender
        format_field @char.gender
      end
      
      def height
        format_field @char.height
      end
      
      def physique
        format_field @char.physique
      end
      
      def hair
        format_field @char.hair
      end
      
      def eyes
        format_field @char.eyes
      end
      
      def age
        age = @char.age
        format_field age == 0 ? "" : age
      end
      
      def birthdate
        format_field @char.birthdate.nil? ? "" : ICTime.ic_datestr(@char.birthdate)
      end
      
      def faction
        format_field @char.groups['Faction']
      end
      
      def position
        format_field @char.groups['Position']
      end
      
      def colony
        format_field @char.groups['Colony']
      end
      
      def department
        format_field @char.groups['Department']
      end

      def rank
        format_field @char.rank
      end
            
      def reputation
        @char.reputation
      end
    end
  end
end