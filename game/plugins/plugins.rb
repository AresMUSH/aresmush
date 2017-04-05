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
        "events",  # You can make this events_local if you don't like teamup
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
        "places",
        "pose", 
        "profile", 
        "ranks", 
        "roles", 
        "rooms", 
        "roster", 
        "scenes",
        "status", 
        "tinker", 
        "utils", 
        "weather", 
        "website",
        "who"   
      ]
    end
  end
end
