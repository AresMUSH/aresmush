module AresMUSH
  module Profile
    def self.relationships_by_category(char)
      relations = char.relationships.group_by { |name, data| data['category'] }
      relations.sort_by { |category, relations| Profile.category_order(char, category) }
    end
    
    def self.category_order(char, category)
      char.relationships_category_order.index(category) || (category[0] || "1").ord
    end
    
    def self.can_manage_char_profile?(actor, char)
      return false if !actor
      return true if actor.is_admin?
      return true if actor == char
      
      return AresCentral.is_alt?(actor, char)
    end
    
    def self.get_profile_status_message(char)
      case char.idle_state
      when "Roster"
        return t('profile.char_on_roster')
      when "Gone"
        return t('profile.char_gone')
      when "Dead"
        return t('profile.char_dead')
      else
        if (char.is_npc?)
          return t('profile.char_is_npc')
        elsif (char.is_admin?)
          return t('profile.char_is_admin')
        elsif (char.is_playerbit?)
          return t('profile.char_is_playerbit')
        elsif (!char.is_approved?)
          return t('profile.char_not_approved')
        else
          return nil
        end
      end
    end
  end
end