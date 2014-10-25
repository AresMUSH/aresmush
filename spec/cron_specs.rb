$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

module AresMUSH
  describe Cron do
    include GlobalTestHelper
   
    before do
      stub_global_objects
    end
      
    describe :raise_event do
      it "should send the cron event with the current time" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        Time.stub(:now) { time }
        dispatcher.should_receive(:on_event) do |event|
          event.class.should eq CronEvent
          event.time.should eq time
        end
        Cron.raise_event
      end
    end
    
    describe :is_cron_match? do
      it "should match a matching date" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "date" => 25 }
        Cron.is_cron_match?(cron, time).should be_true
      end

      it "should not match a different date" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "date" => 26 }
        Cron.is_cron_match?(cron, time).should be_false
      end
      
      it "should match a matching day of week" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "day_of_week" => "sat" }
        Cron.is_cron_match?(cron, time).should be_true
      end

      it "should not match a different day of week" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "day_of_week" => "sun" }
        Cron.is_cron_match?(cron, time).should be_false
      end
      
      it "should match a matching hour" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "hour" => 14 }
        Cron.is_cron_match?(cron, time).should be_true
      end

      it "should not match a different hour" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "hour" => 17 }
        Cron.is_cron_match?(cron, time).should be_false
      end
      
      it "should match a matching minute" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "minute" => 22 }
        Cron.is_cron_match?(cron, time).should be_true
      end

      it "should not match a different minute" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "minute" => 27 }
        Cron.is_cron_match?(cron, time).should be_false
      end
      
      
      it "should match a matching combo" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "minute" => 22, "hour" => 14, "date" => 25 }
        Cron.is_cron_match?(cron, time).should be_true
      end

      it "should not match a different combo" do
        time = Time.new(2014, 01, 25, 14, 22, 17)
        cron = { "minute" => 27, "hour" => 14, "date" => 25 }
        Cron.is_cron_match?(cron, time).should be_false
      end
    end
  end   
end
