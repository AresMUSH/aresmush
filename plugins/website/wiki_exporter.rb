module AresMUSH
  module Website
    module WikiExporter
      def self.export
        export_path = File.join(AresMUSH.root_path, "wiki_export")
        unless File.directory?(export_path)
          FileUtils.mkdir_p(export_path)
        end
  
        index = {}
        index["Characters"] = {}
        index["Scenes"] = {}
        index["Wiki"] = {}
        
        WikiPage.all.to_a.sort_by { |p| p.heading }.each do |p|
          page_name = "#{p.name}.html"
          index["Wiki"][page_name] = p.heading
          
          File.open(File.join(export_path, page_name), 'w') do |f|
            text = WebHelpers.format_markdown_for_html(p.current_version.text)
            text = text.gsub("src=\"/", "src=\"")
            text = text.gsub(/href\=\"\/wiki\/([^\"]+)\/?/) { "href=\"#{FilenameSanitizer.sanitize($1)}.html" }
            text = AnsiFormatter.strip_ansi(text)
            f.puts WikiExporter.format_wiki_template(text, p.heading)
          end
        end
  
        Scene.all.select { |s| s.shared }.sort_by { |s| s.icdate }.each do |s|
          filename = FilenameSanitizer.sanitize(s.title)
          page_name = "#{s.icdate}-#{filename}.html"
          index["Scenes"][page_name] = "#{s.icdate} - #{s.title}"
          
          File.open(File.join(export_path, page_name), 'w') do |f|

            heading = "<p><b>Participants:</b> #{s.participant_names.join(',')}</p>"
            heading << "<p><b>Location:</b> #{s.location}</p>"
            heading << "<p><b>Summary:</b> #{s.summary}</p>"

            log = WebHelpers.format_markdown_for_html(s.scene_log.log)
            
            text = "#{heading}#{log}"
            f.puts WikiExporter.format_wiki_template(text, s.title)
          end
        end
        
        
        Character.all.select { |c| !c.is_admin? && c.is_approved? }.sort_by { |c| c.name }.each do |c|
          page_name = "#{c.name}.html"
          index["Characters"][page_name] = "#{c.name} (#{Ranks.military_name(c)})"
          
          File.open(File.join(export_path, page_name), 'w') do |f|
            icon = WebHelpers.icon_for_char(c)
            text = "<img style=\"max-height: 200px\" src=\"game/uploads/#{icon}\">"
            text << c.demographics.sort.map { |k, v| "<p><b>#{k}:</b> #{v}</p>"}.join
            text << "<h2>Background</h2>"
            text << WebHelpers.format_markdown_for_html(c.background || "")
            text << "<h2>Profile</h2>"
            text << c.profile.sort.map { |k, v| "<h3>#{k}:</h3> <p>#{WebHelpers.format_markdown_for_html(v)}</p>"}.join
            text << "<h2>Relationships</h2>"
            text << c.relationships.sort.map { |k, v| "<h3>#{k}:</h3> <p>#{WebHelpers.format_markdown_for_html(v['relationship'])}</p>"}.join
            text = text.gsub(/href\=\"\/([^\"]+)\/?/, `href="\1.html"`)
            text = text.gsub("src=\"/", "src=\"")
            (c.profile_gallery || []).each do |g|
              text << "<img style=\"max-height: 200px\" src=\"game/uploads/#{g}\">"
            end

            f.puts WikiExporter.format_wiki_template(text,c.name)
          end
        end
        
        File.open(File.join(export_path, "index.html"), 'w') do |f|
          index.each do |section, data|
            f.puts "<h1>#{section}</h1>"
            
            f.puts "<ul>"
            data.each do |page, title|
              f.puts "<li><a href=\"#{page}\">#{title}</a>"
            end
            f.puts "</ul>"
          end
        end
        
        path = File.join(export_path, "game")
        unless File.directory?(path)
          FileUtils.mkdir_p(path)
        end
  
        path = File.join(export_path, "game", "uploads")
        FileUtils.cp_r(File.join(AresMUSH.game_path, "uploads"), path)
      end    

      def self.format_wiki_template(text, heading)
        html = "<html><body>"
        html << '<div style="background-image:url(game/uploads/theme_images/background.png);width:100%;height:200px;background-size:cover">'
        html << '<h1 style="color:white;background-color:rgba(255,255,255,0.5)">TEST</h1>'
        html << "</div>"
        html << "<h1>#{heading}</h1>"
        html << text
        html << "</body></html>"
      
        AnsiFormatter.strip_ansi html
      end
    end
  end
end