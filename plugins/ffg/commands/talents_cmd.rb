module AresMUSH    
  module Ffg
    class TalentsCmd
      include CommandHandler
  
      attr_accessor :spec_filter
      
      def parse_args
        if (cmd.switch_is?("spec"))
          self.spec_filter = titlecase_arg(cmd.args)
        end
      end
      
      def handle    
        talents = Global.read_config("ffg", "talents").sort_by { |t| [ t['tier'], t['name'] ]}
        if (self.spec_filter)
          talents = talents.select { |t| !t['specializations'] || t['specializations'].empty? || t['specializations'].include?(self.spec_filter) }
        end
        paginator = Paginator.paginate(talents, cmd.page, 25)
        template = TalentsTemplate.new(paginator)
        client.emit template.render
      end
    end
  end
end