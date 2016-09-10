module AresMUSH
  module Groups
    def self.app_review(char)
      message = t('groups.app_review')
      missing = []
      
      Groups.all_groups.keys.each do |g|
        if (char.groups[g].nil?)
          missing << t('chargen.are_you_sure', :missing => g)
        end
      end
      
      if (missing.count == 0)
        Chargen::Interface.format_review_status(message, t('chargen.ok'))
      else
        error = missing.collect { |m| "%R%T#{m}" }.join
        "#{message}%r#{error}"
      end
    end
  end
end