module AresMUSH
  module SuperConsole
    def self.approval_status(char)
      if (char.on_roster?)
        status = "%xb%xh#{t('chargen.rostered')}%xn"
      elsif (char.is_npc?)
        status = "%xb%xh#{t('chargen.npc')}%xn"
      elsif (char.idled_out?)
        status = "%xr%xh#{t('chargen.idled_out', :status => char.idled_out_reason)}%xn"
      elsif (!char.is_approved?)
        status = "%xr%xh#{t('chargen.unapproved')}%xn"
      else
        status = "%xg%xh#{t('chargen.approved')}%xn"
      end
      status
    end
  end
end
