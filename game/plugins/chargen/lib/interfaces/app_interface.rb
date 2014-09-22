module AresMUSH
  module Chargen
    def self.display_review_status(msg, error)
      "#{msg.ljust(50)} #{error}"
    end
    
    def self.check_chargen_locked(char)
      hold_status = Global.config["chargen"]["jobs"]["app_hold_status"]
      return t('chargen.cant_be_changed') if char.is_approved
      return t('chargen.app_in_progress') if char.chargen_locked
      return nil
    end
  end
end