module AresMUSH
  class Character
    attribute :last_paged, :type => DataType::Array, :default => []
    attribute :page_do_not_disturb, :type => DataType::Boolean
    attribute :page_autospace, :default => "%r"
    attribute :page_color
    attribute :page_monitor, :type => DataType::Hash, :default => {}
    set :page_ignored, "AresMUSH::Character"

    # OBSOLETE - use read_tracker instead
    attribute :read_page_threads, :type => DataType::Array, :default => []

    before_delete :delete_pages

    def page_threads
      PageThread.all.select { |p| p.characters.include?(self) }
    end
    
    def sorted_page_threads
      self.page_threads
         .to_a
         .sort_by { |t| [ Page.is_thread_unread?(t, self) ? 1 : 0, t.last_activity ] }
         .reverse
   end
        
    def delete_pages
      self.page_threads.each { |p| p.delete }
      Character.all.each do |c|
        Database.remove_from_set c.page_ignored, self
      end
    end
    
    def is_monitoring?(char)
      return false if !page_monitor
      page_monitor.has_key?(char.name)
    end
  end
end