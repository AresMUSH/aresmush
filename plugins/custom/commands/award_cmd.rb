module AresMUSH
  
  module Custom
    class AwardCmd
      include CommandHandler
      
      attr_accessor :name, :award, :citation
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2_slash_optional_arg3)
        
        self.name = args.arg1
        self.award = titlecase_arg(args.arg2)
        self.citation = args.arg3
      end
      
      def check_admin
        return t('dispatcher.not_allowed') if (!enactor.is_admin?)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          
          MedalAward.create(character: model, award: self.award, citation: self.citation)
          client.emit_success "Award given."
        end
      end
    end


    class AwardRemoveCmd
      include CommandHandler
      
      attr_accessor :name, :award
      
      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        
        self.name = args.arg1
        self.award = titlecase_arg(args.arg2)
      end
      
      def check_admin
        return t('dispatcher.not_allowed') if (!enactor.is_admin?)
        return nil
      end
      
      def handle
        ClassTargetFinder.with_a_character(self.name, client, enactor) do |model|
          
          award = model.awards.select { |a| a.award == self.award }.first
          if (award)
            award.delete
            client.emit_success "Award removed."
          else
            client.emit_failure "Award not found."
          end
        end
      end
    end
  end
end
