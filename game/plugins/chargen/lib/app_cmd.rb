module AresMUSH
  module Chargen
    class AppCmd
      include CommandHandler
      include CommandRequiresLogin
      
      attr_accessor :name

      def want_command?(client, cmd)
        cmd.root_is?("app") && cmd.switch.nil?
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
          if (model.is_approved)
            if (model == client.char)
              client.emit_failure t('chargen.you_are_already_approved')
            else
              client.emit_failure t('chargen.already_approved', :name => model.name)
            end
            return
          end
          
          title = t('chargen.app_title', :name => model.name)
          
          text = section_title(t('chargen.abilities_review_title'))
          text << FS3Skills.app_review(model)
          text << "%r%r"
          text << section_title(t('chargen.goals_review_title'))
          text << FS3Skills.app_goals_review(model)
          text << "%r%r"
          text << section_title(t('chargen.demographics_review_title'))
          text << Demographics::Interface.app_review(model)
          text << "%r%r"
          text << section_title(t('chargen.groups_review_title'))
          text << Groups.app_review(model)
          text << "%r%r"
          text << section_title(t('chargen.misc_review_title'))
          text << Chargen.bg_app_review(model)
          text << "%r"
          text << Describe::Interface.app_review(model)
          text << "%r"
          text << Ranks.app_review(model)
          text << "%r%r"
          text << section_title(t('chargen.app_review_title'))
          
          if (model.approval_job)
            number = model.approval_job.number
            if (client.name == self.name)
              text << t('chargen.app_request', :job => number)
            else
              text <<  t('chargen.app_job', :job => number)
            end
          else
              text <<  t('chargen.app_not_started')
          end

          text << "%r%r"
          text << t('chargen.review_summary')
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