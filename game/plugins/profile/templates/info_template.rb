module AresMUSH
  module Profile
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
        Actors::Api.get_actor(@char)
      end
      
      def approval_status
        status = Chargen::Api.approval_status(@char)
        center(status, 23)
      end
      
      def page_title
        right(t('profile.info_title'), 28)
      end
      
      def fullname_title
        format_field_title(t('profile.fullname_title'))
      end
      
      def actor_title
        format_field_title(t('profile.actor_title'))
      end

      def gender_title
        format_field_title(t('profile.gender_title'))
      end

      def height_title
        format_field_title(t('profile.height_title'))
      end

      def physique_title
        format_field_title(t('profile.physique_title'))
      end

      def hair_title
        format_field_title(t('profile.hair_title'))
      end

      def eyes_title
        format_field_title(t('profile.eyes_title'))
      end
      
      def skin_title
        format_field_title(t('profile.skin_title'))
      end

      def age_title
        format_field_title(t('profile.age_title'))
      end

      def birthdate_title
        format_field_title(t('profile.birthdate_title'))
      end
      
      def info_title
        "%xh#{t('profile.info_title')}%xn"
      end
      
      def callsign_title
        format_field_title(t('profile.callsign_title'))
      end
      
      def faction_title
        format_field_title(t('profile.faction_title'))
      end
      
      def department_title
        format_field_title(t('profile.department_title'))
      end
      
      def position_title
        format_field_title(t('profile.position_title'))
      end
      
      def colony_title
        format_field_title(t('profile.colony_title'))
      end
      
      def rank_title
        format_field_title(t('profile.rank_title'))
      end
      
      def format_field_title(title)
        "%xh#{left(title, 12)}%xn"
      end
      
      def format_field(field)
        left("#{field}", 25)
      end
      
      def fullname
        Demographics::Api.fullname(@char)
      end
      
      def callsign
        format_field Demographics::Api.demographic(@char, :callsign)
      end
      
      def gender
        format_field Demographics::Api.gender(@char)
      end
      
      def height
        format_field Demographics::Api.demographic(@char, :height)
      end
      
      def physique
        format_field Demographics::Api.demographic(@char, :physique)
      end
      
      def hair
        format_field Demographics::Api.demographic(@char, :hair)
      end
      
      def eyes
        format_field Demographics::Api.demographic(@char, :eyes)
      end
      
      def skin
        format_field Demographics::Api.demographic(@char, :skin)
      end
      
      def age
        age = Demographics::Api.age(@char)
        format_field age == 0 ? "" : age
      end
      
      def birthdate
        dob = Demographics::Api.demographic(@char, :birthdate)
        format_field dob.nil? ? "" : ICTime::Api.ic_datestr(dob)
      end
      
      def faction
        format_field Groups::Api.group(@char, "Faction")
      end
      
      def position
        format_field Groups::Api.group(@char, "Position")
      end
      
      def colony
        format_field Groups::Api.group(@char, "Colony")
      end
      
      def department
        format_field Groups::Api.group(@char, "Department")
      end

      def rank
        format_field Ranks::Api.rank(@char)
      end
    end
  end
end