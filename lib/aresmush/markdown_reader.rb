module AresMUSH
  class MarkdownFile
    def initialize(path)
      @path = path
    end
    
    def loadFile
      return if @file
      @file = File.read(@path, :encoding => "UTF-8")
    end
    
    def metadata
      loadFile
      if (md = @file.match(/^(?<metadata>---\s*\n.*?\n?)^(---\s*$\n?)/m))
        begin
          yaml = YAML.load(md[:metadata])
          return yaml
        rescue Exception => e
          raise "Exception parsing #{path} -- #{e}"
        end
      else
        raise "Help file missing metadata header! #{path}"
      end
    end
    
    def contents
      loadFile
      if (md = @file.match(/^(?<metadata>---\s*\n.*?\n?)^(---\s*$\n?)/m))
        begin
          return md.post_match          
        rescue Exception => e
          raise "Exception parsing #{path} -- #{e}"
        end
      else
        raise "Help file missing metadata header! #{path}"
      end
    end
  end
end
      