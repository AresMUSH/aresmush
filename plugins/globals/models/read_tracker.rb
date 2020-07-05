module AresMUSH
  class Character

    before_delete :cleanup_tracker

    def get_or_create_read_tracker
      return self.read_tracker if self.read_tracker
      tracker = ReadTracker.create(character: self)
      self.update(read_tracker: tracker)
      return tracker
    end  

    def cleanup_tracker
      if self.read_tracker
        self.read_tracker.delete
      end
    end

  end
end