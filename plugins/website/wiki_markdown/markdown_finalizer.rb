module AresMUSH
  module Website
    # This runs after all other markdown has been rendered, because it looks for
    # big blocks of text (like a tab view) and things that apply to the entire
    # page (like table of contents).
    class MarkdownFinalizer
      def self.process(markdown)
        tabs = {}
        gallery = []
        html = ""
        tab_name = nil
        toc = {}
        current_toc_level = nil
        in_gallery = false
        coder = HTMLEntities.new
        
        markdown.split(/[\r\n]/).each do |line|
          if ( line =~ /^(<p>)?(<br>)?`/)
            html << "#{line}\n"
          elsif ( line =~ /^(<p>)?(<br>)?<code>/)
            html << "#{line}\n"                    
          elsif (line =~ /^(<p>)?(<br>)?\[\[tabview\]\]/)
            tabs = {}
          elsif (line =~ /^(<p>)?(<br>)?\[\[gallery\]\]/)
            gallery = []
            in_gallery = true
          elsif (line =~ /^(<p>)?(<br>)?\[\[tab /)
            tab_name = line.after(" ").before("]")
            tabs[tab_name] = []
          elsif (line =~ /^(<p>)?(<br>)?\[\[\/tab\]\]/)
            tab_name = nil
          elsif (line =~ /^(<p>)?(<br>)?\[\[\/gallery\]\]/)
            in_gallery = false
            
            template = HandlebarsTemplate.new(File.join(AresMUSH.plugin_path, 'website', 'templates', 'image_gallery.hbs'))
        
            data = {
              "gallery" => gallery
            }
        
            html << template.render(data)     
            
          elsif (line =~ /^(<p>)?(<br>)?\[\[\/tabview\]\]/)
            html << '<ul class="nav nav-tabs">'
            tabs.each_with_index do |(tab_name, tab_lines), i|
              id = clean_anchor(tab_name)
              active = i == 0 ? "class=\"active\"" : ""
              html << "<li #{active}><a data-toggle=\"tab\" href=\"##{id}\">#{tab_name}</a></li>" 
            end
            html << '</ul>'
            
            html << '<div class="tab-content">'
            tabs.each_with_index do |(tab_name, tab_lines), i|
              id = clean_anchor(tab_name)
              active = i == 0 ? "active" : ""
              html << "<div id=\"#{id}\" class=\"tab-pane fade in #{active}\">"
              tab_lines.each do |tab_line|
                html << "#{tab_line}\n"
              end
              html << '</div>'
            end
            html << '</div>'
          elsif (line =~ /^(<p>)?(<br>)?\[\[toc\]\]/)
            html << "$TOC_GOES_HERE_MARKER$"
          elsif in_gallery
            image = line.gsub("<br>", "").strip
            if (image =~ /(.+)\/\*/)
              image_files = Dir["#{File.join(AresMUSH.game_path, 'uploads', $1)}/*"]
              image_files.each { |i| gallery << "#{$1}/#{File.basename(i)}"}
            else
              gallery << image
            end
          else
            if (line =~ /<h2>(.+)<\/h2>/)
              heading = coder.decode $1
              anchor = clean_anchor(heading)
              toc[heading] = []
              current_toc_level = heading
              html << "\n<a name=\"#{anchor}\"></a>"
            end

            if (line =~ /<h3>(.+)<\/h3>/)
              heading = coder.decode $1
              anchor = clean_anchor(heading)
              if (current_toc_level)
                toc[current_toc_level] << heading
              else
                toc[heading] = []
              end
              html << "\n<a name=\"#{anchor}\"></a>"
            end
                    
            if (tab_name)
              tabs[tab_name] << line
            else
              html << "#{line}\n"
            end
          end
          
        end
        
        toc_links = ""
        if (toc.any?)
          toc_links << "<div class=\"toc\">\n<h4>Table of Contents</h4>"
          toc_links << "<ul>"
          toc.each do |heading, sub_headings|
            toc_links << "<li><a href=\"\##{clean_anchor(heading)}\">#{heading.titleize}</a></li>"
            if (sub_headings.any?)
              toc_links << "<ul>"
              sub_headings.each do |sub_head|
                toc_links << "<li><a href=\"\##{clean_anchor(sub_head)}\">#{sub_head.titleize}</a></li>"                        
              end
              toc_links << "</ul>"
            end
          end
          toc_links << "</ul></div>"
        end

        html = html.gsub(Website.get_emoji_regex) { "<span class='emoji'>#{$1}</span>" }
        html.gsub("$TOC_GOES_HERE_MARKER$", toc_links)
      end
      
  
      def self.clean_anchor(text)
        anchor = (text || "").parameterize().downcase
        URI.escape(anchor)
      end
    end
  end
end
