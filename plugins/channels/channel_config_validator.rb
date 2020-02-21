module AresMUSH
  module Channels
    class ChannelConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("channels")
      end
      
      def validate
        announce_chan = Global.read_config("channels", "announce_channel")
        self.check_chanel_exists("announce_channel", announce_chan)

        @validator.require_list("default_channels")
        Global.read_config("channels", "default_channels").each do |c|
          self.check_chanel_exists("default_channels", c)
        end
        @validator.require_list("approved_channels")
        Global.read_config("channels", "approved_channels").each do |c|
          self.check_chanel_exists("approved_channels", c)
        end
        @validator.check_cron("clear_history_cron")
        ooc_lounge_channel = Global.read_config("channels", "ooc_lounge_channel")
        if (!ooc_lounge_channel.blank?)
          self.check_chanel_exists("ooc_lounge_channel", ooc_lounge_channel)
        end
        @validator.require_int("recall_timeout_days", 1, 365)
        @validator.require_int("recall_buffer_size", 100, 2000)
        @validator.require_nonblank_text("start_marker")
        @validator.require_nonblank_text("end_marker")
        @validator.errors
      end
      
      def check_chanel_exists(field, name)
        channel = Channel.named(name)
        if (!channel)
          @validator.add_error("channels:#{field} - #{name} is not a valid channel.")
        end
      end
    end
  end
end