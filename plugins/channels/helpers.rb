module AresMUSH
  module Channels
    def self.can_manage_channels?(actor)
      actor && actor.has_permission?("manage_channels")
    end
    
    def self.get_channel_options(char, channel)
      char.channel_options.find(channel_id: channel.id).first
    end
    
    def self.recall_buffer_size
      Global.read_config("channels", "recall_buffer_size") || 500
    end

    def self.is_talk_cmd(enactor, cmd)
      return false if !enactor
      return false if !cmd.args    
      return false if cmd.switch
      channel = Channels.channel_for_alias(enactor, cmd.root)
      channel
    end
    
    def self.find_common_channels(channels, other_char)
      their_channels = Channels.active_channels(other_char)
      intersection = channels.to_a & their_channels.to_a
      intersection = intersection.select { |c| Channels.announce_enabled?(other_char, c) }
      if (intersection.empty?)
        return nil
      end
      intersection = intersection.map { |c| Channels.display_name(other_char, c, false) }
      Channels.name_with_markers(intersection.join(", "))
    end
    
    def self.announce_enabled?(char, channel)
      options = Channels.get_channel_options(char, channel)
      options ? options.announce : false
    end
    
    def self.channel_color(char, channel)
      color = channel.color
      if (char)
        options = Channels.get_channel_options(char, channel)
        if (options && !options.color.blank?)
          color = options.color
        end
      end
      color
    end    
    
    def self.display_name(char, channel, include_markers = true)
      color = Channels.channel_color(char, channel)
      display = "#{color}#{channel.name}%xn"
      include_markers ? Channels.name_with_markers(display) : display
    end
    
    def self.name_with_markers(name)
      start_marker = Global.read_config("channels", "start_marker")
      end_marker = Global.read_config("channels", "end_marker")
      "#{start_marker}#{name}%xn#{end_marker}"
    end
    
    def self.show_titles?(char, channel)
      options = Channels.get_channel_options(char, channel)
      options ? options.show_titles : false
    end
      
    def self.is_muted?(char, channel)
      options = Channels.get_channel_options(char, channel)
      options ? options.muted : false
    end
    
    def self.set_muted(char, channel, mute)
      options = Channels.get_channel_options(char, channel)
      options.update(muted: mute)
    end
    
    def self.channel_who(channel)
      chars = channel.characters.sort_by(:name_upcase, :order => "ALPHA")
      online_chars = []
      chars.each do |c|
        next if !Login.is_online_or_on_web?(c)
        online_chars << c
      end
      online_chars
    end
    
    def self.emit_to_channel(channel, original_msg, enactor = nil, title = nil)
      enactor = enactor || Game.master.system_character
      original_msg = "#{original_msg}".gsub(/%R/i, " ")
      original_msg = "#{original_msg}".gsub(/[\r\n]/i, " ")

      channel.add_to_history "#{title} #{original_msg}", enactor
      channel.characters.each do |c|
        if (!Channels.is_muted?(c, channel))
          
          title_display = (title && Channels.show_titles?(c, channel)) ? "#{title} " : ""
          formatted_msg = "#{Channels.display_name(c, channel)} #{title_display}#{original_msg}"
          
          Login.emit_if_logged_in(c, formatted_msg)
        end
      end
      
      formatted_msg = "#{title} #{original_msg}"
      
      data = {
        id: channel.id,
        key: channel.name.downcase,
        title: channel.name,
        author: {name: enactor.name, icon: Website.icon_for_char(enactor), id: enactor.id},
        message: Website.format_markdown_for_html(formatted_msg),
        is_page: false
      }
      
      Global.client_monitor.notify_web_clients(:new_chat, "#{data.to_json}", true) do |char|
        char && Channels.is_on_channel?(char, channel) && !Channels.is_muted?(char, channel)
      end
    end
    
    def self.pose_to_channel(channel, enactor, msg, title)
      name = enactor.ooc_name
      formatted_msg = PoseFormatter.format(name, msg)
      Channels.emit_to_channel channel, formatted_msg, enactor, title
      Channels.notify_discord_webhook(channel, msg, enactor)
      return formatted_msg
    end
    
    def self.channel_who_status(char, channel)
      web_marker = Login.is_portal_only?(char) ? "%xh%xx#{Website.web_char_marker}%xn" : ""
      mute_marker = Channels.is_muted?(char, channel) ? "%xh%xx#{t('channels.muted')}%xn" : ""
      "#{web_marker}#{mute_marker}"
    end
    
    def self.leave_channel(char, channel)
      Channels.emit_to_channel channel, t('channels.left_channel', :name => char.name)
      channel.characters.delete char
    end
    
    def self.channel_for_alias(char, channel_alias)  
      channel_alias = CommandCracker.strip_prefix(channel_alias).downcase    
      char.channel_options.each do |o|
        if (o.match_alias(channel_alias))
          return o.channel
        end
      end
      
      Channel.all.each do |c|
        if (c.name.downcase == channel_alias.downcase)
          return c
        end
      end
      return nil
    end
    
    def self.can_join_channel?(char, channel)
      return true if channel.join_roles.empty?
      return true if Channels.can_manage_channels?(char)
      return char && char.has_any_role?(channel.join_roles)
    end
    
    def self.can_talk_on_channel?(char, channel)
      return true if channel.talk_roles.empty?
      return true if Channels.can_manage_channels?(char)
      return char && char.has_any_role?(channel.talk_roles)
    end
    
    def self.with_an_enabled_channel(name, client, enactor, &block)
      channel = Channels.channel_for_alias(enactor, name)
      
      if (!channel)
        channel = Channel.find_one_with_partial_match(name)
      end
      
      if (!channel)
        client.emit_failure t('channels.channel_doesnt_exist', :name => name) 
        return
      end

      if (!Channels.is_on_channel?(enactor, channel))
        client.emit_failure t('channels.not_on_channel')
        return
      end
      
      yield channel
    end
    
    def self.with_a_channel(name, client, &block)
      channel = Channel.find_one_with_partial_match(name)
      
      if (!channel)
        client.emit_failure t('channels.channel_doesnt_exist', :name => name) 
        return
      end
      
      yield channel
    end
    
    def self.is_on_channel?(char, channel)
      channel.characters.include?(char)
    end
    
    def self.add_to_channels(client, char, channels)
      channels.each do |name|
        channel = Channel.find_one_with_partial_match(name)
        if (!channel)
          Global.logger.warn "Channel #{name} does not exist."
          next
        end
        
        if (!Channels.is_on_channel?(char, channel))
          aliases = channel.default_alias.map { |a| CommandCracker.strip_prefix(a).downcase }
          options = Channels.get_channel_options(char, channel)
          if (!options)
            ChannelOptions.create(character: char, channel: channel, aliases: aliases)
          end
          channel.characters << char
          Channels.emit_to_channel channel, t('channels.joined_channel', :name => char.name)
        end
      end
    end
    
    def self.cleanup_alias(chan_alias, client, warn)
      if (warn && client && (chan_alias =~ /\d/))
        client.emit_failure t('channels.alias_number_warning')
      end
      
      formatted = CommandCracker.strip_prefix(chan_alias).downcase
      formatted = formatted.gsub(/\d/, '')
      
      formatted
    end
    
    # Client may be nil for web requests
    def self.set_channel_alias(client, char, channel, chan_alias, warn = true)
      aliases = chan_alias.split(/[, ]/).map { |a| Channels.cleanup_alias(a, client, warn) }.uniq
      aliases.each do |a|
        existing_channel = Channels.channel_for_alias(char, a)
        if (existing_channel && existing_channel != channel)
          return t('channels.alias_in_use', :channel_alias => a)
        end
        
        if (warn && client && (!a || a.length < 2))
          client.emit_failure t('channels.short_alias_warning')
        end
        
        if (a.blank?)
          return t('channels.invalid_alias', :a => a)
        end
      end
      
      options = Channels.get_channel_options(char, channel)
      options.update(aliases: aliases)
      
      return nil
    end
    
    def self.join_channel(channel, char, chan_alias = nil)
        if (Channels.is_on_channel?(char, channel))
          return t('channels.already_on_channel')
        end
        
        if (!Channels.can_join_channel?(char, channel))
          return t('channels.cant_use_channel')
        end
        
        if (!chan_alias)
          chan_alias = channel.default_alias.join(",")
        end
        
        options = Channels.get_channel_options(char, channel)
        if (!options)
          ChannelOptions.create(character: char, channel: channel)
        end
            
        error = Channels.set_channel_alias(nil, char, channel, chan_alias, false)
        if (error)
          return t('channels.unable_to_determine_auto_alias')
        end

        channel.characters << char
        Channels.emit_to_channel channel, t('channels.joined_channel', :name => char.name)
        
        return nil
    end
    
    def self.active_channels(char)
      char.channels.select { |c| !Channels.is_muted?(char, c) }
    end
    
    def self.report_channel_abuse(enactor, channel, messages, reason) 
      messages = messages.map { |m| "  [#{OOCTime.local_long_timestr(enactor, m.created_at)}] #{Channels.display_name(nil, channel)} #{m.message}"}.join("%R")

      body = t('channels.channel_reported_body', :name => channel.name, :reporter => enactor.name)
      body << reason
      body << "%R-------%R"
      body << messages

      Jobs.create_job(Jobs.trouble_category, t('channels.channel_reported_title'), body, Game.master.system_character)
    end
    
    def self.notify_discord_webhook(channel, message, enactor)
      name = enactor.ooc_name
      hook = (Global.read_config('secrets', 'discord', 'webhooks') || [])
         .select { |h| (h['mush_channel'] || "").upcase == channel.name_upcase }
         .first

      return if !hook
      
      Global.dispatcher.spawn("Sending discord webhook", nil) do
        url = hook['webhook_url']
        
        formatted_msg = message
        if (message.start_with?(':'))
          formatted_msg = "_#{message.after(':')}_" 
        elsif (message.start_with?(';'))
          formatted_msg = "#{name}#{message.after(';')}"
        end
        formatted_msg = AnsiFormatter.strip_ansi(MushFormatter.format(formatted_msg))

        gravatar_style = Global.read_config('channels', 'discord_gravatar_style') || 'robohash'
        icon = Website.icon_for_char(enactor) 
        icon_url = icon ? "#{Game.web_portal_url}/game/uploads/#{icon}" :
             "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(enactor.name)}?d=#{gravatar_style}"
        connector = RestConnector.new(url)
        connector.post( "", { 
          content: formatted_msg, 
          username: name,
          avatar_url: icon_url } )
      end
    end
    
    def self.build_channel_web_data(channel, enactor)
      {
        key: channel.name.downcase,
        title: channel.name,
        desc: channel.description,
        enabled: Channels.is_on_channel?(enactor, channel),
        can_join: Channels.can_join_channel?(enactor, channel),
        can_talk: Channels.can_talk_on_channel?(enactor, channel),
        muted: Channels.is_muted?(enactor, channel),
        last_activity: channel.last_activity,
        is_recent: channel.last_activity ? (Time.now - channel.last_activity < (86400 * 2)) : false,
        is_page: false,
        who: Channels.channel_who(channel).map { |w| {
         name: w.name,
         ooc_name: w.ooc_name,
         icon: Website.icon_for_char(w),
         muted: Channels.is_muted?(w, channel),
         status: Website.activity_status(w)
        }},
        messages: Channels.is_on_channel?(enactor, channel) ? channel.sorted_channel_messages.map { |m| {
          message: Website.format_markdown_for_html(m.message),
          id: m.id,
          timestamp: OOCTime.local_short_date_and_time(enactor, m.created_at),
          author: {
            name: m.author_name,
            icon: m.author ? Website.icon_for_char(m.author) : nil }
            }} : [],
      }
    end
    
    def self.build_page_web_data(thread, enactor)
      {
         key: thread.id,
         title: thread.title_without_viewer(enactor),
         enabled: true,
         can_join: true,
         can_talk: true,
         muted: false,
         is_page: true,
         is_unread: Page.is_thread_unread?(thread, enactor),
         last_activity: thread.last_activity,
         is_recent: thread.last_activity ? (Time.now - thread.last_activity < (86400 * 2)) : false,
         who: thread.characters.map { |c| {
          name: c.name,
          ooc_name: c.ooc_name,
          icon: Website.icon_for_char(c),
          muted: false
         }},
         messages: thread.sorted_messages.map { |p| {
            message: Website.format_markdown_for_html(p.message),
            id: p.id,
            timestamp: OOCTime.local_short_date_and_time(enactor, p.created_at),
            author: {
              name: p.author_name,
              icon: p.author ? Website.icon_for_char(p.author) : nil }
            }}
        }
    end
                      
  end
end
