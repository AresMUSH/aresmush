module AresMUSH
  module Page
    class PageDoNotDisturbCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandRequiresArgs

      attr_accessor :option
      
      def crack!
        self.option = OnOffOption.new(cmd.args)
      end
      
      def required_args
        {
          args: [ self.option ],
          help: 'page'
        }
      end
      
      def check_status
        return self.option.validate
      end
      
      def handle
        prefs = enactor.page_prefs
        if (prefs)
          prefs.update(do_not_disturb: self.option.is_on?)
        else
          prefs = PagePrefs.create(character: enactor, do_not_disturb: self.option.is_on?)
          enactor.update(page_prefs: prefs)
        end
        client.emit_success t('page.do_not_disturb_set', :status => self.option)
      end
    end
  end
end
