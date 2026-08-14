module AresMUSH
  module Pf2e

    # -------------------------------------------------
    # Sheet display helpers
    # -------------------------------------------------

    def self.render_sheet(char)
      sheet = sheet_for(char)
      return t('pf2e.no_sheet') if !sheet

      SheetTemplate.new(char, sheet).render
    end

    def self.render_combat_sheet(char)
      sheet = sheet_for(char)
      return t('pf2e.no_sheet') if !sheet

      CombatSheetTemplate.new(char, sheet).render
    end

    def self.render_inventory(char, filter_kind: nil)
      sheet = sheet_for(char)
      return t('pf2e.no_sheet') if !sheet

      InventoryTemplate.new(char, sheet, filter_kind: filter_kind).render
    end

  end
end
