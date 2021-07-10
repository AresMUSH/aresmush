module AresMUSH
  class PageThread < Ohm::Model
    include ObjectModel

    collection :page_messages, "AresMUSH::PageMessage"
    set :characters, "AresMUSH::Character"
    
    attribute :custom_titles, :type => DataType::Hash, :default => {}
    
    before_delete :delete_pages
    
    def delete_pages
      self.page_messages.each { |p| p.delete }
    end
    
    def title_customized(viewer)
      custom = (self.custom_titles || {})["#{viewer.id}"]
      custom ? custom : title_without_viewer(viewer)
    end
    
    def title
      self.characters.to_a.sort_by { |c| c.name }.map { |c| c.name }.join(" ")
    end
    
    def title_without_viewer(viewer)
      #self.characters.to_a.select { |c| c != viewer }.sort_by { |c| c.name }.map { |c| c.name }.join(" ")
      self.characters.to_a.sort_by { |c| [AresCentral.is_alt?(c, viewer) ? 0 : 1, c.name] }.map { |c| c.name }.join(" ")
    end
    
    def sorted_messages
      self.page_messages.to_a.sort_by { |p| p.created_at }
    end
    
    def last_activity
      last_message = self.sorted_messages.to_a[-1]
      last_message ? last_message.created_at : DateTime.new
    end
    
    def is_hidden?(enactor)
      (enactor.hidden_page_threads || []).include?("#{self.id}")
    end
    
    def can_view?(viewer)
      (self.characters.to_a & AresCentral.play_screen_alts(viewer)).any?
    end
  end
  
  class PageMessage < Ohm::Model
    include ObjectModel

    reference :page_thread, "AresMUSH::PageThread"
    reference :author, "AresMUSH::Character"
    attribute :message
    
    def author_name
      self.author ? self.author.name : t('global.deleted_character')
    end
  end
end