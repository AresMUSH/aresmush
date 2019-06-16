module AresMUSH
  module Website
    def self.add_to_recent_changes(type, id)
      changes = Game.master.recent_changes
      if (changes.count > 99)
        changes.shift
      end
      changes << { 'type' => type, 'id' => id }
      Game.master.update(recent_changes: changes)
    end
    
    def self.recent_changes(unique_only = false, limit = 50)
      all_changes = Game.master.recent_changes
      changes = []
      
      if (unique_only)
        found = []
        all_changes.each do |c|
          key = c['title']
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
      if (change['type'] == 'char')
        p = ProfileVersion[change['id']]
        {
          title: p.character.name,
          id: p.id,
          change_type: 'char',
          created_at: p.created_at,
          created: OOCTime.local_long_timestr(nil, p.created_at),
          name: p.character.name,
          author: p.author_name
        }
      else
        w = WikiPageVersion[change['id']]
        {
          title: w.wiki_page.heading,
          id: w.id,
          change_type: 'wiki',
          created_at: w.created_at,
          created: OOCTime.local_long_timestr(nil, w.created_at),
          name: w.wiki_page.name,
          author: w.author_name
        }
      end
    end
  end
end
