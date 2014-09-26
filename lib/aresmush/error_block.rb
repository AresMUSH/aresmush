module AresMUSH
  def self.with_error_handling(client, desc, &block)
    begin
      yield block
      return true
      # Allow system exit to bubble up so it shuts the system down.
    rescue SystemExit
      raise SystemExit
    rescue Exception => e
      begin
        id = client.nil? ? nil : client.id
        Global.logger.error("Error in #{desc}: client=#{id} error=#{e} backtrace=#{e.backtrace[0,10]}")
          if (!client.nil?)
            client.emit_failure t('dispatcher.unexpected_error', :desc => desc, :error_info => e)
          end
      rescue Exception => e2
        Global.logger.error("Error inside of error handling: error=#{e2} backtrace=#{e2.backtrace[0,10]}")
      end
      return false
    end
  end
end