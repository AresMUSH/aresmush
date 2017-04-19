module AresMUSH
  module Demographics
    class CensusCmd
      include CommandHandler
      
      attr_accessor :name
     
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def handle   
        chars = Idle::Api.active_chars
        if (!self.name)
          paginator = Paginator.paginate(chars.sort_by { |c| c.name }, cmd.page, 20)
          if (paginator.out_of_bounds?)
            client.emit_failure paginator.out_of_bounds_msg
            return
          end
          template = CompleteCensusTemplate.new(paginator)
        elsif (self.name == "Gender")
          template = GenderCensusTemplate.new
        else
          group = Demographics.get_group(self.name)
          if (!group)
            client.emit_failure t('demographics.invalid_group_type')
            return
          end
          template = GroupCensusTemplate.new(group, self.name)    
        end
        client.emit template.render
      end
    end
  end
end
