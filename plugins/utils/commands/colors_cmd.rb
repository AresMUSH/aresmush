module AresMUSH
  module Utils
    class ColorsCmd
      include CommandHandler

      def handle
        list = []
        ['n', 'x', 'r', 'g', 'y', 'b', 'm', 'c', 'w'].each do |c|
          fg = "\\%x#{c.ljust(3)} -- %x#{c}Text%xn"
          bg = "\\%x#{c.upcase.ljust(3)} -- %x#{c.upcase}Text%xn"
          list << "#{fg}%t%t%t#{bg}"
        end
        
        (1..256).each do |c|
          fg = "\\%x#{c.to_s.ljust(3)} -- %x#{c}Text%xn"
          bg = "\\%X#{c.to_s.ljust(3)} -- %X#{c}Text%xn"
          list << "#{fg}%t%t%t#{bg}"
        end
        
        
        template = BorderedPagedListTemplate.new list, cmd.page, 25, t('ansi.colors_title'), t('ansi.x_or_c')
        client.emit template.render
      end
    end
  end
end
