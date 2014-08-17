module AresMUSH
  module Jobs
    def self.can_access_jobs?(actor)
      return actor.has_any_role?(Global.config["jobs"]["roles"]["can_access_jobs"])
    end
    
    def self.categories
      Global.config["jobs"]["categories"]
    end
    
    def self.status_vals
      [ 'NEW', 'OPEN', 'HOLD', 'DONE' ]
    end
    
    def self.status_color(status)
      return "" if status.nil?
      case status.upcase
      when "NEW"
        "%xg"
      when "OPEN"
        "%xb"
      when "HOLD"
        "%xr"
      when "DONE"
        "%xy"
      end
    end
    
    def self.with_a_request(client, number, &block)
      job = client.char.submitted_requests.where(number: number.to_i).first
      if (job.nil?)
        client.emit_failure t('jobs.invalid_request_number')
        return
      end
      
      yield job
    end
  end
end