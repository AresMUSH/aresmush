<<<<<<< HEAD
module AresMUSH
  module Sheet
    def self.sheet_templates
      [ SheetPage1Template, 
        SheetPage2Template, 
        SheetPage3Template ]
    end
  end
=======
module AresMUSH
  module FS3Sheet
    # If you want more than one character sheet page, create a class for it
    # (like SheetPage2Template) and add it to this list.
    def self.sheet_templates
      [ SheetPage1Template ]
    end
  end
>>>>>>> upstream/master
end