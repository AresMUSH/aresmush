module AresMUSH  

  module Migrations
    class MigrationBeta53Update
      def require_restart
        true
      end
      
      def migrate
        
        Global.logger.debug "Adding recent changes."
        recent = []
        find_recent_changes(false, 100).each do |r|
          entry = { 'type' => r[:change_type], 'id' => r[:id], 'name' => r[:name] }
          recent << entry
        end
        Game.master.update(recent_changes: recent)
      
        Global.logger.debug "Adding recent scenes"
        recent = Scene.shared_scenes.to_a.sort_by { |s| s.date_shared || s.created_at }.reverse[0..29]
        Game.master.update(recent_scenes: recent.map { |r| r.id })
        Scene.all.each do |s|
          s.update(completed: s.completed) # Trigger indexing
          s.update(shared: s.shared)
        end
      
        Global.logger.debug "Adding recent forum posts"
        recent = BbsPost.all.to_a.sort_by { |p| p.last_updated }.reverse[0..29]
        Game.master.update(recent_forum_posts: recent.map { |r| r.id })
      
      
        Global.logger.debug "Creating job category objects."
        categories = Global.read_config("jobs", "categories")
        categories.each do |name, data|
          cat_model = JobCategory.create(name: name.upcase, color: data['color'])
          Job.find(category: name.upcase).each do |j|
            j.update(job_category: cat_model)
            j.update(status: j.status) # Triggers the indexing
          end
          roles = (data['roles'] || []).map { |r| Role.named(r) }.select { |r| r }
          cat_model.roles.replace(roles)
        end
        
        Global.logger.debug "Add job config."
        config = DatabaseMigrator.read_config_file("jobs.yml")
        config['jobs']['shortcuts']['job/unread'] = "job/filter unread"
        config['jobs']['archive_job_days'] = 10
        config['jobs']['archive_cron'] = { 'day_of_week' => ['Sun'], 'hour' => [04], 'minute' => [18] }
        config['jobs']['status']['ARCHIVED'] = { 'color' => "%xx%xh" }
        config['jobs']['closed_statuses'] = [ 'DONE', 'ARCHIVED' ]
        config['jobs']['active_statuses'] = [ 'NEW', 'OPEN' ]
        config['jobs']['open_status'] = 'OPEN'      
        config['jobs']['archived_status'] = 'ARCHIVED'
        
        DatabaseMigrator.write_config_file("jobs.yml", config)  
      
        Global.logger.debug "Archiving old jobs."
        Job.find(status: 'DONE').each do |j|
          j.update(date_closed: Time.now)
          j.update(status: 'ARCHIVED')
        end
        
        Role.named("Coder").add_permission("tinker")
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
end