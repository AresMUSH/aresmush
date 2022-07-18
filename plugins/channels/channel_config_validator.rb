module AresMUSH
  module Channels
    class ChannelConfigValidator
      attr_accessor :validator
      
      def initialize
        @validator = Manage::ConfigValidator.new("channels")
      end
      
      def validate
        announce_chan = Global.read_config("channels", "announce_channel")
        @validator.check_cron("clear_history_cron")
        @validator.require_int("recall_timeout_days", 1, 365)
        @validator.require_int("recall_buffer_size", 100, 2000)
        @validator.require_nonblank_text("start_marker")
        @validator.require_nonblank_text("end_marker")
        @validator.require_list('default_channels')
        @validator.require_list('approved_channels')
        @validator.require_in_list("discord_gravatar_style", ['retro', 'identicon', 'monsterid', 'wavatar', 'robohash' ])
        @validator.require_text("discord_prefix")


        begin
          @validator.check_channels_exist('default_channels')
          @validator.check_channels_exist('approved_channels')

          ooc_lounge_channel = Global.read_config("channels", "ooc_lounge_channel")
          if (!ooc_lounge_channel.blank?)
            @validator.check_channel_exists("ooc_lounge_channel")
          end
        
          @validator.check_channel_exists("announce_channel")
        rescue Exception => ex
          @validator.add_error "Unknown channel config error.  Fix other errors first and try again. #{ex} #{ex.backtrace[0, 3]}"
        end
        
        @validator.errors
      end
    end
  end
end