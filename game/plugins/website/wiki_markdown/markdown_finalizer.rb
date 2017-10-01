module AresMUSH
  module Website
    
    # This runs after all other markdown has been rendered, because it looks for
    # big blocks of text (like a tab view) and things that apply to the entire
    # page (like table of contents).
    class MarkdownFinalizer
      def self.process(markdown)
        tabs = {}
        html = ""
        tab_name = nil
        toc = {}
        current_toc_level = nil
        
        markdown.split(/[\r\n]/).each do |line|
          if ( line =~ /^(<p>)?(<br>)?`/)
            html << "#{line}\n"
          elsif ( line =~ /^(<p>)?(<br>)?<code>/)
            html << "#{line}\n"                    
          elsif (line =~ /^(<p>)?(<br>)?\[\[tabview\]\]/)
            tabs = {}
          elsif (line =~ /^(<p>)?(<br>)?\[\[tab /)
            tab_name = line.after(" ").before("]")
            tabs[tab_name] = []
          elsif (line =~ /^(<p>)?(<br>)?\[\[\/tab\]\]/)
            tab_name = nil
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
          else
            if (line =~ /<h2>(.+)<\/h2>/)
              anchor = clean_anchor($1)
              toc[anchor] = []
              current_toc_level = anchor
              html << "\n<a name=\"#{anchor}\"></a>"
            end

            if (line =~ /<h3>(.+)<\/h3>/)
              anchor = clean_anchor($1)
              if (current_toc_level)
                toc[current_toc_level] << anchor
              else
                toc[anchor] = []
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
          toc_links << "<p><b>Table of Contents</b></p>"
          toc_links << "<ul class=\"toc\">"
          toc.each do |heading, sub_headings|
            toc_links << "<li><a href=\"\##{heading}\">#{heading.titleize}</a></li>"
            if (sub_headings.any?)
              toc_links << "<ul>"
              sub_headings.each do |sub_head|
                toc_links << "<li><a href=\"\##{sub_head}\">#{sub_head.titleize}</a></li>"                        
              end
              toc_links << "</ul>"
            end
          end
          toc_links << "</ul>"
        end
                
        html.gsub("$TOC_GOES_HERE_MARKER$", toc_links)
      end
      
  
      def self.clean_anchor(text)
        anchor = (text || "").gsub(/[?&= ]/, '-').downcase
        URI.escape(anchor)
      end
    end
  end
end
