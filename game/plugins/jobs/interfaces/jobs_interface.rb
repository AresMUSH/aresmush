module AresMUSH
  module Jobs
    def self.create_job(category, title, description, author)
      if (!Jobs.categories.include?(category))
        Global.logger.debug "Invalid job category #{category}."
        return { :job => nil, :error => t('jobs.invalid_category', :categories => Jobs.categories.join(" ")) }
      end
      
      job = Job.create(:author => author, 
        :title => title, 
        :description => description, 
        :category => category,
        :number => Game.master.next_job_number,
        :status => Global.read_config("jobs", "default_status"))
        
      game = Game.master
      game.next_job_number = game.next_job_number + 1
      game.save
      
      message = t('jobs.announce_new_job', :number => job.number, :title => job.title, :name => author.name)
      Jobs.notify(job, message, author, false)

      return { :job => job, :error => nil }
    end
    
    def self.change_job_status(client, job, status, message = nil)
      if (status == Jobs.closed_status)
        status_message = t('jobs.closed_job', :name => client.name, :status => status)
      else
        status_message = t('jobs.changed_job_status', :name => client.name, :status => status)
      end
            
      message = message ? "#{message}%R%R#{status_message}" : status_message

      Jobs.comment(job, client.char, message, false)
      job.status = status
      job.save
    end
    
    def self.close_job(client, job, message = nil)
      Jobs.change_job_status(client, job, Jobs.closed_status, message)
    end
    
    def self.notify(job, message, author, notify_submitter = true)
      Global.client_monitor.logged_in_clients.each do |c|
        job.readers = [ author ]
        job.save
        
        if (Jobs.can_access_jobs?(c.char) || (notify_submitter && (c.char == job.author)))
          c.emit_ooc message
        end
      end
    end
  end
end