module AresMUSH
  class WikiPage < Ohm::Model
    include ObjectModel
    include FindByName
    
    attribute :name
    attribute :name_upcase
    attribute :title
    attribute :html

    attribute :tags, :type => DataType::Array, :default => []

    index :name_upcase
    
    collection :wiki_page_versions, "AresMUSH::WikiPageVersion"
    before_save :save_upcase
    before_delete :delete_versions
    
    def self.find_by_name_or_id(name_or_id)
      name_or_id = name_or_id.gsub(' ', '-').downcase
      page = WikiPage[name_or_id]
      if (!page)
        page = find_one_by_name(name_or_id)
      end
      page
    end
    
    def tags_text
      self.tags.join(" ")
    end
    
    def display_title
      self.title ? self.title : self.name.titleize
    end
    
    def current_version
      self.wiki_page_versions.to_a.reverse.first
    end
    
    def text
      latest = self.current_version
      latest ? latest.text : ""
    end
    
    def is_special_page?
      WikiPage.special_page_names.include?(self.name)
    end
    
    def self.special_page_names
      ['home']
    end
    
    
    def save_upcase
      self.name = AresMUSH::Website::FilenameSanitizer.sanitize(self.name)
      self.name_upcase = self.name ? self.name.upcase : nil
    end
    
    def delete_versions
      self.wiki_page_versions.each { |v| v.delete }
    end
  end
end