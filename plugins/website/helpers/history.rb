module AresMUSH
  module Website
    def self.get_recent_changes(unique_only = false, limit = 50)
      
      recent_profiles = ProfileVersion.all
         .to_a
         .sort_by { |p| p.created_at }
         .reverse[0..50]
         .uniq { |p| p.character }

      recent_wiki = WikiPageVersion.all
         .to_a
         .sort_by { |p| p.created_at }
         .reverse[0..50]
         .uniq { |w| w.wiki_page }

      recent_changes = []
      recent_profiles.each do |p|
        recent_changes << {
          title: p.character.name,
          id: p.id,
          change_type: 'char',
          created_at: p.created_at,
          created: OOCTime.local_long_timestr(nil, p.created_at),
          name: p.character.name,
          author: p.author_name
        }
      end
      recent_wiki.each do |w|
        recent_changes << {
          title: w.wiki_page.heading,
          id: w.id,
          change_type: 'wiki',
          created_at: w.created_at,
          created: OOCTime.local_long_timestr(nil, w.created_at),
          name: w.wiki_page.name,
          author: w.author_name
        }
      end
        
      recent_changes = recent_changes.sort_by { |r| r[:created_at] }.reverse
      recent_changes[0..limit]
    end 
    
  end
end
