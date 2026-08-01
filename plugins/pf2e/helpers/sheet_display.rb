module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Sheet display helpers
    # -------------------------------------------------

    # Full character sheet text (Ares ANSI/MUSH formatting).
    # Returns an error string if no sheet exists.
    def self.render_sheet(char)
      sheet = sheet_for(char)
      return t('pf2e.no_sheet') if !sheet

      SheetTemplate.new(char, sheet).render
    end

    # Compact combat sheet for in-fight reference.
    def self.render_combat_sheet(char)
      sheet = sheet_for(char)
      return t('pf2e.no_sheet') if !sheet

      CombatSheetTemplate.new(char, sheet).render
    end

  end
end
