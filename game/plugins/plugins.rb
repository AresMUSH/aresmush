require 'openssl'
require 'timezone'
require 'dentaku'

module AresMUSH
  module Plugins
    def self.all_plugins
      [
        "actors", 
        "arescentral", 
        "bbs", 
        "channels", 
        "chargen", 
        "cookies", 
        "demographics", 
        "describe", 
        "events",
        "friends", 
        "fs3combat", 
        "fs3skills", 
        "groups", 
        "handles", 
        "help", 
        "ictime", 
        "idle", 
        "jobs", 
        "login", 
        "mail", 
        "manage", 
        "maps", 
        "notices", 
        "ooctime", 
        "page", 
        "pose", 
        "profile", 
        "ranks", 
        "roles", 
        "rooms", 
        "roster", 
        "status", 
        "tinker", 
        "utils", 
        "weather", 
        "who"   
      ]
    end
  end
end
