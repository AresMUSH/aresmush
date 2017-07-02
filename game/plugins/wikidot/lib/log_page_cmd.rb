module AresMUSH
  module Wikidot
    class LogPageCmd
      include CommandHandler
      
      attr_accessor :scene

      def parse_args
        self.scene = integer_arg(cmd.args)
      end
      
      def required_args
        {
          args: [ self.scene ],
          help: 'wiki'
        }
      end
      
      def handle
        scene = Scene[self.scene]
        if (!scene)
          client.emit_failure t('scenes.scene_not_found')
          return
        end
        
        if (!Scenes.can_access_scene?(enactor, scene))
          client.emit_failure t('scenes.access_not_allowed')
          return
        end

        if (!scene.completed)
          client.emit_failure t('wikidot.only_completed_logs')
          return
        end
        
        if (!scene.all_info_set?)
          client.emit_failure t('scenes.scene_info_missing', :title => scene.title || "??", 
             :summary => scene.summary || "??", 
             :type => scene.scene_type || "??", 
             :location => scene.location || "??")
          return
        end
        
        template =  LogTemplate.new(scene)
        content = template.render
        tags = Wikidot.log_tags(scene)
        
        title = "#{scene.icdate} - #{scene.title}"
        page_name = Wikidot.log_page_name(scene)        
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
