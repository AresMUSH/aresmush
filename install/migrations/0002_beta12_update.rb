module AresMUSH
  module Migrations
    class MigrationBeta12Update
      def migrate
        puts "Adding wiki configuration."
        
        website_file = File.join(AresMUSH.root_path, "game", "config", "website.yml")
        custom_web = YAML::load( File.read( website_file ))
        custom_web["website"]["wiki_aliases"] = { 'main' => 'home' }
        custom_web["website"]["restricted_pages"] = [ 'home' ]
        
        File.open(website_file, 'w') do |f|
          f.write(custom_web.to_yaml)
        end
      end
    end
  end
end