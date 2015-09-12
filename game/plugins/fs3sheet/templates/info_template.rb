module AresMUSH
  module FS3Sheet
    class InfoTemplate < AsyncTemplateRenderer
      include TemplateFormatters
      
      attr_accessor :char
      
      def initialize(char, client)
        @char = char
        super client
      end
      
      def build
        text = "%l1%r"
        text << "%xh#{name}%xn #{approval_status} #{page_title}%r"
        text << "%l2%r"
        text << "#{fullname_title} #{fullname}%r"
        text << "#{actor_title} #{actor}%r"
        text << "#{gender_title} #{gender} #{skin_title} #{skin}%r"
        text << "#{height_title} #{height} #{physique_title} #{physique}%r"
        text << "#{hair_title} #{hair} #{eyes_title} #{eyes}%r"
        text << "#{age_title} #{age} #{birthdate_title} #{birthdate}%r"
        
        text << "%l2%r"

        text << "#{colony_title} #{colony} #{position_title} #{position}%r"
        text << "#{faction_title} #{faction} #{department_title} #{department}%r"
        text << "#{rank_title} #{rank} #{callsign_title} #{callsign}%r"

        text << "%l1"

        text
      end
        
      def name
        @char.name
      end
      
      def actor
        @char.actor
      end
      
      def approval_status
        status = Chargen.approval_status(@char)
        center(status, 23)
      end
      
      def page_title
        right(t('sheet.info_title'), 28)
      end
      
      def fullname_title
        format_field_title(t('sheet.fullname_title'))
      end
      
      def actor_title
        format_field_title(t('sheet.actor_title'))
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
      
      def skin_title
        format_field_title(t('sheet.skin_title'))
      end

      def age_title
        format_field_title(t('sheet.age_title'))
      end

      def birthdate_title
        format_field_title(t('sheet.birthdate_title'))
      end
      
      def info_title
        "%xh#{t('sheet.info_title')}%xn"
      end
      
      def callsign_title
        format_field_title(t('sheet.callsign_title'))
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
        @char.fullname
      end
      
      def callsign
        format_field @char.callsign
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
      
      def skin
        format_field @char.skin
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
    end
  end
end