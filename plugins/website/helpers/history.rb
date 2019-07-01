module AresMUSH
  module Website
    def self.add_to_recent_changes(type, id, name)
      changes = Game.master.recent_changes || []
      changes.unshift({ 'type' => type, 'id' => id, 'name' => name })
      if (changes.count > 99)
        changes.pop
      end
      Game.master.update(recent_changes: changes)
    end
    
    def self.recent_changes(unique_only = false, limit = 50)
      all_changes = Game.master.recent_changes || []
      changes = []
      
      if (unique_only)
        found = []
        all_changes.each do |c|
          key = "#{c['name']}#{c['type']}"
          if (!found.include?(key))
            found << key
            changes << c
          end
        end
      else
        changes = all_changes
      end
      
      changes[0..limit].map { |c| Website.get_recent_change_details(c) }
    end
    
    def self.get_recent_change_details(change)
     case change['type']
     when 'char'
        p = ProfileVersion[change['id']]
        return { change_type: 'deleted', title: "Character #{change['name']} deleted."} if !p
        {
          title: p.character.name,
          id: p.id,
          change_type: 'char',
          created_at: p.created_at,
          created: OOCTime.local_long_timestr(nil, p.created_at),
          name: p.character.name,
          author: p.author_name
        }
      when 'wiki'
        w = WikiPageVersion[change['id']]
        return { change_type: 'deleted', title: "Wiki Page #{change['name']} deleted."} if !w
        {
          title: w.wiki_page.heading,
          id: w.id,
          change_type: 'wiki',
          created: OOCTime.local_long_timestr(nil, w.created_at),
          name: w.wiki_page.name,
          author: w.author_name
        }
      when 'event'
        event = Event[change['id']]
        return { change_type: 'deleted', title: "Event #{change['name']} deleted."} if !event
        {
          title: event.title,
          id: event.id,
          change_type: 'event',
          created: OOCTime.local_long_timestr(nil, event.updated_at),
          name: event.title,
          author: "System"
        }
      end
    end
  end
end
