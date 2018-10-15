module AresMUSH
  module Fate
    def self.app_review(char)
      messages = Fate.review_stunts(char)
      messages << "%R"
      messages << Fate.review_aspects(char)
      messages << "%R"
      messages << Fate.review_skills(char)
    end
    
    
    def self.review_skills(char)
      
      errors = []
      skills = Global.read_config('fate', 'starting_skills')
      skills.each do |name, max|
        rating = Fate.name_to_rating(name)
        count = (char.fate_skills || {}).select { |k, v| v == rating }.count
        if (count > max)
          errors << t('fate.too_many_skills', :rating => rating, :max => max)
        end
      end
      
      message = t('fate.review_skills')
      
      if (errors.count == 0)
        Chargen.format_review_status(message, t('chargen.ok'))
      else
        error = errors.collect { |m| "%T#{m}" }.join("%R")
        message = Chargen.format_review_status(message, t('chargen.too_many'))
        "#{message}%r#{error}"
      end
    end
    
    
    def self.review_stunts(char)
      num_stunts = (char.fate_stunts || {}).count
      max = Global.read_config('fate', 'max_stunts')
      if (num_stunts > max)
        message = t('chargen.too_many')
      else
        message = t('chargen.ok')
      end
      
      Chargen.format_review_status(t('fate.review_num_stunts', :total => num_stunts, :max => max), message)
    end
    
    
    def self.review_aspects(char)
      num_aspects = (char.fate_aspects || {}).count
      max = Global.read_config('fate', 'max_starting_aspects')
      min = 2
      if (num_aspects > max)
        message = t('chargen.too_many')
      elsif (num_aspects < min)
        message = t('chargen.not_enough')
      else
        message = t('chargen.ok')
      end
      
      Chargen.format_review_status t('fate.review_num_aspects', :total => num_aspects, :max => max, :min => min), message
    end
  end
end
