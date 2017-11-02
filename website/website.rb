$:.unshift File.dirname(__FILE__)

module AresMUSH
  def self.logs_path
    File.join(AresMUSH.game_path, "logs", "web")
  end
end

load "web_server.rb"
