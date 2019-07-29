module AresMUSH
  module Utils
    class ColorsCmd
      include CommandHandler

      def handle
        list = []
        ['n', 'x', 'r', 'g', 'y', 'b', 'm', 'c', 'w'].each do |c|
          fg = "\\%x#{c.ljust(3)} -- %x#{c}Text%xn"
          bg = "\\%x#{c.upcase.ljust(3)} -- %x#{c.upcase}Text%xn"
          downgrade = AnsiFormatter.get_code("%x#{c}", "ANSI")
          list << "#{fg}%t%t%t#{bg}%t%t%t#{downgrade}****%xn"
        end
        
        (1..256).each do |c|
          fg = "\\%x#{c.to_s.ljust(3)} -- %x#{c}Text%xn"
          bg = "\\%X#{c.to_s.ljust(3)} -- %X#{c}Text%xn"
          downgrade = AnsiFormatter.get_code("%x#{c}", "ANSI")
          list << "#{fg}%t%t%t#{bg}%t%t%t#{downgrade}****%xn"
        end
        
        
        template = BorderedPagedListTemplate.new list, cmd.page, 25, t('ansi.colors_title'), t('ansi.x_or_c'), t('ansi.colors_subtitle')
        client.emit template.render
      end
    end
  end
end
