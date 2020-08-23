module AresMUSH
  module Ranks
    def self.can_manage_ranks?(actor)
      actor && actor.has_permission?("manage_ranks")
    end

    def self.rank_group
      Global.read_config("ranks", "rank_group")
    end
    
    def self.group_rank_config(group)
      all_groups = Global.read_config("ranks", "ranks")
      all_groups.select { |k, v| k.upcase == group.upcase}.values.first
    end
    
    def self.all_ranks_for_group(group)
      config = Ranks.group_rank_config(group)
      return nil if !config
      config.values.collect { |t| t.keys }.flatten
    end
    
    def self.allowed_ranks_for_group(group)
      config = Ranks.group_rank_config(group)
      return [] if !config
      ranks = []
      config.values.each do |t|
        ranks << t.select { |t, v| v }
      end
      ranks.collect { |r| r.keys }.flatten
    end
    
    def self.check_rank(char, rank, allow_all)
      return nil if !rank
      
      group = char.group(Ranks.rank_group)
      
      if (!group)
        return t('ranks.rank_group_not_set', :group => Ranks.rank_group)
      end
      
      if (allow_all)
        ranks = Ranks.all_ranks_for_group(group)
      else
        ranks = Ranks.allowed_ranks_for_group(group)
      end
      
      if (!ranks)
        return t('ranks.no_ranks_for_group', :group => group)
      end
      
      if (rank.blank?)
        return nil
      end
      
      found = ranks.find { |r| r.downcase == rank.downcase }
      if (!found)
        return t('ranks.invalid_rank_for_group', :group => group)
      end
      
      return nil
    end
  end
end