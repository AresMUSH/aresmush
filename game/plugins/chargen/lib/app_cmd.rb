module AresMUSH
  module Chargen
    class AppCmd
      include Plugin
      include PluginRequiresLogin
      
      attr_accessor :name

      def want_command?(client, cmd)
        cmd.root_is?("app")
      end

      def crack!
        self.name = cmd.args.nil? ? client.name : trim_input(cmd.args)
      end
      
      def check_can_review
        return nil if self.name == client.name
        return nil if Chargen.can_approve?(client.char)
        return t('dispatcher.not_allowed')
      end
      
      def handle        
        ClassTargetFinder.with_a_character(self.name, client) do |model|
          if (model.is_approved?)
            client.emit_failure t('chargen.already_approved')
            return
          end
          
          title = t('chargen.app_title', :name => model.name)
          
          text = section_title(t('chargen.abilities_review_title'))
          text << FS3Skills.app_review(model)
          text << "%r%r"
          text << section_title(t('chargen.demographics_review_title'))
          text << Demographics.app_review(model)
          text << "%r%r"
          text << section_title(t('chargen.groups_review_title'))
          text << Groups.app_review(model)
          text << "%r%r"
          text << section_title(t('chargen.misc_review_title'))
          text << Bg.app_review(model)
          text << "%r"
          text << Describe.app_review(model)
          text << "%r%r"
          text << t('chargen.review_summary')
          
          #client.emit list.inspect
          
          client.emit BorderedDisplay.text text, title
        end
      end
      
      def section_title(title)
        title = " #{title} ".center(78, '-')
        "%x!%xh#{title}%xH%xn%r"
      end
    end
  end
end