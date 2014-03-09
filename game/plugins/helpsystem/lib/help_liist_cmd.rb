module AresMUSH
  module HelpSystem
    
    class HelpListCmd
      include AresMUSH::Plugin
      attr_accessor :category
      
      no_switches
      
      def want_command?(client, cmd)
        HelpSystem.valid_commands.include?(cmd.root) && cmd.args.nil?
      end

      def crack!
        self.category = HelpSystem.category_for_command(cmd.root)
      end
      
      # TODO - Validate permissions
      
      def handle
        toc = HelpSystem.category(self.category)["toc"]
        raise IndexError, "Category #{self.category} does not have a table of contents." if toc.nil?
        topics = []
        toc.keys.each do |key|
          topics << "     %xh#{key.titlecase}%xn - #{toc[key]}"
        end
        title = t('help.toc', :category => HelpSystem.category_title(self.category))
        client.emit BorderedDisplay.list(topics, title)
      end
    end
  end
end
