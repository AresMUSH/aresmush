module AresMUSH
  module ExpandedMounts
    def self.mount_name(char)
      char.bonded.name if char.bonded
    end

    def self.mount_type(char)
      char.bonded.mount_type if char.bonded
    end

    def self.mount_desc(char)
      char.bonded.description if char.bonded
    end

    def self.mount_shortdesc(char)
      char.bonded.shortdesc if char.bonded
    end

    def self.save_mount(char, chargen_data)
      if char.bonded
        mount = char.bonded
        mount.update(mount_type: chargen_data[:custom][:mount_type])
        mount.update(name: chargen_data[:custom][:mount_name])
        mount.update(description: chargen_data[:custom][:mount_desc])
        mount.update(shortdesc: chargen_data[:custom][:mount_shortdesc])
      else
        return [t('expandedmounts.already_mount_named')] if Mount.named(chargen_data[:custom][:mount_name])

        mount = Mount.create(bonded: char, name: chargen_data[:custom][:mount_name], mount_type: chargen_data[:custom][:mount_type], description: chargen_data[:custom][:mount_desc], shortdesc: chargen_data[:custom][:mount_shortdesc])
        char.update(bonded: mount)
        puts "creating new moutn"
      end
      return []
    end

  end
end