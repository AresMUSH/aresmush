module AresMUSH
  module Jobs
    class JobsCatchupCmd
      include CommandHandler
      include CommandRequiresLogin
      include CommandWithoutArgs
    
      def want_command?(client, cmd)
        cmd.root_is?("job") && cmd.switch_is?("catchup")
      end
      
      def check_can_access
        return t('dispatcher.not_allowed') if !Jobs.can_access_jobs?(client.char)
        return nil
      end
      
      def handle
        unread = client.char.unread_jobs
        if (unread.empty?)
          client.emit_success t('jobs.no_new_jobs')
          return
        end
        
        unread.each do |job|
          Jobs.mark_read(job, client.char)
        end
        client.emit_success t('jobs.jobs_caught_up')
      end
    end
  end
end
