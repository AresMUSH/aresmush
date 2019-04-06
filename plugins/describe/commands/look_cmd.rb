module AresMUSH
  module Describe
    class LookCmd
      include CommandHandler
      
      attr_accessor :targets
      
      def parse_args
        self.targets = list_arg(cmd.args, ',') || ['here']
      end
      
      def handle
        self.targets.each do |target|
          if (target =~ /\//)
            detail = target.after('/')
            target = target.before('/')
          else
            detail = nil
          end
          
          search = AnyTargetFinder.find(target, enactor)
          if (detail)
            if (search.found?)
              show_detail(search.target, detail)
            else
              client.emit_failure search.error
            end
          else
             if (search.found?)
               show_desc(search.target)
             else
               show_detail(enactor_room, target)
             end
          end
        end
      end
      
      def show_desc(model)
        template = Describe.desc_template(model, enactor)
        client.emit template.render
        if (model.class == Character && model.desc_notify)
           Login.emit_ooc_if_logged_in(model,  t('describe.looked_at_you', :name => enactor_name))
        end
      end
      
      def show_detail(model, detail_name)
        detail_name = titlecase_arg(detail_name)
        if (!model.details.has_key?(detail_name))
          client.emit_failure t("db.object_not_found")
          return
        end
        title = t('describe.detail_title', :name => model.name, :detail => detail_name)
        desc = model.details[detail_name]
        
        template = BorderedDisplayTemplate.new desc, title
        client.emit template.render
      end   
    end
  end
end
