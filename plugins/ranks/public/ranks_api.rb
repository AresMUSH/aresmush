module AresMUSH
  module Ranks
    def self.is_enabled?
      !Global.plugin_manager.is_disabled?("ranks")
    end
    
    def self.app_review(char)
      message = t('ranks.app_review')
      
      if (!char.rank)
        status = t('chargen.are_you_sure', :missing => t('ranks.review_rank_missing'))
      elsif Ranks.check_rank(char, char.rank, false)
        status = t('ranks.review_rank_invalid')
      else
        status = t('chargen.ok')
      end
      
      Chargen.format_review_status(message, status)
    end
    
    def self.military_name(char)
      names = char.fullname.split(" ")
      if names.count == 1
        first_name = names[0]
        last_name = ""
      else
        first_name = names[0]
        last_name = names[-1]
      end
      rank_str = char.rank.blank? ? "" : "#{char.rank} "
      callsign = char.demographic(:callsign)
      callsign_str =  callsign.blank? ? "" : "\"#{callsign}\" "
      "#{rank_str}#{first_name} #{callsign_str}#{last_name}"
    end
    
    def self.set_rank(char, rank, allow_all = false)
      error = Ranks.check_rank(char, rank, allow_all)
      return error if error
      char.update(ranks_rank: rank)
      return nil
    end
    
    def self.build_rank_group_data(groups_data)
      return {} if !Ranks.is_enabled?

      ranks = []
      
      rank_group = Demographics.get_group(Ranks.rank_group)
      return {} if !rank_group
      
      rank_group['values'].each do |k, v|
        Ranks.allowed_ranks_for_group(k).each do |r|
          ranks << { name: 'Rank', value: r, desc: k }
        end
      end
      
      groups_data['rank'] = {
        name: 'Rank',
        desc: Global.read_config('chargen', 'rank_blurb'),
        values: ranks
      }
      
      groups_data['all_ranks'] = Global.read_config('ranks', 'ranks')
    end
    
    def self.build_web_profile_data(char, viewer)
      {
        military_name: Ranks.military_name(char)
      }
    end
  end
end