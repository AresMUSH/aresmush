module AresMUSH
  module Bg
    def self.app_review(char)
      error = char.background.nil? ? t('chargen.not_set') : t('chargen.ok')
      Chargen.display_review_status t('bg.background_review'), error
    end
  end
end