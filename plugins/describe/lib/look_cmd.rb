module AresMUSH
  module Describe
    class LookCmd
      include CommandHandler
      
      attr_accessor :target, :detail
      
      def parse_args
        if (cmd.args =~ /\//)
          args = cmd.parse_args(ArgParser.arg1_slash_arg2)
          self.target = trim_arg(args.arg1)
          self.detail = titlecase_arg(args.arg2)          
        else
          self.target = trim_arg(cmd.args) || 'here'
          self.detail = nil
        end
      end
      
      def handle
        search = VisibleTargetFinder.find(self.target, enactor)
        if (self.detail)
          if (search.found?)
            show_detail(search.target, self.detail)
          else
            client.emit_failure search.error
          end
        else
           if (search.found?)
             show_desc(search.target)
           else
             search = VisibleTargetFinder.find("here", enactor)
             show_detail(search.target, self.target)
           end
        end
      end   
      
      def show_desc(model)
        template = Describe.desc_template(model, enactor)
        client.emit template.render
        if (model.class == Character)
          looked_at = model.client
          if (looked_at && model.desc_notify)
            looked_at.emit_ooc t('describe.looked_at_you', :name => enactor_name)
          end
        end
      end
      
      def show_detail(model, detail_name)
        detail_name = titlecase_arg(detail_name)
        if (!model.has_detail?(detail_name))
          client.emit_failure t("db.object_not_found")
          return
        end
        title = t('describe.detail_title', :name => model.name, :detail => detail_name)
        desc = model.detail(detail_name).description
        
        template = BorderedDisplayTemplate.new desc, title
        client.emit template.render
      end   
    end
  end
end
