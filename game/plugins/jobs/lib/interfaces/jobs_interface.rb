module AresMUSH
  module Jobs
    def self.create_job(category, title, description, author)
      if (!Jobs.categories.include?(category))
        return { :job => nil, :error => t('jobs.invalid_category', :categories => Jobs.categories.join(" ")) }
      end
      
      job = Job.create(:author => author, 
        :title => title, 
        :description => description, 
        :category => category,
        :number => Game.master.next_job_number,
        :status => Global.config["jobs"]["default_status"])
        
      game = Game.master
      game.next_job_number = game.next_job_number + 1
      game.save
      
      message = t('jobs.announce_new_job', :number => job.number, :title => job.title, :name => author.name)
      Jobs.notify(job, message, author, false)

      return { :job => job, :error => nil }
    end
    
    def self.change_job_status(client, job, status, message = nil)
      if (message)
        Jobs.comment(job, client.char, message, false)
      end
      job.status = status
      job.save
      
      if (status == Global.config["jobs"]["closed_status"])
        notification = t('jobs.closed_job', :number => job.number, :title => job.title, :name => client.name)
      else
        notification = t('jobs.updated_job', :number => job.number, :title => job.title, :name => client.name)
      end
        
      Jobs.notify(job, notification, client.char)
    end
    
    def self.close_job(client, job, message = nil)
      Jobs.change_job_status(client, job, Global.config["jobs"]["closed_status"], message)
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