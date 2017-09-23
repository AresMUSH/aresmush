module AresMUSH
  
  module Website
    
    # Enables the //italics// format that everyone is used to.
    class HTMLWithWikiExtensions < Redcarpet::Render::HTML
      def initialize(pre_tag_blocks, post_tag_blocks, options)
        @pre_tag_blocks = pre_tag_blocks
        @post_tag_blocks = post_tag_blocks
        super options
      end
      
      def preprocess(text)
        #text = text.gsub(/\[\[tabnavlist\]\]/i, '<ul class="nav nav-tabs">')
        #text = text.gsub(/\[\[\/tabnavlist\]\]/i, '</ul>')
        
        #text = text.gsub(/\[\[tabnav ([^\]]*)\]\]/i) do |input|
        #  name = Regexp.last_match[1]
        #  id = (name || "").gsub(' ', '-').downcase
        #  "<li><a data-toggle=\"tab\" href=\"##{id}\">#{name}</a></li>" 
        #end
        
        
        text = text.gsub(/[^`]\[http([^\] ]*) ([^\]]*)\]/i, '[\2](http\1)')
                
        @pre_tag_blocks.each do |tag, block|
          text = text.gsub(/\[\[#{tag} ([^\]]*)\]\]/i) { block.call(Regexp.last_match[1]) }
        end
        text
      end
      
      def wiki_url(text)
        if (text =~ /\|/)
          url = text.before('|')
          link = text.after('|')
        else
          url = text
          link = text
        end
        
        if (link =~ /:/)
          link = link.after(":")
        end
        
        "<a href=\"/wiki/#{url}\">#{link}</a>"
      end
      
      def postprocess(text)
        return text if text =~ /^(<p>)?(<br>)?<code>/
        
        text = text.gsub(/\/\/([^\/\r\n]+)\/\//, '<em>\1</em>')
        text = text.gsub(/\&quot\;/i, '"')
        text = text.gsub(/\[\[div([^\]]*)\]\]/i, '<div \1>')
        text = text.gsub(/\[\[span([^\]]*)\]\]/i, '<span \1>')
        text = text.gsub(/\[\[\/div\]\]/i, "</div>")
        text = text.gsub(/\[\[\/span\]\]/i, "</span>")
        #text = text.gsub(/\[\[tabview\]\]/i, '<div class="tab-content">')
        #text = text.gsub(/\[\[\/tabview\]\]/i, '</div>')
        #text = text.gsub(/\[\[\/tab\]\]/i, '</div>')
        
        text = text.gsub(/\[\[\[([^\]]*)\]\]\]/i) { wiki_url(Regexp.last_match[1]) }
                        
        #text = text.gsub(/\[\[tab ([^\]]*)\]\]/i) do |input|
        #  id = (Regexp.last_match[1] || "").gsub(' ', '-').downcase
        #  "<div id=\"#{id}\" class=\"tab-pane fade in\">"
        #end
        
        
        @post_tag_blocks.each do |tag, block|
          text = text.gsub(/\[\[#{tag} ([^\]]*)\]\]/i) { block.call(Regexp.last_match[1]) }
        end
        
        text
      end
    end

    class WikiMarkdownFormatter
      def initialize(escape_html, sinatra)
        
        options = {
          tables: true,
          no_intra_emphasis: true,
          autolink: true,
          fenced_code_blocks: true
        }
            
        pre_tag_blocks = {}
        
        
        music_player = Proc.new do |input|
          return "" if !input
          text = sinatra.erb :"chars/music_player", :locals => { 
            youtubecode: input.before(' '), 
            description: input.after(' '),
            id: SecureRandom.uuid.gsub('-','') }
            text
          end
        
          do_include = Proc.new do |input|
            begin
              sinatra.erb "/wiki/#{input}".to_sym
            rescue
              "<div class=\"alert alert-danger\">Include not found: #{input}</div>"
            end
          end
        
          image = Proc.new do |input|
            return "" if !input
            style = ""
            source = ""
            align = nil
            options = input.split(' ')
            options.each do |opt|
              option_name = opt.before('=') || ""
              option_value = opt.after('=') || ""
            
              case option_name.downcase.strip
              when 'width'
                style << " width:#{option_value};"
              when 'height'
                style << " height:#{option_value};"
              when 'center', 'left', 'right'
                align = opt.strip
              when 'source', 'src'
                source = option_value.strip
              else
                source = opt.strip
              end
            end
          
            sinatra.erb :"image", :locals => {
              source: source,
              style: style, 
              align: align
            }
          end
        
          char_gallery = Proc.new do |input|
            tags = (input || "").split(" ")
          
            or_tags = tags.select { |tag| !tag.start_with?("-") && !tag.start_with?("+")}
             
            required_tags = tags.select { |tag| tag.start_with?("+") }
            .map { |tag| tag.after("+") }
             
            exclude_tags = tags.select { |tag| tag.start_with?("-") }
            .map { |tag| tag.after("-") }
          
            matches = Character.all.select { |c| 
              ((c.profile_tags & or_tags).any? && 
              (c.profile_tags & exclude_tags).empty?) &&
              (required_tags & c.profile_tags == required_tags) }
          
              sinatra.erb :"chars/group_list", :locals => {
                chars: matches,
                title: ""
              }

            end
        
            page_list = Proc.new do |input|
              tags = (input || "").split(" ")
          
              or_tags = tags.select { |tag| !tag.start_with?("-") && !tag.start_with?("+")}
             
              required_tags = tags.select { |tag| tag.start_with?("+") }
              .map { |tag| tag.after("+") }
             
              exclude_tags = tags.select { |tag| tag.start_with?("-") }
              .map { |tag| tag.after("-") }
          
              matches = WikiPage.all.select { |p| 
                ((p.tags & or_tags).any? && 
                (p.tags & exclude_tags).empty?) &&
                (required_tags & p.tags == required_tags) }
          
                sinatra.erb :"wiki/page_list", :locals => {
                  pages: matches
                }
              end
        
              scene_list = Proc.new do |input|
                tags = (input || "").split(" ")
          
                or_tags = tags.select { |tag| !tag.start_with?("-") && !tag.start_with?("+")}
             
                required_tags = tags.select { |tag| tag.start_with?("+") }
                .map { |tag| tag.after("+") }
             
                exclude_tags = tags.select { |tag| tag.start_with?("-") }
                .map { |tag| tag.after("-") }
          
                matches = Scene.all.select { |p| 
                  ((p.tags & or_tags).any? && 
                  (p.tags & exclude_tags).empty?) &&
                  (required_tags & p.tags == required_tags) }
          
                  sinatra.erb :"scenes/scene_list", :locals => {
                    scenes: matches
                  }
                end
        
        
                post_tag_blocks =  
                {  
                  musicplayer: music_player, 
                  image: image, 
                  include: do_include,
                  chargallery: char_gallery,
                  pagelist: page_list,
                  scenelist: scene_list
                }            
            
                renderer = HTMLWithWikiExtensions.new(pre_tag_blocks, post_tag_blocks, 
                hard_wrap: true, 
                autolink: true, 
                safe_links_only: true,
                escape_html: escape_html)
            
                @engine = Redcarpet::Markdown.new(renderer, options)
              end
  
              def to_html(markdown)
                rendered = @engine.render markdown
                parse_whole_doc_tags rendered
              end
  
              def clean_anchor(text)
                anchor = (text || "").gsub(' ', '-').downcase
                URI.escape(anchor)
              end
  
              def parse_whole_doc_tags(rendered)
                tabs = {}
                html = ""
                tab_name = nil
                toc = {}
                current_toc_level = nil
        
                rendered.split(/[\r\n]/).each do |line|
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
            end

          end
        end

