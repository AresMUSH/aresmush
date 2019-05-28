module AresMUSH
  module SuperConsole
    def self.approval_status(char)
      if (char.on_roster?)
        status = "%xb%xh#{t('superconsole.rostered')}%xn"
      elsif (char.is_npc?)
        status = "%xb%xh#{t('superconsole.npc')}%xn"
      elsif (char.idled_out?)
        status = "%xr%xh#{t('superconsole.idled_out', :status => char.idled_out_reason)}%xn"
      elsif (!char.is_approved?)
        status = "%xr%xh#{t('superconsole.unapproved')}%xn"
      else
        status = "%xg%xh#{t('superconsole.approved')}%xn"
      end
      status
    end
  end
end
