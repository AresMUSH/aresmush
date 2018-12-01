module AresMUSH
  module Who
    class WhereCmd
      include CommandHandler
      
      attr_accessor :search, :mode
      
      def parse_args
        self.search = titlecase_arg(cmd.args)
        self.mode = downcase_arg(cmd.switch)
      end
      
      def allow_without_login
        true
      end
      
      def handle
        online_chars = Global.client_monitor.logged_in.map { |client, char| char }
        if (self.search)
          online_chars = online_chars.select { |char| char.name =~ /^#{search}/  }
        end
        case self.mode
        when "ic"
          online_chars = online_chars.select { |char| char.status == "IC"  }
        when "friends"
          online_chars = online_chars.select { |char| enactor.is_friend?(char)  }
        end
        template = WhereTemplate.new online_chars
        client.emit template.render
      end      
    end
  end
end
