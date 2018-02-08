module AresMUSH
  module Login
    class ActivityCmd
      include CommandHandler
    
      def handle
        
        # 0 = 0-3
        # 1 - 4-7
        # 2 - 8-11
        # 3 - 12-15
        # 4 - 16-19
        # 5 - 20-23
        
        days = [ 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' ]
        times = [ '12-3am', '4-7am', '8-11am', '12-3pm', '4-7pm', '8-11pm']
        

        str = "        "
        activity = Game.master.login_activity
        
        times.each do |time|
          str << time.center(10)
        end
        
        days.each_with_index do |day, day_index|
          str << "%r#{day.ljust(10)}"
          times.each_with_index do |time, time_index|
            day_samples = activity[day_index.to_s] || {}
            samples = day_samples[time_index.to_s] || [ 0 ]
                        
            total = samples.inject(:+)
            average = (total / samples.count.to_f).round
            
            str << "#{graph(average)}".ljust(8)
            str << "  "
          end
        end
        
        template = BorderedDisplayTemplate.new str, t('login.activity_header'),  "%ld%R#{t('login.activity_footer')}"
        client.emit template.render
      end
      
      def graph(num)
        if (num >= 40)
          return "@@@@@@@@"
        end
        
        whole = (num / 5).times.collect { "@" }.join
        half = (num % 5 > 0) ? "o" : ""
        "#{whole}#{half}"
      end
      
    end
  end
end
