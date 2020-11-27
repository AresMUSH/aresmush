module AresMUSH
  module Manage
    class ThemeImporter
      def initialize(github_url)
        @tmp_dir = "/tmp/ares-extras"
        @github_url = github_url
        @repo_name = (github_url || "").split("/").last.downcase
        @source_dir = File.join(@tmp_dir, @repo_name)
      end      
              
      def import
        
        backup_current_theme
        if (@github_url == "default")
          copy_theme_files(File.join(AresMUSH.root_path, "install", "game.distr", "styles"))
          copy_image_files(File.join(AresMUSH.root_path, "install", "game.distr", "uploads", "theme_images"))
        else
          if (!@github_url.start_with?('https://github.com'))
            raise "ERROR! You must supply a GitHub url, like https://github.com/AresMUSH/ares-dark-theme."
          end
          
          if (@github_url.end_with?(".git"))
            raise "ERROR! Just use the repo url, without .git on the end. For example:  https://github.com/AresMUSH/ares-dark-theme."
          end
        
          if (@repo_name !~ /^ares-[\w\d]+-theme$/)
            raise "ERROR! Theme not compatible with installer. Repo name invalid."
          end

          if (Dir.exist?(@tmp_dir))
            FileUtils.rm_rf @tmp_dir
           end
          `git clone #{@github_url} #{@source_dir}`
  
  
          if (!Dir.exist?(@source_dir))
            raise "ERROR! Directory #{@source_dir} not found."
          end
          
          copy_theme_files(File.join(@source_dir, "styles"))
          copy_image_files(File.join(@source_dir, "images"))
        end
        
        Global.logger.info "Theme #{@github_url} added."
      end
      
      def backup_current_theme
        backup_dir = File.join(AresMUSH.root_path, "theme_archive")
        
        # Create the root level backups area.
        if (!Dir.exist?(backup_dir))
          Dir.mkdir backup_dir
        end
        
        # Create a specific backup folder for today.
        timestamp = Time.now.strftime("%Y%m%d%k%M%S")
        backup_dir = File.join(backup_dir, timestamp)
        
        if (!Dir.exist?(backup_dir))
          Dir.mkdir backup_dir
        end
        
        dir = File.join(AresMUSH.game_path, "styles") 
        Dir["#{dir}/*"].each do |file|
          FileUtils.cp(file, backup_dir)
        end
        
        dir = File.join(AresMUSH.game_path, "uploads", "theme_images")  
        Dir["#{dir}/*"].each do |file|
          FileUtils.cp(file, backup_dir)
        end
      end
      
      def copy_theme_files(styles_dir)
        dest_path = File.join(AresMUSH.game_path, "styles")  
        
        if (!Dir.exist?(styles_dir))
          Global.logger.debug "No styles to import from #{styles_dir}."
        else
          Dir["#{styles_dir}/*"].each do |file|
            FileUtils.cp(file, dest_path)
          end
        end
        
      end
      
      def copy_image_files(images_dir)
        dest_path = File.join(AresMUSH.game_path, "uploads", "theme_images")  
        
        if (!Dir.exist?(images_dir))
          Global.logger.debug "No images to import from #{images_dir}."
        else
          Dir["#{images_dir}/*"].each do |file|
            FileUtils.cp(file, dest_path)
          end
        end
      end
    end
  end
end