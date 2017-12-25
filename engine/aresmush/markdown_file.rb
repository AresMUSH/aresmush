module AresMUSH
  class MarkdownFile
    def initialize(path)
      @path = path
    end
    
    def load_file
      return if @file
      @file = File.read(@path, :encoding => "UTF-8")
    end
    
    def metadata
      load_file
      if (md = @file.match(/^(?<metadata>---\s*\n.*?\n?)^(---\s*$\n?)/m))
        begin
          yaml = YAML.load(md[:metadata])
          return yaml
        rescue Exception => e
          raise "Exception parsing #{@path} -- #{e}"
        end
      else
        return nil
      end
    end
    
    def contents
      load_file
      if (md = @file.match(/^(?<metadata>---\s*\n.*?\n?)^(---\s*$\n?)/m))
        begin
          return md.post_match          
        rescue Exception => e
          raise "Exception parsing #{@path} -- #{e}"
        end
      else
        return @file
      end
    end
  end
end
      