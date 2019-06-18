module AresMUSH  
  class CookieAward < Ohm::Model
    include ObjectModel
    
    reference :giver, "AresMUSH::Character"
    reference :recipient, "AresMUSH::Character"
  end
  
  class Character
    attribute :total_cookies
  end
  
  module Migrations
    class MigrationBeta52Update
      def require_restart
        true
      end
      
      def migrate
        
        Global.logger.debug "Deleting cookie awards and initializing luck."
        CookieAward.all.each { |c| c.delete }
        Character.all.each do |c|
          c.update(fs3_cookie_archive: c.total_cookies)
          c.update(total_cookies: nil)
          c.update(fs3_scene_luck: {})
        end
        
        config = DatabaseMigrator.read_config_file("fs3skills_misc.yml")
        config['fs3skills']['luck_for_scene'] = {
          0 => 0.1,
          10 => 0.075,
          25 => 0.05,
          50 => 0.025
        }
        DatabaseMigrator.write_config_file("fs3skills_misc.yml", config)
        
        Global.logger.debug "Removing actors from web menu."
        config = DatabaseMigrator.read_config_file("website.yml")
        menu = config['website']['top_navbar']
        menu.each do |submenu|
          submenu['menu'].each do |item|
            if item['route'] == 'actors'
              submenu['menu'].delete item
            end
          end
        end
        DatabaseMigrator.write_config_file("website.yml", config)
      end
      
      Global.logger.debug "Add inventory shortcuts."
      config = DatabaseMigrator.read_config_file("utils.yml")
      ['i', 'in', 'inv'].each do |sc|
        config['utils']['shortcuts'][sc] = "echo %% There's no inventory system here."
      end
      DatabaseMigrator.write_config_file("utils.yml", config)  
            
      Global.logger.debug "Update actor shortcut and property names."
      config = DatabaseMigrator.read_config_file("demographics.yml")
      config['demographics']['shortcuts']['actors'] = 'census played by'
      config['demographics']['shortcuts']['actor'] = 'demographic/set played by='
      ['editable_properties', 'required_properties', 'demographics', 'private_properties'].each do |section|
        new_section = []
        config['demographics'][section].each do |item|
          if (item == 'actor')
            new_section << 'played by'
          elsif (item == 'fullname')
            new_section << 'full name'
          else
            new_section << item
          end
        end
        config['demographics'][section] = new_section
      end
      DatabaseMigrator.write_config_file("demographics.yml", config)  
      
      
      Global.logger.debug "Renaming actor to played by."
      Character.all.each do |c|
        c.update_demographic('played by', c.demographic('actor'))
        c.update_demographic('full name', c.demographic('fullname'))
        c.update_demographic('actor', nil)
        c.update_demographic('fullname', nil)
      end
      
      Global.logger.debug "Adding recent changes."
      recent = []
      find_recent_changes(false, 100).each do |r|
        entry = { 'type' => r[:change_type], 'id' => r[:id], 'title' => r[:title] }
        recent << entry
      end
      Game.master.update(recent_changes: recent)
      
      Global.logger.debug "Adding recent scenes"
      recent = Scene.shared_scenes.to_a.sort_by { |s| s.date_shared || s.created_at }.reverse[0..29] || []
      Scene.all.each do |s|
        s.update(completed: s.completed) # Trigger indexing
        s.update(shared: s.shared)
      end
      Game.master.update(recent_scenes: recent.map { |r| r.id })
      
      
      Global.logger.debug "Creating job category objects."
      categories = Global.read_config("jobs", "categories").keys.map { |c| c.upcase }
      categories.each do |cat|
        cat_model = JobCategory.create(name: cat.titlecase, alias: cat)
        Job.find(category: cat).each do |j|
          j.update(job_category: cat_model)
          j.update(status: j.status) # Triggers the indexing
        end
      end
        
      Global.logger.debug "Add job config."
      config = DatabaseMigrator.read_config_file("jobs.yml")
      config['jobs']['shortcuts']['job/unread'] = "job/filter unread"
      DatabaseMigrator.write_config_file("jobs.yml", config)  
      
      Global.logger.debug "Removing cookies plugin dir."
      FileUtils.remove_dir(File.join(AresMUSH.root_path, "plugins/cookies"))
      
    end
    
    def find_recent_changes(unique_only = false, limit = 50)
    
      recent_profiles = ProfileVersion.all.to_a
      
      if (unique_only)
        recent_profiles = recent_profiles.uniq { |p| p.character }
      end
      
      recent_profiles = recent_profiles.sort_by { |p| p.created_at }.reverse[0..50]

      recent_wiki = WikiPageVersion.all.to_a

      if (unique_only)
        recent_wiki = recent_wiki.uniq { |w| w.wiki_page }
      end
      
      recent_wiki = recent_wiki.sort_by { |p| p.created_at }.reverse[0..50]

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
