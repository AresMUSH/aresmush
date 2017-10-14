module AresMUSH
  # Client may be nil for automated activities
  def self.with_error_handling(client, desc, &block)
    begin
      begin
        yield block
        return true
        # Allow system exit to bubble up so it shuts the system down.
      rescue SystemExit
        raise SystemExit
      rescue Exception => e
        id = !client ? nil : client.id
        Global.logger.error("Error in #{desc}: client=#{id} error=#{e} backtrace=#{e.backtrace[0,10]}")
        if (client)
          client.emit_failure t('dispatcher.unexpected_error', :desc => desc, :error_info => e)
        end
        return false
      end
    rescue SystemExit
      raise SystemExit
    rescue Exception => e2
      Global.logger.error("Untrapped error in error handling: error=#{e2} backtrace=#{e2.backtrace[0,10]}")
      return false
    end
  end
end
