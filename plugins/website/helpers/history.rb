module AresMUSH
  module Website
    def self.get_recent_changes(unique_only = false, limit = nil)
      sixty_days_in_seconds = 86400 * 60
      
      recent_profiles = ProfileVersion.all.select { |p| Time.now - p.created_at < sixty_days_in_seconds }
      recent_wiki = WikiPageVersion.all.select { |w| Time.now - w.created_at < sixty_days_in_seconds}
           
      
      if (unique_only)
         recent_profiles =  recent_profiles.sort_by { |p| p.created_at }
           .reverse
           .uniq { |p| p.character }
          recent_wiki = recent_wiki.sort_by { |w| w.created_at }
           .reverse
           .uniq { |w| w.wiki_page }
      end
                
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
      
      if (limit)
        recent_changes[0..limit]
      else
        recent_changes
      end
      
    end 
    
    
    def self.build_sitemap
      list = []
      list << Game.web_portal_url
      Scene.shared_scenes.each { |s| list << "#{Game.web_portal_url}/scene/#{s.id}" }
      Character.all.each { |c| list << "#{Game.web_portal_url}/char/#{c.name}" }
      WikiPage.all.each { |w| list << "#{Game.web_portal_url}/wiki/#{w.name}" }
      Plot.all.each { |p| list << "#{Game.web_portal_url}/plot/#{p.id}" }
      Area.all.each { |r| list << "#{Game.web_portal_url}/location/#{r.id}" }
      list << "#{Game.web_portal_url}/help"
      list << "#{Game.web_portal_url}/actors"
      list << "#{Game.web_portal_url}/roster"
      list << "#{Game.web_portal_url}/census"
      list << "#{Game.web_portal_url}/fs3combat/gear"
      list << "#{Game.web_portal_url}/fs3skills/abilities"

      topics = Help.topic_keys.map { |k, v| v }.uniq
      topics.each { |h| list << "#{Game.web_portal_url}/help/#{h}" }
      
      BbsPost.all.select{ |b| b.is_public? }.each { |b| list << "#{Game.web_portal_url}/forum/#{b.bbs_board.id}/#{b.id}" }
      
      list
    end
    
    def self.search(term)
      return [] if term.blank?
      term = term.downcase.gsub(/[^0-9A-Za-z ]/, '')
      results = []
      [ Area, Character, WikiPage, Scene ].each do |klass|
        category = klass.name.downcase
        klass.all.select { |m| m.searchable? }.each do |model|
          
          if (model.search_blob  =~ /\b#{term}\b/i)
            results << { category: category, name: model.search_name, id: model.id, summary: model.search_summary }
          end
        end
      end
      results
    end
    
    def self.rebuild_search_index
      new_index = {}
      [ Area, Character, WikiPage, Scene ].each do |klass|
        category = klass.name.downcase
        klass.all.each do |model|
          search_terms = model.search_terms.select { |t| t && t.length > 3 }.map { |t| t.downcase }.uniq
        
          search_terms.each do |t|
            entry = { category: category, name: model.search_name, id: model.id }
            if !new_index[t]
              new_index[t] = [ entry ]
            else
              new_index[t] << entry
            end
          end
        end
      end
      SearchIndex.master.update(index: new_index)
    end
  end
end
