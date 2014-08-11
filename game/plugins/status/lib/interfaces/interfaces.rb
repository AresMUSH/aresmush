module AresMUSH
  module Status
    def self.status_color(status)
      status = status.upcase
      config = Global.config["status"]["colors"]
      return config[status] if config.has_key?(status)
      return ""
    end
  end
end