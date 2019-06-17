module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end
      
      def handle
      Global.logger.debug "Archiving old jobs."
      archive_job_days = Global.read_config('jobs', 'archive_job_days')
        old_jobs = Job.open_jobs.select { |j| !j.is_open? }.each do |j|
          days_since_close = Time.now - j.date_closed 
          if (days_since_close > (86400 * archive_job_days)) 
            j.update(is_open: false)
          end
        end
      
        client.emit_success "Done!"
      end

    end
  end
end
