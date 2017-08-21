require 'openssl'
require 'timezone'
require 'dentaku'

module AresMUSH
  module Plugins
    def self.all_plugins
      [
        
        "arescentral", 
        "bbs", 
        "channels", 
        "chargen", 
        "cookies", 
        "custom",
        "demographics", 
        "describe", 
        "events",
        "friends", 
        "fs3combat", 
        "fs3skills", 
        "help", 
        "ictime", 
        "idle", 
        "jobs", 
        "login", 
        "mail", 
        "manage", 
        "maps", 
        "ooctime", 
        "page", 
        "places",
        "pose", 
        "profile", 
        "ranks", 
        "roles", 
        "rooms", 
        "scenes",
        "status", 
        "tinker", 
        "utils", 
        "weather", 
        "website",
        "who",
        "wiki",
        "wikidot"
      ]
    end
  end
end
