module AresMUSH
  module Forum
    class ForumHideCmd
      include CommandHandler
      
      attr_accessor :hide, :category_name
      
      def parse_args
        self.hide = cmd.switch_is?("hide") ? true : false
        self.category_name = titlecase_arg(cmd.args)
      end
      
      def handle       
        Forum.with_a_category(self.category_name, client, enactor) do |category|  
          prefs = Forum.get_forum_prefs(enactor, category)
          if (!prefs)
            prefs = BbsPrefs.create(bbs_board: category, character: enactor)
          end
          prefs.update(hidden: self.hide)
          if (self.hide)
            client.emit_success t('forum.category_hidden', :name => self.category_name)
          else
            client.emit_success t('forum.category_shown', :name => self.category_name)
          end
        end
      end
    end
  end
end
