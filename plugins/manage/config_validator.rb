module AresMUSH
  module Manage
    class ConfigValidator
      attr_accessor :config, :errors, :section_name
      def initialize(section_name)
        @config = Global.read_config(section_name)
        @errors = []
        @section_name = section_name
      end
      
      def field_key(field)
        "#{@section_name}:#{field}"
      end
      
      def require_hash(field)
        if !@config[field] || !@config[field].kind_of?(Hash)
          @errors << "#{field_key(field)} is not a hash." 
        end
      end
      
      def require_list(field)
        if !@config[field] || !@config[field].kind_of?(Array)
          @errors << "#{field_key(field)} is not a list/array." 
        end
      end
      
      def require_in_list(field, list)
        value = @config[field]
        if (!value || !list.include?(value))
          @errors << "#{field_key(field)} must be one of: #{list.join(", ")}."
        end
      end
      
      def require_int(field, min = nil, max = nil)
        value = @config[field]
        if (!value || !value.kind_of?(Integer))
          @errors << "#{field_key(field)} is not a whole number."
        else
          if (min && value < min)
            @errors << "#{field_key(field)} must be at least #{min}." 
          end
          if (max && value > max)
            @errors << "#{field_key(field)} must not be more than #{max}." 
          end            
        end
      end
      
      def require_nonblank_text(field)
        value = @config[field]
        if (!value || !value.kind_of?(String) || value.blank?)
          @errors << "#{field_key(field)} must be a non-blank text string." 
        end
      end
      
      def require_text(field)
        value = @config[field]
        if (!value || !value.kind_of?(String))
          @errors << "#{field_key(field)} must be a text string." 
        end
      end
      
      def require_boolean(field)
        if !@config.has_key?(field)
          @errors << "#{field_key(field)} must be true or false (without quotes)." 
        else
          value = @config[field]
          if !(value.kind_of?(FalseClass) || value.kind_of?(TrueClass))
            @errors << "#{field_key(field)} must be true or false (without quotes)." 
          end
        end
      end
      
      def check_cron(field)
        value = @config[field]
        if !value || !value.kind_of?(Hash)
          @errors << "#{field_key(field)} is not a hash." 
          return
        end
        value.each do |k, v|
          if !['day', 'day_of_week', 'hour', 'minute'].include?(k)
            @errors << "#{field_key(field)} - #{k} is not a valid setting."
          end
          if (v.class != Array)
            @errors << "#{field_key(field)} - #{k} is not a list."
          end
        end
      end
      
      def check_channel_exists(field)
        name = @config[field] || ""
        return if name.blank?
        if (!Channel.named(name))
          self.add_error("#{field_key(field)} - #{name} is not a valid channel.")
        end
      end
      
      def check_channels_exist(field)
        names = @config[field] || []
        names.each do |name|
          if (!Channel.named(name))
            self.add_error("#{field_key(field)} - #{name} is not a valid channel.")
          end
        end
      end
      
      def check_forum_exists(field)
        name = @config[field] || ""
        return if name.blank?
        if (!BbsBoard.named(name))
          self.add_error("#{field_key(field)} - #{name} is not a valid forum.")
        end
      end
      
      def check_forums_exist(field)
        names = @config[field] || ""
        names.each do |name|
          if (!BbsBoard.named(name))
            self.add_error("#{field_key(field)} - #{name} is not a valid forum.")
          end
        end
      end
      
      def check_role_exists(field)
        name = @config[field] || ""
        if (!Role.named(name))
          self.add_error("#{field_key(field)} - #{name} is not a valid role.")
        end
      end
      
      def check_roles_exist(field)
        names = @config[field] || ""
        names.each do |name|
          if (!Role.named(name))
            self.add_error("#{field_key(field)} - #{name} is not a valid role.")
          end
        end
      end
      
      def add_error(error)
        @errors << error
      end
    end
  end
end