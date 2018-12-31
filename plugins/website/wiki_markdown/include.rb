module AresMUSH
  module Website
    class IncludeMarkdownExtension
      def self.regex
        /\[\[include ([^\]]*)\]\]/i
      end
      
      def self.parse(matches)
        input = matches[1]
        return "" if !input

        page_name = input.before("\n").strip.downcase
        
        begin          
          vars = {}
          
          split_vars = (input.after("\n") || "").split("|")
          split_vars.each do |v|
            var_name = v.before('=')
            var_val = v.after('=')
            if (var_name && var_val)
              vars[var_name.strip.downcase.to_sym] = var_val.strip
            end
          end

          page = WikiPage.find_by_name_or_id(page_name)
          if (!page)
            return "Page #{page_name} not found."
          end
                    
          page.current_version.text % vars

        rescue Exception => ex
          Global.logger.debug "Error loading include #{page_name} : #{ex}"
          error_message = "<div class=\"alert alert-danger\">There was a problem including #{page_name}.  Make sure the page exists and all required variables are set.  Error: #{ex.message}</div>"
          return error_message
        end
      end
    end
  end
end
