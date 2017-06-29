module AresMUSH
  module Wikidot
    class LogPageCmd
      include CommandHandler
      
      attr_accessor :scene, :log_type

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        
        self.scene = args.arg1
        self.log_type = downcase_arg(args.arg2)
      end
      
      def required_args
        {
          args: [ self.scene, self.log_type ],
          help: 'wiki'
        }
      end
      
      def check_log_type
        if (!Wikidot.log_types.include?(self.log_type))          
          return t('wikidot.invalid_log_type', :types => Wikidot.log_types.join(", "))
        end
        
        return nil
      end
      
      def handle
        result = Scenes.get_log(self.scene, enactor)
        
        if (result[:error])
          client.emit_failure result[:error]
          return
        end
        
        log = result[:log]
        template =  LogTemplate.new(log)
        content = template.render
        tags = Wikidot.log_tags(log, self.log_type)
        icdate = log.ictime ? Wikidot.format_log_date(log.ictime) : "TODO DATE"
        
        title = "#{icdate} - #{log.title}"
        page_name = Wikidot.log_page_name(title, self.log_type)

        client.emit_ooc t('wikidot.creating_page')

        Global.dispatcher.spawn("Creating wiki log page", client) do
            
          page_exists = Wikidot.page_exists?(page_name)
                        
          if (Wikidot.autopost_enabled? && !page_exists)
            error = Wikidot.create_page(page_name, title, content, tags)
            if (error)
              client.emit_failure error
            else
              client.emit_success t('wikidot.page_creation_successful')
            end
          else
            message = ""
            if (page_exists)
              message << t('wikidot.page_already_exists')
              message << "%r%% "
            end
            message << t('wikidot.template_provided')
            message << "%r%% "
            message << t('wikidot.page_tags', :tags => tags.join(" "))

            client.emit content
            client.emit_ooc message
          end
        end
      end
    end
  end
end
