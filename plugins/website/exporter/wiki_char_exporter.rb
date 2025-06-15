require 'open-uri'

module AresMUSH
  module Website
   
    class WikiCharExporter
      def initialize(char)
        @char = char
        @export_path = File.join(AresMUSH.root_path, "wiki_export", @char.id)
      end
      
      def path_for_folder(folder)
        File.join(@export_path, folder)
      end
      
      def export
        begin
          unless File.directory?(@export_path)
            FileUtils.mkdir_p(@export_path)

            FileUtils.mkdir(self.path_for_folder("uploads"))
            FileUtils.mkdir(self.path_for_folder("profile"))
            FileUtils.mkdir(self.path_for_folder("scenes"))
          end
          
          export_uploads
          export_profile
          export_scenes
         
                  
          backup_filename = "export_#{@char.id}.zip"
          backup_path = File.join(AresMUSH.game_path, backup_filename)
          FileUtils.rm backup_path, :force=>true
          Zip::File.open(backup_path, 'w') do |zipfile|
            Dir["#{@export_path}/**/**"].each do |file|
              zipfile.add(file.sub(@export_path+'/',''),file)
            end
          end
          
          FileUtils.rm_r @export_path, :force=>true
          
          return { file: backup_filename, error: nil }
        rescue Exception => ex
          error = "#{ex} #{ex.backtrace[0,10]}"
          Global.logger.debug "Error doing web export: #{error}"
          return { error: error }
        end
      end   
      
      def export_uploads
        Global.logger.debug "Exporting uploads for #{@char.name}."

        upload_path = File.join(AresMUSH.game_path, 'uploads', @char.name)
        
        if (File.exist?(upload_path))
          FileUtils.cp_r upload_path, self.path_for_folder("uploads")
        end
      end
      
      def scene_filename(scene)
        filename = FilenameSanitizer.sanitize(scene.title || "Scene #{scene.id}")
        clean_date = "#{scene.icdate}".gsub("/", "-")
        "#{clean_date} #{filename}.txt"
      end
      
      def export_scenes
        Global.logger.debug "Exporting scenes for #{@char.name}."
        @char.scenes_starring.each do |s|
          filename = self.scene_filename(s)
          File.open(File.join(self.path_for_folder("scenes"), filename), "w") do |file|
            file.puts s.title
            file.puts s.summary
            file.puts "Date: #{s.icdate}"
            file.puts "Participants: #{s.participant_names.join(" ")}"
            file.puts "Location: #{s.location}"
            file.puts "--------------------"
            file.puts s.scene_log.log
          end
        end
        
        @char.unshared_scenes.each do |s|
          filename = self.scene_filename(s)
          File.open(File.join(self.path_for_folder("scenes"), filename), "w") do |file|
            file.puts s.title
            file.puts s.summary
            file.puts "Date: #{s.icdate}"
            file.puts "Participants: #{s.participant_names.join(" ")}"
            file.puts "Location: #{s.location}"
            file.puts "--------------------"
            file.puts Scenes.build_log_text(s)
          end
        end
      end
      
      def export_profile
        Global.logger.debug "Exporting profile for #{@char.name}."
        File.open(File.join(self.path_for_folder("profile"), "profile.txt"), "w") do |file|
          profile = Profile.export_profile(@char)
          file.write AnsiFormatter.strip_ansi(MushFormatter.format(profile))
        end
        
        File.open(File.join(self.path_for_folder("profile"), "descs.txt"), "w") do |file|
          descs = Describe.export_descs(@char)
          file.write AnsiFormatter.strip_ansi(MushFormatter.format(descs))
        end
        
        File.open(File.join(self.path_for_folder("profile"), "bg.txt"), "w") do |file|
          descs = Chargen.export_bg(@char)
          file.write AnsiFormatter.strip_ansi(MushFormatter.format(descs))
        end
        
        if FS3Skills.is_enabled?
          File.open(File.join(self.path_for_folder("profile"), "sheet.txt"), "w") do |file|
            sheet = FS3Skills.export_sheet(@char)
            file.write AnsiFormatter.strip_ansi(MushFormatter.format(sheet))
          end
        end
        
        if FS3Combat.is_enabled?
          File.open(File.join(self.path_for_folder("profile"), "damage.txt"), "w") do |file|
            sheet = FS3Combat.export_damage(@char)
            file.write AnsiFormatter.strip_ansi(MushFormatter.format(sheet))
          end
        end
        
        custom = Website.custom_wiki_char_export(@char)
        if (!custom.blank?)
          File.open(File.join(self.path_for_folder("profile"), "other.txt"), "w") do |file|
            file.write AnsiFormatter.strip_ansi(MushFormatter.format(custom))
          end
        end
        
      end   
    end
  end
end
