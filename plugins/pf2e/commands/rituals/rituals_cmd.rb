module AresMUSH
  module Pf2e
    class RitualsCmd
      include CommandHandler

      attr_accessor :search

      def parse_args
        self.search = cmd.args ? cmd.args.strip : nil
      end

      def handle
        # rituals/info handled via switch; root lists/searches
        results = Pf2e.ritual_search(self.search)
        page = cmd.page || 1
        paginator = Paginator.paginate(results, page, 5)

        if paginator.out_of_bounds?
          client.emit_failure paginator.out_of_bounds_msg
          return
        end

        if results.empty?
          client.emit_ooc t('pf2e.ritual_none')
          return
        end

        lines = []
        title = self.search.to_s.strip.empty? ? t('pf2e.ritual_list_title') : t('pf2e.ritual_search_title', :query => self.search)
        lines << "%xh#{title}%xn (page #{paginator.page_num}/#{paginator.total_pages})"
        paginator.page_items.each do |entry|
          lines << Pf2e.format_ritual_line(entry)
        end
        lines << t('pf2e.ritual_list_hint')
        client.emit lines.join("%r")
      end
    end

    class RitualsInfoCmd
      include CommandHandler

      attr_accessor :slug

      def parse_args
        self.slug = cmd.args.to_s.strip.downcase
      end

      def check_args
        return t('pf2e.ritual_info_usage') if self.slug.blank?
        nil
      end

      def handle
        entry = Pf2e.ritual_entry(self.slug)
        unless entry
          client.emit_failure t('pf2e.ritual_unknown', :ritual => self.slug)
          return
        end
        client.emit Pf2e.format_ritual_detail(entry)
      end
    end

    class RitualsCheckCmd
      include CommandHandler

      attr_accessor :slug, :skill

      def parse_args
        args = cmd.args.to_s.strip
        # rituals/check <slug> [skill]   or  rituals/check <slug>=<skill>
        if args =~ /\A([^=\s]+)\s*=\s*(\S+)\z/
          self.slug = Regexp.last_match(1).downcase
          self.skill = Regexp.last_match(2).downcase
        elsif args =~ /\A(\S+)\s+(\S+)\z/
          self.slug = Regexp.last_match(1).downcase
          self.skill = Regexp.last_match(2).downcase
        else
          self.slug = args.downcase
          self.skill = nil
        end
      end

      def check_args
        return t('pf2e.ritual_check_usage') if self.slug.blank?
        nil
      end

      def handle
        result = Pf2e.ritual_primary_check(enactor, self.slug, skill: self.skill)
        unless result[:ok]
          case result[:error]
          when "pf2e.ritual_skill_ambiguous"
            client.emit_failure t('pf2e.ritual_skill_ambiguous',
                                 :ritual => result[:ritual],
                                 :skills => Array(result[:skills]).join(', '))
          when "pf2e.ritual_skill_not_listed"
            client.emit_failure t('pf2e.ritual_skill_not_listed',
                                 :skill => result[:skill],
                                 :skills => Array(result[:skills]).join(', '))
          when "pf2e.ritual_skill_rank"
            client.emit_failure t('pf2e.ritual_skill_rank',
                                 :skill => result[:skill],
                                 :have => result[:have],
                                 :need => result[:need])
          when "pf2e.ritual_unknown"
            client.emit_failure t('pf2e.ritual_unknown', :ritual => result[:ritual] || self.slug)
          else
            client.emit_failure t(result[:error] || 'pf2e.no_sheet')
          end
          return
        end

        degree = Pf2e.format_degree_label(result[:degree])
        client.emit_success t('pf2e.ritual_check_ok',
                              :name => result[:name],
                              :skill => result[:skill],
                              :total => result[:total],
                              :dc => result[:dc],
                              :degree => degree)

        # Optional scene OOC if in a scene (same pattern as roll)
        if enactor_room && enactor_room.scene
          msg = t('pf2e.ritual_check_scene',
                  :name => enactor.name,
                  :ritual => result[:name],
                  :skill => result[:skill],
                  :total => result[:total],
                  :dc => result[:dc],
                  :degree => degree)
          Scenes.add_to_scene(enactor_room.scene, msg, enactor, nil, true)
        end
      end
    end
  end
end
