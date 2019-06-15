module AresMUSH
  module Demographics
    class CensusCmd
      include CommandHandler
      
      attr_accessor :name
     
      def parse_args
        self.name = titlecase_arg(cmd.args)
      end
      
      def check_type
        types = Demographics.census_types
        return t('demographics.invalid_census_type', :types => types.join(',')) if !types.include?(self.name)
        return nil
      end
      
      def handle   
        chars = Chargen.approved_chars
        paginator = Paginator.paginate(chars.sort_by { |c| c.name }, cmd.page, 20)
        if (paginator.out_of_bounds?)
          client.emit_failure paginator.out_of_bounds_msg
          return
        end
        if (!self.name)
          template = CompleteCensusTemplate.new(paginator)
        elsif (self.name == "Timezone" || self.name == "Timezones")
          template = TimezoneCensusTemplate.new
        elsif (self.name == "Genders" || self.name == "Gender")
          template = GenderCensusTemplate.new
        elsif (self.name == "Played By")
          template = ActorsCensusTemplate.new(paginator)
        elsif (Ranks.is_enabled? && (self.name == "Ranks" || self.name == "Rank"))
          template = RankCensusTemplate.new
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
