module AresMUSH
  module Demographics
    def self.app_review(char)
      message = t('demographics.demo_review')
      
      required_properties = Global.read_config("demographics", "required_properties")
      missing = []
      
      required_properties.each do |property|
        if (char.send("#{property}").nil?)
          missing << t('chargen.oops_missing', :missing => property)
        end
      end
      
      if (char.gender == "other")
        missing << "%xy%xh#{t('demographics.gender_set_to_other')}%xn"
      end
      
      if (missing.count == 0)
        Chargen.display_review_status(message, t('chargen.ok'))
      else
        error = missing.collect { |m| "%R%T#{m}" }.join
        "#{message}%r#{error}"
      end
    end
  end
end