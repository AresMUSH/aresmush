require 'open-uri'

module AresMUSH
  module Website
   
    module WikiExporter
      def self.export
        begin
          unless File.directory?(export_path)
            FileUtils.mkdir_p(export_path)
          end
  
          export_locations
          export_wiki
          export_scenes
          export_chars
          export_index
        
          path = File.join(export_path, "game")
          unless File.directory?(path)
            FileUtils.mkdir_p(path)
          end
  
          path = File.join(export_path, "game")
          FileUtils.cp_r(File.join(AresMUSH.game_path, "uploads"), path)
          FileUtils.cp_r(File.join(AresMUSH.game_path, "styles"), path)
          FileUtils.cp_r(File.join(AresMUSH.game_path, "scripts"), path)
          
          # Copy music player script
          src = File.join(Global.read_config("website", "website_code_path"), "public", "scripts", "music_player.js")
          dest = File.join(AresMUSH.game_path, "scripts", "music_player.js")
          FileUtils.cp src, dest
          
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
      
      def self.template_path
        File.join(Global.read_config("website", "website_code_path"), "app", "templates")
      end
      
      def self.export_index
        Global.logger.debug "Exporting index."
        
        mush_name = Global.read_config("game", "name")
        File.open(File.join(export_path, "index.html"), 'w') do |f|
          text = "<div class=\"alert alert-info\">This is an archive of the #{mush_name} web portal.  Some links may not function and wiki pages may not format perfectly, but you can access most of the information.</div>"
          text << '<div class="jumbotron">'
          text << "<img src=\"game/uploads/theme_images/jumbotron.png\" />"
          welcome = Website.welcome_text
          text << "<p>#{welcome}</p>"
          text << "</div>"
          f.puts format_wiki_template(text, "Home")
        end
      end
      
      def self.build_scene_index(scenes)
        index = {}
        scenes.each do |s|
          #Global.logger.debug "Parsing scene #{s.id} #{s.title}"
        
          filename = FilenameSanitizer.sanitize(s.title)
          clean_date = "#{s.icdate}".gsub("/", "-")
          page_name = "#{clean_date}-#{filename}.html"
          index[page_name] = {}
          index[page_name][:title] = s.date_title
          index[page_name][:summary] = s.summary
          index[page_name][:participants] = s.participant_names.join(", ")
          index[page_name][:type] = s.scene_type
          index[page_name][:page] = page_name
        
          File.open(File.join(export_path, page_name), 'w') do |f|
          
            request = WebRequest.new( { args: { id: s.id } } )
            response = Scenes::GetSceneRequestHandler.new.handle(request)            
            
            f.puts render_template(File.join(AresMUSH.plugin_path, 'website', 'templates', 'wiki_scene.hbs'), { model: response }, s.date_title)
          end
        end
        index
      end
      
      def self.export_scenes
        Global.logger.debug "Exporting scenes."

        index = build_scene_index(Scene.shared_scenes.to_a.sort_by { |s| s.icdate }.reverse)
        
        File.open(File.join(export_path, "scenes.html"), 'w') do |f|
          
          template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'wiki_scene_list.hbs'))
          
          groups = index.group_by { |k, v| v[:type] }
          scenes_by_type = groups.map { |k, v| { name: k, scenes: v.map { |page, data| data } }}
          
          text = template.render(types: groups.keys, scenes_by_type: scenes_by_type )
          
          f.puts format_wiki_template(text, "Scenes")
        end
        
      end 

      def self.export_locations
        index = {}
        Global.logger.debug "Exporting locations."
        Room.all.to_a.sort_by { |r| r.name_and_area }.each do |r|
          page_name = "#{FilenameSanitizer.sanitize(r.name_and_area)}.html"
          index[page_name] = r.name_and_area
                    
          File.open(File.join(export_path, page_name), 'w') do |f|
            request = WebRequest.new( { args: { id: r.id } } )
            response = Rooms::LocationRequestHandler.new.handle(request)
            
            template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'wiki_location.hbs'))
            text = template.render(model: response)
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
        index = {}
        Global.logger.debug "Exporting wiki."
        WikiPage.all.to_a.sort_by { |p| p.heading }.each do |p|
          page_name = "#{FilenameSanitizer.sanitize(p.name)}.html"
          index[page_name] = p.heading
          
          #Global.logger.debug "Parsing wiki #{p.heading}"
          
          File.open(File.join(export_path, page_name), 'w') do |f|
            request = WebRequest.new( { args: { id: p.id } } )
            response = Website::GetWikiPageRequestHandler.new.handle(request)
            
            f.puts format_wiki_template(response[:text], p.heading)
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
        approved_chars = Chargen.approved_chars.select { |c| !c.is_admin? && c.is_approved? }
        gone_chars = Character.all.select { |c| c.idle_state == 'Gone' }
        dead_chars = Character.all.select { |c| c.idle_state == 'Dead' }

        all_chars = approved_chars.concat(gone_chars).concat(dead_chars)
        
        Global.logger.debug "Exporting characters."
        
        all_chars.sort_by { |c| c.name }.each do |c|
          #Global.logger.debug "Parsing character #{c.name}"
        
          page_name = "#{c.name}.html"
        
          File.open(File.join(export_path, page_name), 'w') do |f|
            
            index = build_scene_index(c.scenes_starring.sort_by { |s| s.icdate }.reverse)
            groups = index.group_by { |k, v| v[:type] }
            scenes_by_type = groups.map { |k, v| { name: k, scenes: v.map { |page, data| data } }}
            template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'wiki_scene_list.hbs'))
            scenes = template.render(types: groups.keys, scenes_by_type: scenes_by_type )

            request = WebRequest.new( { args: { id: c.id } } )
            response = Profile::CharacterRequestHandler.new.handle(request)

            template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'wiki_char.hbs'))
            text = template.render(char: response, scenes: scenes)
            
            f.puts format_wiki_template(text, c.name)
          end
        end
        
        File.open(File.join(export_path, "characters.html"), 'w') do |f|
          data = all_chars.map { |c| 
            {
              name: c.name,
              icon: Website.icon_for_char(c)
            }
          }
          template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'wiki_chars.hbs'))
          text = template.render(chars: data )
          f.puts format_wiki_template text, "Characters"
        end
        
      end
      
      def self.render_template(template_path, data, title)
        template = ExportHandlebarsTemplate.new(template_path)
        text = template.render(data || "")
        WikiExporter.format_wiki_template(text, title)
      end
      
      def self.format_wiki_template(text, title)
        text = (text || "").gsub("src=\"/", "src=\"")
        text = text.gsub(/href\=\"\/wiki\/([^\"]+)\/?/) { "href=\"#{FilenameSanitizer.sanitize($1)}.html" }
        text = AnsiFormatter.strip_ansi(text)

        template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'wiki_export.hbs'))
        template.render(body: text, page_title: title, mush_name: Global.read_config("game", "name"))
      end
    end
    
    class ExportHandlebarsTemplate
      def initialize(file)
        template = File.read(file)
        if (!AresMUSH.handlebars_context)
          AresMUSH.handlebars_context = Handlebars::Context.new
        end
        @handlebars = AresMUSH.handlebars_context
        template_contents = File.read(file)
        
        @template = @handlebars.compile(template_contents)
      end
    		      
      def render(data)
        @template.call(data)
      end	
      
    end
    
  end
end
