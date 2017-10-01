module AresMUSH
  module Website
    class IncludeMarkdownExtension
      def self.regex
        /\[\[include ([^\]]*)\]\]/i
      end
      
      def self.parse(matches, sinatra)
        input = matches[1]
        return "" if !input

        begin          
          page_name = input.downcase
          page = WikiPage.find_by_name_or_id(page_name)
          
          if (page)
            page.current_version.text
          else
            vars = {}
            
            page_name = page_name.before("\n").strip
            split_vars = (input.after("\n") || "").split("|")
            split_vars.each do |v|
              var_name = v.before('=')
              var_val = v.after('=')
              if (var_name && var_val)
                vars[var_name.strip.downcase] = var_val.strip
              end
            end
            
            sinatra.erb "/wiki/#{page_name}".to_sym, :locals => { vars: vars }, :layout => false
          end
        rescue Exception => ex
          Global.logger.debug "Error loading include #{input} : #{ex}"
          "<div class=\"alert alert-danger\">Include not found: #{input}</div>"
        end
      end
    end
  end
end
