module AresMUSH
  module Website
    def self.add_to_recent_changes(type, message, data, author_name)
      changes = Game.master.recent_changes || []
      change_data = { 'type' => type, 
        'data' => data, 
        'message' => message, 
        'author' => author_name, 
        'timestamp' => Time.now 
      }
      changes.unshift(change_data)
      if (changes.count > 99)
        changes.pop
      end
      Game.master.update(recent_changes: changes)
    end
    
    def self.recent_changes(viewer, unique_only = false, limit = 50)
      all_changes = Game.master.recent_changes || []
      changes = []
      
      if (unique_only)
        found = []
        all_changes.each do |c|
          key = "#{c['message']}#{c['type']}"
          if (!found.include?(key))
            found << key
            changes << c
          end
        end
      else
        changes = all_changes
      end
      
      changes[0..limit].map { |c| {
        type: c['type'],
        message: c['message'],
        data: c['data'],
        timestamp: OOCTime.local_long_timestr(viewer, c['timestamp']),
        author: c['author']
      } }
    end
  end
end
