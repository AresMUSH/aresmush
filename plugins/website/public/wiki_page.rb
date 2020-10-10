module AresMUSH
  class WikiPage < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    attribute :title
    attribute :preview, :type => DataType::Hash, :default => {}
    attribute :draft, :type => DataType::Hash, :default => {}
    attribute :tags, :type => DataType::Array, :default => []
    attribute :locked_time, :type => DataType::Time
    
    index :name_upcase
    
    reference :locked_by, "AresMUSH::Character"
    
    collection :wiki_page_versions, "AresMUSH::WikiPageVersion"
    before_delete :delete_versions
    before_save :save_upcase
    
    def self.sanitize_page_name(name)
      name = name || ""
      name = name.strip
      name = name.gsub(/[^0-9A-Za-z.:\-]/, '_')
      name.downcase
    end
    
    def self.find_by_name_or_id(name_or_id)
      name_or_id = WikiPage.sanitize_page_name(name_or_id)
      
      alias_config = Global.read_config("website", "wiki_aliases") || {}
      aliases = {}
      alias_config.each do |k, v|
        aliases[WikiPage.sanitize_page_name(k.downcase)] = WikiPage.sanitize_page_name(v.downcase)
      end
      
      if (aliases[name_or_id.downcase])
        name_or_id = aliases[name_or_id.downcase]
      end
      
      page = WikiPage[name_or_id]
      if (!page)
        page = find_one_by_name(name_or_id)
      end
      page
    end
    
    def tags_text
      self.tags.join(" ")
    end
    
    def heading
      !self.title.blank? ? self.title : self.name.titleize
    end
    
    def current_version
      sorted_versions.reverse.first
    end
    
    def sorted_versions
      self.wiki_page_versions.to_a.sort_by { |v| v.created_at }
    end
    
    def last_edited
      ver = self.current_version 
      ver ? ver.created_at : self.updated_at
    end
    
    def text
      latest = self.current_version
      latest ? latest.text : ""
    end
        
    def category
      self.name.before(":")
    end
    
    def save_upcase
      self.name = WikiPage.sanitize_page_name(self.name)
      self.name_upcase = self.name ? self.name.upcase : nil
    end
    
    def delete_versions
      self.wiki_page_versions.each { |v| v.delete }
    end
    
    def get_lock_info(enactor)
      if (self.locked_by && (self.locked_by != enactor))
        expiry_time = self.locked_time + 60*15
        if (Time.now  < expiry_time)
          return { locked_by: self.locked_by.name, 
                   time: OOCTime.local_long_timestr(enactor, expiry_time) }
        end
      else
        return nil
      end
    end
  end
end