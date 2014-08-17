module AresMUSH
  module Jobs
    def self.create_job(client, category, title, description, author)
      if (!Jobs.categories.include?(category))
        return { :job => nil, :error => t('jobs.invalid_category', :categories => Jobs.categories.join(" ")) }
      end
      
      job = Job.create(:author => author, 
        :title => title, 
        :description => description, 
        :category => category,
        :number => Game.master.next_job_number,
        :status => Jobs.status_vals[0])
        
        game = Game.master
        game.next_job_number = game.next_job_number + 1
        game.save
      return { :job => job, :error => nil }
    end
  end
end