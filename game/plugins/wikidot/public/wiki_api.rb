module AresMUSH
  module Wikidot
    
    # Note!  Assumes you've already checked for all the log info fields being set.
    def self.create_log(scene, client, show_source_if_unsuccessul)
      
      template =  LogTemplate.new(scene)
      content = template.render
      tags = Wikidot.log_tags(scene)
      
      title = Wikidot.log_page_title(scene)
      page_name = Wikidot.log_page_name(scene)        

      Global.dispatcher.spawn("Creating wiki log page", client) do
          
        page_exists = Wikidot.page_exists?(page_name)
                      
        if (Wikidot.autopost_enabled? && !page_exists)
          error = Wikidot.create_page(page_name, title, content, tags)
          if (error)
            client.emit_failure error
          else
            client.emit_success t('wikidot.page_creation_successful')
          end
        elsif (show_source_if_unsuccessul)
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
        else
          client.emit_failure t('wikidot.autocreate_unsuccessful')
        end
      end
      
    end
    
    def self.page_exists?(page)
      begin
        wikidot = WikidotAPI::Client.new "#{Wikidot.site_name}-wiki", Wikidot.api_key
      
        args = {
            "page" => page,
            "site" => Wikidot.site_name,
        }
        page = wikidot.pages.get_one(args)
        return !!page
      rescue Exception => ex
        return false
      end
    end
    
    def self.create_page(page, title, content, tags = [])
      return t('wikidot.autopost_disabled') if !Wikidot.autopost_enabled?

      Global.logger.debug "Creating wiki page #{page}"
      
      begin
        wikidot = WikidotAPI::Client.new "#{Wikidot.site_name}-wiki", Wikidot.api_key
      
        args = {
            "title" => title,
            "content" => content,
            "page" => page,
            "site" => Wikidot.site_name,
            "tags" => tags
        }
        page = wikidot.pages.save_one(args)
        return page ? nil : t('wikidot.page_creation_failed')
      rescue Exception => ex
        return t('wikidot.page_creation_failed', :error => ex)
      end
    end
    
    def self.autopost_enabled?
      return false if Wikidot.api_key.blank?
      return false if Wikidot.site_name.blank?
      return false if !AresMUSH::Global.read_config('wikidot', 'autopost_enabled' )
      true
    end
  end
end