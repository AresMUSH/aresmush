module AresMUSH
  module Describe
    class ClientTemplate
      include TemplateFormatters
      
      def initialize(client)
        @client = client
        @char = client.char
      end
      
      def name
        @char.name
      end
      
      def description
        @char.description
      end
      
      def shortdesc
        @char.shortdesc
      end
      
      def fullname_and_rank
        "#{@char.rank} #{@char.fullname}"
      end
      
      def afk_message
        if (@char.is_afk)
          format_afk_message
        elsif (Status.is_idle?(@client))
          "%xy%xh<#{t('describe.idle')}>%xn"
        else
          ""
        end
      end
      
      def fullname
        @char.fullname
      end
      
      def actor
        @char.actor
      end

      def format_afk_message
        msg = "%xy%xh<#{t('describe.afk')}>%xn"
        if (@char.afk_message)
          msg = "#{msg} %xy#{@char.afk_message}%xn"
        end
        msg
      end
    end
  end
end