module AresMUSH
  class WebApp    
    
    helpers do
      
      def icon_for_name(name)
        char = Character.find_one_by_name(name)
        if (char)
          icon = char.icon
        else
          icon = nil
        end
        icon || "/images/noicon.png"
      end

      # Takes something from a text box and replaces carriage returns with %r's for MUSH.
      def format_input_for_mush(input)
        return nil if !input
        input.gsub(/\r\n/, '%r')
      end

      # Takes MUSH text and formats it for a text box with %r's becoming line breaks.      
      def format_input_for_html(input)
        return nil if !input
        input.gsub(/%r/i, '&#013;&#010;')
      end
      
      # Takes MUSH text and formats it for display in a div, with %r's becoming HTML breaks.
      def format_output_for_html(output)
        return nil if !output
        text = AresMUSH::ClientFormatter.format output, false
        text.strip.gsub(/[\n]/i, '<br/>')
      end
      
      def format_markdown_for_html(output)
        return nil if !output
        
        music_player = Proc.new do |input|
          return "" if !input
          text = erb :"chars/music_player", :locals => { 
              youtubecode: input.before(' '), 
              description: input.after(' '),
              id: SecureRandom.uuid.gsub('-','') }
          text
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
          
          erb :"image", :locals => {
            source: source,
            style: style, 
            align: align
          }
        end
        
        help = Proc.new do |input|
          return "" if !input
          Help.command_help(input)          
        end
        
        allow_html = Global.read_config('website', 'allow_html_in_markdown')
        text = AresMUSH::ClientFormatter.format output, false
        html_formatter = AresMUSH::Website::WikiMarkdownFormatter.new(!allow_html, { help: help}, { musicplayer: music_player, image: image })
        text = html_formatter.to_html text
        #text = text.gsub(/\[\[musicplayer ([^\]]*)\]\]/i) { music_player(Regexp.last_match[1]) }
        text
      end

      
      def titlecase_arg(input)
        return nil if !input
        input.titlecase
      end

    end

  end
end
