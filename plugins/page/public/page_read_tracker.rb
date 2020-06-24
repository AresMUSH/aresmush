module AresMUSH
  class ReadTracker

    attribute :read_page_threads, :type => DataType::Array, :default => []

    def is_page_thread_unread?(thread)
      threads = self.read_page_threads || []
      !threads.include?("#{thread.id}")
    end
    
    def mark_page_thread_read(thread)
      threads = self.read_page_threads || []
      threads << thread.id.to_s
      self.update(read_page_threads: threads.uniq)
    end

    def mark_page_thread_unread(thread)
      threads = self.read_page_threads || []
      threads.delete thread.id.to_s
      self.update(read_page_threads: threads.uniq)
    end
  end
end