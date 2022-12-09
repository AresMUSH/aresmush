module AresMUSH
  module ExpandedMounts
    class ExpandedMountsListAllTemplate < ErbTemplateRenderer


      attr_accessor :title, :list

      def initialize
        super File.dirname(__FILE__) + "/expanded_mounts_all.erb"
      end

      def mounts
        mounts = []
        Chargen.approved_chars.each do |c|
          mounts.concat [{mount: c.bonded, status: 'PC'}]
          puts "MOUNTS1: #{mounts}"
        end

        Character.all.select { |c| c.idle_state == 'Gone'}.each do |c|
          mounts.concat [{mount: c.bonded, status: 'Gone'}] if c.bonded
        end

        Character.all.select { |c| c.idle_state == 'Dead'}.each do |c|
          mounts.concat [{mount: c.bonded, status: 'Dead'}] if c.bonded
        end

        Character.all.select { |c| c.is_npc == true }.each do |c|
          mounts.concat [{mount: c.bonded, status: 'NPC'}] if c.bonded
        end
        puts "Mounts: #{mounts}"
        mounts.sort_by { |a| a[:mount].name }
        # Mount.all.to_a
      end

      def format_mount(mount)
        "#{mount[:mount].name} (#{mount[:mount].expanded_mount_type})"
      end

      def format_char(mount)
        "#{mount[:mount].bonded.name} (#{mount[:status]})"
      end
    end
  end
end