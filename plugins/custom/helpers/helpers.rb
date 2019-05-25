module AresMUSH
  module Custom
    def self.channel_alert(message)
      channel = Global.read_config("custom", "alert_channel")
      if (channel)
        Channels.send_to_channel(channel, message)
      end
    end
    def self.wrap(s, width=78)
      s.gsub(/(.{1,#{width}})(\s+|\Z)/, "\\1\n")
    end
    def self.commify(v)
      (s=v.to_s;x=s.length;s).rjust(x+(3-(x%3))).scan(/.{3}/).join(",").strip
    end
  end
end
