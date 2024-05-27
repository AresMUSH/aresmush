require 'open-uri'

module AresMUSH
  module Website
   
    module WikiExporter
      def self.export
        begin
          unless File.directory?(export_path)
            FileUtils.mkdir_p(export_path)
          end

          game_export_path = File.join(export_path, "game")
          unless File.directory?(game_export_path)
            FileUtils.mkdir_p(game_export_path)
          end
  
          Global.logger.debug "Exporting uploads."
          FileUtils.cp_r(File.join(AresMUSH.game_path, "uploads"), game_export_path)

          Global.logger.debug "Exporting styles."
          FileUtils.cp_r(File.join(AresMUSH.game_path, "styles"), game_export_path)

          Global.logger.debug "Exporting scripts."
          FileUtils.cp_r(File.join(AresMUSH.game_path, "scripts"), game_export_path)

          export_locations
          export_wiki
          export_scenes
          export_chars
          export_index
                  
          backup_path = File.join(AresMUSH.game_path, "wiki_export.zip")
          FileUtils.rm backup_path, :force=>true
          Zip::File.open(backup_path, 'w') do |zipfile|
            Dir["#{export_path}/**/**"].each do |file|
              zipfile.add(file.sub(export_path+'/',''),file)
            end
          end
          
          return nil
        rescue Exception => ex
          error = "#{ex} #{ex.backtrace[0,10]}"
          Global.logger.debug "Error doing web export: #{error}"
          return error
        end
      end   
      
      def self.export_path
        File.join(AresMUSH.root_path, "wiki_export")
      end
      
      def self.export_index
        Global.logger.debug "Exporting index."
        renderer = WikiExportIndexTemplate.new
        text = renderer.render
        
        File.open(File.join(export_path, "index.html"), 'w') do |f|

          f.puts format_wiki_template(text, "Home")
        end
      end
      
      def self.scene_page_name(scene)
        filename = FilenameSanitizer.sanitize(scene.title)
        clean_date = "#{scene.icdate}".gsub("/", "-")
        "#{clean_date}-#{filename}.html"
      end
      
      def self.export_scenes
        Global.logger.debug "Exporting scenes."

        index = {}        
        scenes = Scene.shared_scenes.to_a.sort_by { |s| s.icdate }.reverse
        
        scenes.each do |s|
          #Global.logger.debug "Parsing scene #{s.id} #{s.title}"
        
          page_name = self.scene_page_name(s)
          
          type = s.scene_type
          if (index[type])
            index[type] << s
          else
            index[type] = [s]
          end
          
          renderer = WikiExportSceneTemplate.new(s)
          text = renderer.render 
          
          File.open(File.join(export_path, page_name), 'w') do |f|
            f.puts format_wiki_template(text, s.date_title)
          end
        end

        
        File.open(File.join(export_path, "scenes.html"), 'w') do |f|
          renderer = WikiExportSceneIndexTemplate.new(index)
          text = renderer.render
          f.puts format_wiki_template(text, "Scenes")
        end
        
      end 

      def self.export_locations
        Global.logger.debug "Exporting locations."

        index = {}
        Room.all.to_a.sort_by { |r| r.name_and_area }.each do |r|
          page_name = "#{FilenameSanitizer.sanitize(r.name_and_area)}.html"
          index[page_name] = r.name_and_area
            
          renderer = WikiExportLocationTemplate.new(r)
          text = renderer.render
                  
          File.open(File.join(export_path, page_name), 'w') do |f|
            f.puts format_wiki_template(text, r.name_and_area)
          end
        end
        
        File.open(File.join(export_path, "locations.html"), 'w') do |f|
          text = "<h1>Locations</h1>"
          text << "<ul>"
          index.each do |page, title|
            text << "<li><a href=\"#{page}\">#{title}</a>"
          end
          text << "</ul>"
          f.puts format_wiki_template(text, "Locations")
        end
      end
      
      def self.export_wiki
        Global.logger.debug "Exporting wiki."

        index = {}
        WikiPage.all.to_a.sort_by { |p| p.heading }.each do |p|
          page_name = "#{FilenameSanitizer.sanitize(p.name)}.html"
          index[page_name] = p.heading
          
          #Global.logger.debug "Parsing wiki #{p.heading}"

          renderer = WikiExportWikiPageTemplate.new(p)
          text = renderer.render
          
          File.open(File.join(export_path, page_name), 'w') do |f|
            f.puts format_wiki_template(text, p.heading)
          end
        end
        
        File.open(File.join(export_path, "wiki.html"), 'w') do |f|
          text = "<h1>Wiki</h1>"
          text << "<ul>"
          text << "<li><b><a href=\"home.html\">Wiki Home</a></b></li>"
          index.each do |page, title|
            text << "<li><a href=\"#{page}\">#{title}</a>"
          end
          text << "</ul>"
          f.puts format_wiki_template(text, "Wiki")
        end
      end
      
      def self.export_chars
        Global.logger.debug "Exporting characters."
        
        approved_chars = Chargen.approved_chars.select { |c| !c.is_admin? && c.is_approved? }
        gone_chars = Character.all.select { |c| c.idle_state == 'Gone' }
        dead_chars = Character.all.select { |c| c.idle_state == 'Dead' }

        all_chars = approved_chars.concat(gone_chars).concat(dead_chars)
                
        all_chars.sort_by { |c| c.name }.each do |c|
          #Global.logger.debug "Parsing character #{c.name}"
        
          page_name = "#{c.name}.html"
        
          File.open(File.join(export_path, page_name), 'w') do |f|
            
            scenes = c.scenes_starring.sort_by { |s| s.icdate }.reverse
            index = {}
            scenes.each do |s| 
              page_name = self.scene_page_name(s)
          
              type = s.scene_type
              if (index[type])
                index[type] << s
              else
                index[type] = [s]
              end
            end
            
            renderer = WikiExportSceneIndexTemplate.new(index)
            scene_text = renderer.render
            
            renderer = WikiExportCharTemplate.new(c, scene_text)
            text = renderer.render
            
            f.puts format_wiki_template(text, c.name)
          end
        end
        
        File.open(File.join(export_path, "characters.html"), 'w') do |f|
          renderer = WikiExportCharIndexTemplate.new(all_chars)
          text = renderer.render
          f.puts format_wiki_template text, "Characters"
        end
        
      end
      
      def self.format_wiki_template(text, title)
        text = (text || "").gsub("src=\"/", "src=\"")
        text = text.gsub(/href\=\"\/wiki\/([^\"]+)\/?/) { "href=\"#{FilenameSanitizer.sanitize($1)}.html" }
        text = AnsiFormatter.strip_ansi(text)

        renderer = WikiExportDefaultTemplate.new(text, title)
        renderer.render
      end      
    end
  end
end
