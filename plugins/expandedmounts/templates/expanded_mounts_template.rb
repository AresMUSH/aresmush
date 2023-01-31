module AresMUSH
  module ExpandedMounts
    class ExpandedMountsListTemplate < ErbTemplateRenderer


      attr_accessor :title, :list

      def initialize
        super File.dirname(__FILE__) + "/expanded_mounts.erb"
      end

      def mounts
        mounts = []
        Chargen.approved_chars.each do |c|
          mounts.concat [c.bonded] if c.bonded
          puts "MOUNTS: #{mounts}"
        end
        mounts.sort_by { |a| a.name }
        # Mount.all.to_a
      end

      def format_mount(mount)
        "#{mount.name} (#{mount.expanded_mount_type})"
      end
    end
  end
end