module AresMUSH
  module FS3Skills
    # If you want more than one character sheet page, create a class for it
    # (like SheetPage2Template) and add it to this list.
    def self.sheet_templates
      [ SheetPage1Template ]
    end
  end
end