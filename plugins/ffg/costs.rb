module AresMUSH
  module Ffg
    def self.characteristic_xp_cost(char, old_rating, new_rating)
      cost = 0
      rating = old_rating
      while rating < new_rating
        rating = rating + 1
        cost = cost + (rating * 10)
      end
      cost
    end
    
    def self.skill_xp_cost(char, skill_name, old_rating, new_rating)
      is_career = Ffg.is_career_skill?(char, skill_name)
      cost = 0
      rating = old_rating
      while rating < new_rating
        rating = rating + 1
        cost = cost + (rating * 5) + (is_career ? 0 : 5)
      end
      cost
    end
    
    def self.specialization_xp_cost(char, spec, num_current_specs)
      if (num_current_specs == 0)
        return 0
      end
      is_career = Ffg.is_career_specialization?(char, spec)
      ((num_current_specs + 1) * 10) + (is_career ? 0 : 10)
    end
    
    def self.talent_xp_cost(talent, current_rating, new_rating)
      config = Ffg.find_talent_config(talent)
      tier = config['tier'] || 1
      cost = 0
      rating = current_rating
      while rating < new_rating
        cost = cost + (rating + tier) * 5
        rating = rating + 1
      end
      cost
    end
    
    def self.talent_tree_balanced_for_add(char, tier)
      return true if tier == 1
      prior_tier = char.ffg_talents.select { |t| (t.tier == tier - 1) || (t.ranked && t.rating_plus_tier >= tier - 1) }
      current_tier = char.ffg_talents.select { |t| (t.tier == tier) || (t.ranked && t.rating_plus_tier >= tier) }
      
      return (prior_tier.count > current_tier.count + 1)
    end
    
    def self.talent_tree_balanced_for_remove(char, tier)
      return true if tier == 5
      next_tier = char.ffg_talents.select { |t| (t.tier == tier + 1) || (t.ranked && t.rating_plus_tier >= tier + 1) }
      current_tier = char.ffg_talents.select { |t| (t.tier == tier) || (t.ranked && t.rating_plus_tier >= tier) }
      
      return (current_tier.count - 1) >= (next_tier.count + 1)
    end
  end
end