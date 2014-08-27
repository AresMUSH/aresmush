$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require "aresmush"

# Mixin that allows to manipulate strings that contain ANSI color codes:
# getting their length, printing their n first characters, etc.
#
# Additionally, it can output certain commonly needed sequences — using the
# {#print} method to write to the output.
module CANSI
  Code = %r{(\e\[\??\d+(?:[;\d]*)\w)}

  # @return [Integer] Amount of characters within the string, disregarding
  #   color codes.
  def ansi_length(string)
    strip_ansi_codes(string).length
  end

  # @return [String] The initial string without ANSI codes.
  def strip_ansi_codes(string)
    string.gsub(Code, "")
  end

  # @return [Boolean] True if the beginning of the string is an ANSI code.
  def start_with_ansi_code?(string)
    (string =~ Code) == 0
  end

  # Prints a slice of a string containing ANSI color codes. This allows to
  # print a string of a fixed width, while still keeping the right colors,
  # etc.
  #
  # @param [String] string
  # @param [Integer] start
  # @param [Integer] stop Stop index, excluded from the range.
  def ansi_print(string, start, stop)
    i = 0
    new_str = ""
    string.split(Code).each do |str|
      if start_with_ansi_code? str
        new_str << str
      else
        if i >= start
          new_str << str[0..(stop - i - 1)]
        elsif i < start && i + str.size >= start
          new_str << str[(start - i), stop - start - 1]
        end

        i += str.size
        break if i >= stop
      end
    end
    new_str
  end
end
class Coolline
  include CANSI
end

module AresMUSH
  # Too much of a pain to test in isolation, so these are more of integration tests
  # with real Liquid templates.
  describe TemplateFormatters do
    class TestFormatterData
      include TemplateFormatters
    end
    
    before do 
      @data = TestFormatterData.new
    end
    
    describe :right do
      it "should right justify a string" do
        renderer = TemplateRenderer.new("<%= right(\"FOO\", 5) %>")
        renderer.render(@data).should eq "  FOO"
      end
      it "should trim a string that's too long" do
        renderer = TemplateRenderer.new("<%= right(\"FOOBAR\", 5) %>")
        renderer.render(@data).should eq "FOOBA"
      end
    end
  
    describe :left do
      it "should left justify a string" do
        renderer = TemplateRenderer.new("<%= left(\"FOO\", 5) %>")
        renderer.render(@data).should eq "FOO  "
      end
      it "should trim a string that's too long" do
        renderer = TemplateRenderer.new("<%= left(\"FOOBAR\", 5) %>")
        renderer.render(@data).should eq "FOOBA"
      end
    end
  
    describe :center do
      it "should center a string" do
        renderer = TemplateRenderer.new("<%= center(\"FOO\", 5) %>")
        renderer.render(@data).should eq " FOO "
      end
      it "should trim a string that's too long" do
        renderer = TemplateRenderer.new("<%= center(\"FOOBAR\", 5) %>")
        renderer.render(@data).should eq "FOOBA"
      end
    end
    
    describe :line do
      it "should default to line1" do
        renderer = TemplateRenderer.new("FOO <% line %>")
        renderer.render(@data).should eq "FOO %l1"
      end

      it "should accept a line option" do
        renderer = TemplateRenderer.new("FOO <% line(\"ABC\") %>")
        renderer.render(@data).should eq "FOO %lABC"
      end
    end
    
    describe :one_line do
      it "should squish newlines" do
        renderer = TemplateRenderer.new("<% one_line do %>FOO\n\nBAR<% end %>")
        renderer.render(@data).should eq "FOOBAR"
      end

      it "should end with a new line if it had one" do
        renderer = TemplateRenderer.new("<% one_line do %>FOO\n\nBAR<% end %>\n")
        renderer.render(@data).should match /\n$/
        renderer = TemplateRenderer.new("<% one_line do %>FOO\n\nBAR<% end %>")
        renderer.render(@data).should_not match /\n$/
      end
    end
  end
end
