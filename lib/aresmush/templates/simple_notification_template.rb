module AresMUSH
  class SimpleNotificationTemplate < ErbTemplateRenderer
          
    attr_accessor :text, :type
    
    def initialize(text, type)

      @text = text
      @type = type
      
      super File.dirname(__FILE__) + "/simple_notification.erb"
    end
    
    def color
      case @type.to_s
      when "ooc"
        "%xc"
      when "success"
        "%xg"
      when "failure"
        "%xr"
      else
        ""
      end
    end
    
    def prefix
      case @type.to_s
      when "ooc", "success", "failure"
        "%% "
      else
        ""
      end
    end
  end
end
