module AresMUSH
  module Ranks
    def self.app_review(char)
      message = t('ranks.app_review')
      
      if (char.rank.nil?)
        status = t('chargen.are_you_sure', :missing => t('ranks.review_rank_missing'))
      elsif Ranks.check_rank(char, char.rank, false)
        status = t('ranks.review_rank_invalid')
      else
        status = t('chargen.ok')
      end
      
      Chargen::Interface.format_review_status(message, status)
    end
  end
end