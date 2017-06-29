module AresMUSH
  module Wikidot
    
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