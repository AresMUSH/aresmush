module AresMUSH  

  module Migrations
    class Migration1x2x0Update
      def require_restart
        false
      end
      
      def migrate
        Global.logger.debug "Add default admin menu."
        config = DatabaseMigrator.read_config_file("website.yml")
        navbar = config['website']['top_navbar']
        navbar << {
          "title" => "Admin",
          "roles" =>  [ "admin", "coder" ],
          "menu" =>  [ {
            "title" =>  "Jobs",
            "route" =>  "jobs"
          }, {
            "title" =>  "Setup",
            "route" =>  "setup"
          }, {
            "title" =>  "Manage",
            "route" =>  "manage"
          }, {
            "title" =>  "Logs",
            "route" =>  "logs"
          }, {
            "title" =>  "Files",
            "route" =>  "files"
          },{
            "title" =>  "Roles",
            "route" =>  "roles"
          },{
            "title" =>  "Server",
            "route" =>  "server-info"
          }]
        }
        navbar << {
          "title" =>  "Code",
          "roles" =>  [ "coder" ],
          "menu" =>  [ {
            "title" =>  "Tinker",
            "route" =>  "tinker"
          }, {
            "title" =>  "Custom Code",
            "route" =>  "custom-code"
          }]
        }
        navbar << {
          "title" =>  "Theme",
          "roles" =>  [ "admin" ],
          "menu" =>  [ {
            "title" =>  "Theme Colors",
            "route" =>  "setup-colors"
          }, {
            "title" =>  "Custom Styles",
            "route" =>  "textfile",
            "ids" => [ "style", "custom_style.scss" ]
          }, {
            "title" =>  "Files",
            "route" =>  "files"
          }, {
            "title" =>  "Home Page Text",
            "route" =>  "textfile",
            "ids" => [ "text", "website.txt" ]
          }]
        }
        config['website']['top_navbar'] = navbar
        DatabaseMigrator.write_config_file("website.yml", config)        
      end
    end
  end    
end