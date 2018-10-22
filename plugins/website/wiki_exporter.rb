require 'open-uri'

module AresMUSH
  module Website
   
    module WikiExporter
      def self.export
        begin
          unless File.directory?(export_path)
            FileUtils.mkdir_p(export_path)
          end
  
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
          
        rescue Exception => ex
          puts "Error doing web export: #{ex} #{ex.backtrace[0,10]}"
        end
      end   
      
      def self.export_path
        File.join(AresMUSH.root_path, "wiki_export")
      end
      
      def self.template_path
        File.join(Global.read_config("website", "website_code_path"), "app", "templates")
      end
      
      def self.export_index
        File.open(File.join(export_path, "index.html"), 'w') do |f|
          text = '<div class="jumbotron">'
          text << "<img src=\"game/uploads/theme_images/jumbotron.png\" />"
          welcome = Website.welcome_text
          text << "<p>#{welcome}</p>"
          text << "</div>"
          f.puts format_wiki_template(text, "Home")
        end
      end
      
      def self.export_scenes
        index = {}
        scenes = Scene.shared_scenes.sort_by { |s| s.icdate }.reverse
        scenes.each do |s|
          puts "Parsing scene #{s.id} #{s.title}"
        
          filename = FilenameSanitizer.sanitize(s.title)
          page_name = "#{s.icdate}-#{filename}.html"
          index[page_name] = {}
          index[page_name][:title] = s.date_title
          index[page_name][:summary] = s.summary
          index[page_name][:participants] = s.participant_names.join(", ")
        
          File.open(File.join(export_path, page_name), 'w') do |f|
          
            request = WebRequest.new( { args: { id: s.id } } )
            response = Scenes::GetSceneRequestHandler.new.handle(request)
            
            f.puts render_template(File.join(template_path, 'scene.hbs'), { model: response }, s.date_title)
          end
        end
        
        File.open(File.join(export_path, "scenes.html"), 'w') do |f|
          text = "<h1>Scenes</h1>"
          index.each do |page, data|
            text << "<p><b><a href=\"#{page}\">#{data[:title]}</a></b>"
            text << "<br/>#{data[:summary]}"
            text << "<br/>#{data[:participants]}</p>"
            text << "<hr/>"
          end
          f.puts format_wiki_template(text, "Scenes")
        end
        
      end 

      def self.export_wiki
        index = {}
        WikiPage.all.to_a.sort_by { |p| p.heading }.each do |p|
          page_name = "#{FilenameSanitizer.sanitize(p.name)}.html"
          index[page_name] = p.heading
          
          puts "Parsing wiki #{p.heading}"
          
          File.open(File.join(export_path, page_name), 'w') do |f|
            request = WebRequest.new( { args: { id: p.id } } )
            response = Website::GetWikiPageRequestHandler.new.handle(request)
            
            f.puts format_wiki_template(response[:text], p.heading)
            
            #f.puts render_template(File.join(template_path, 'wiki-page.hbs'), { model: response }, p.heading)
          end
        end
        
        File.open(File.join(export_path, "wiki.html"), 'w') do |f|
          text = "<h1>Wiki</h1>"
          text << "<p><b><a href=\"home.html\">Wiki Home</a></b></p>"
          text << "<h2>All Pages</h2>"
          text << "<ul>"
          index.each do |page, title|
            text << "<li><a href=\"#{page}\">#{title}</a>"
          end
          text << "</ul>"
          f.puts format_wiki_template(text, "Wiki")
        end
      end
      
      def self.export_chars
        approved_chars = Chargen.approved_chars.select { |c| !c.is_admin? && c.is_approved? }.sort_by { |c| c.name }
        
        approved_chars.each do |c|
          puts "Parsing character #{c.name}"
        
          page_name = "#{c.name}.html"
        
          File.open(File.join(export_path, page_name), 'w') do |f|
            template = ExportHandlebarsTemplate.new(File.join(template_path, 'char.hbs'))
            request = WebRequest.new( { args: { id: c.id } } )
            response = Profile::CharacterRequestHandler.new.handle(request)
            
            profile = ""
            profile << '<script type="text/javascript" src="https://www.youtube.com/player_api"></script>'
            profile << '<script type="text/javascript" src="game/scripts/music_player.js"></script>'

            profile << "<h1>#{c.name}</h1>"
            profile << "<div class=\"row profile-wrap\">"
            request = WebRequest.new( { args: { id: c.id } } )
            
            profile << render_partial(File.join(template_path, 'components', 'profile-demographics.hbs'), { char: response })
            profile << "</div>"
            
            profile << '<div class="profile-tab">'
            profile << render_partial(File.join(template_path, 'components', 'profile-supplemental.hbs'), { char: response })
            profile << "</div>"
            
            profile << '<div class="profile-tab">'
            profile << render_partial(File.join(template_path, 'components', 'profile-relationships.hbs'), { char: response })
            profile << "</div>"
            
            profile << '<div class="profile-tab">'
            profile << render_partial(File.join(template_path, 'components', 'profile-system.hbs'), { char: response })
            profile << "</div>"
            
            profile << '<div class="profile-tab">'
            profile << render_partial(File.join(template_path, 'components', 'profile-gallery.hbs'), { char: response })
            profile << "</div>"
            
            
            f.puts format_wiki_template(profile, c.name)
          end
        end
        
        File.open(File.join(export_path, "characters.html"), 'w') do |f|
          data = approved_chars.map { |c| 
            {
              name: c.name,
              icon: Website.icon_for_char(c)
            }
          }
          text = render_partial(File.join(template_path, 'components', 'char-group-list.hbs'), { chars: data } )
          f.puts format_wiki_template text, "Characters"
        end
        
      end
      
      def self.render_partial(template_path, data)
        template = ExportHandlebarsTemplate.new(template_path)
        text = template.render(data)
        text
      end
            
      def self.render_template(template_path, data, title)
        template = ExportHandlebarsTemplate.new(template_path)
        text = template.render(data)
        WikiExporter.format_wiki_template(text, title)
      end
      
      def self.format_wiki_template(text, title)
        text = text.gsub("src=\"/", "src=\"")
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
        
        @handlebars.register_helper("link-to") do |this, page, param1, param2, block |
          if (block)
            "<a href=\"index.html\">#{block.fn(this)}</a>"
          elsif (param2)
            "<a href=\"index.html\">#{param2.fn(this)}</a>"
          else 
            "<a href=\"index.html\">#{param1.fn(this)}</a>"
          end
        end
        
        @handlebars.register_helper("mut") do |this, context, block|
          ""
        end
        
        @handlebars.register_helper("not") do |this, context, block|
          true
        end
        
        @handlebars.register_helper("action") do |this, context, block|
          ""
        end
        
        @handlebars.register_helper("not-eq") do |this, context, block|
          ""
        end
        
        @handlebars.register_helper("title") do |this, context, block|
          ""
        end
        
        template_path = File.join(AresMUSH.root_path, "..", "ares-webportal", "app", "templates")
        
        file = File.join(template_path, 'components', 'fs3-sheet.hbs')
        @handlebars.register_partial("fs3-sheet", File.read(file))

        file = File.join(template_path, 'components', 'fs3-damage.hbs')
        @handlebars.register_partial("fs3-damage", File.read(file))
        
        
        template_contents = template_contents.gsub("{{{ansi-format text=", "{{{")

        template_contents = template_contents.gsub("{{fs3-sheet char=char}}", "{{>fs3-sheet}}")
        template_contents = template_contents.gsub("{{fs3-damage char=char}}", "{{>fs3-damage}}")
        

        template_contents = replace_char_icon(template_contents, "c")
        template_contents = replace_char_icon(template_contents, "p")
        template_contents = replace_relationship_icon(template_contents)
        
        @template = @handlebars.compile(template_contents)
      end
    		      
      def render(data)
        @template.call(data)
      end	
      
      def replace_char_icon(template_contents, key)
        template_contents.gsub("{{char-icon char=#{key}}}", "<div class=\"char-icon-container\"><div class=\"log-icon-container\"><a href=\"{{#{key}.name}}.html\"><img src=\"game/uploads/{{#{key}.icon}}\" class=\"log-icon\"/></a></div></div><div class=\"log-icon-title-container\"><div class=\"log-icon-title\">{{#{key}.name}}</div></div>") 
      end	
      
      def replace_relationship_icon(template_contents)
        template_contents.gsub("{{relationship-icon char=ship}}", "<div class=\"char-icon-container\"><div class=\"log-icon-container\"><a href=\"{{ship.name}}.html\"><img src=\"game/uploads/{{ship.icon}}\" class=\"log-icon\"/></a></div></div><div class=\"log-icon-title-container\"><div class=\"log-icon-title\">{{ship.name}}</div></div>") 
      end	
    end
    
  end
end
