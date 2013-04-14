module AresMUSH
  class SingleResultSelector
    def self.select(results, client)
      if (results.nil? || results.empty?)
        client.emit_failure(t("db.object_not_found"))
        return nil
      elsif (results.count > 1)
        client.emit_failure(t("db.object_ambiguous"))
        return nil
      else
        return results[0]
      end
    rescue ArgumentError, NoMethodError
      client.emit_failure(t("db.object_not_found"))        
      return nil
    end
  end
end