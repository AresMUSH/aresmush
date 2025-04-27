require 'open-uri'

module AresMUSH
  module Website
   
    class WikiCharExporter
      def initialize(char)
        @char = char
        @export_path = File.join(AresMUSH.root_path, "wiki_export", @char.id)
      end
      
      def export
        begin
          unless File.directory?(@export_path)
            FileUtils.mkdir_p(@export_path)
          end

          export_uploads
          export_profile
          export_scenes
         
                  
          backup_path = File.join(AresMUSH.game_path, "export_#{@char.id}.zip")
          FileUtils.rm backup_path, :force=>true
          Zip::File.open(backup_path, 'w') do |zipfile|
            Dir["#{@export_path}/**/**"].each do |file|
              zipfile.add(file.sub(@export_path+'/',''),file)
            end
          end
          
          FileUtils.rm_r @export_path, :force=>true
          
          return { path: backup_path, error: nil }
        rescue Exception => ex
          error = "#{ex} #{ex.backtrace[0,10]}"
          Global.logger.debug "Error doing web export: #{error}"
          return { error: error }
        end
      end   
      
      def export_uploads
        Global.logger.debug "Exporting uploads for #{@char.name}."

        FileUtils.cp_r File.join(AresMUSH.game_path, 'uploads', @char.name), File.join(@export_path, "uploads")
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
          File.open(File.join(@export_path, filename), "w") do |file|
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
          File.open(File.join(@export_path, filename), "w") do |file|
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
        File.open(File.join(@export_path, "profile.txt"), "w") do |file|
          profile = Profile.render_profile(@char)
          file.write AnsiFormatter.strip_ansi(MushFormatter.format(profile))
        end
        
        if FS3Skills.is_enabled?
          File.open(File.join(@export_path, "sheet.txt"), "w") do |file|
            sheet = FS3Skills.render_sheet(@char)
            file.write AnsiFormatter.strip_ansi(MushFormatter.format(sheet))
          end
        end
        
      end   
    end
  end
end
