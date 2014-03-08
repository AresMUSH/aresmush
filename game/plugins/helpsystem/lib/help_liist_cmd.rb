module AresMUSH
  module Help
    
    class HelpListCmd
      include AresMUSH::Plugin
      attr_accessor :category
      
      def want_command?(client, cmd)
        Help.valid_commands.include?(cmd.root) && cmd.args.nil?
      end

      def crack!
        self.category = Help.category_for_command(cmd.root)
      end
      
      # TODO - Validate permissions
      
      def handle
        toc = Global.help[self.category]["toc"]
        topics = []
        toc.keys.each do |key|
          topics << "     %xh#{key.titlecase}%xn - #{toc[key]}"
        end
        title = t('help.toc', :category => Help.category_title(self.category))
        client.emit BorderedDisplay.list(topics, title.center(78))
      end
    end
  end
end
