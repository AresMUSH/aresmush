module AresMUSH
  module ExpandedMounts
    def self.mount_name(char)
      char.bonded.name if char.bonded
    end

    def self.expanded_mount_type(char)
      char.bonded.expanded_mount_type if char.bonded
    end

    def self.mount_desc(char)
      char.bonded.description if char.bonded
    end

    def self.mount_shortdesc(char)
      char.bonded.shortdesc if char.bonded
    end

    def self.required_mount_info(chargen_data)
      errors = []
      mount_data = [chargen_data[:custom][:mount_type], chargen_data[:custom][:mount_name],  chargen_data[:custom][:mount_desc], chargen_data[:custom][:mount_shortdesc]]
      if !mount_data.join.blank?
        errors.concat [t('expandedmounts.need_mount_type')] if chargen_data[:custom][:mount_type] == ""
        errors.concat [t('expandedmounts.need_mount_name')] if chargen_data[:custom][:mount_name] == ""
        #Minor school can be set separately from the mount, so is not in mount_data
        errors.concat [t('expandedmounts.need_school')] if chargen_data[:custom][:minor_school]  == "" 
      end

      return errors
    end

    def self.save_mount(char, chargen_data)
      error = ExpandedMounts.required_mount_info(chargen_data)
      puts "ERROR: #{error}"
      return error if !error.empty?

      if char.bonded
        mount = char.bonded
        mount.update(expanded_mount_type: chargen_data[:custom][:mount_type])
        mount.update(name: chargen_data[:custom][:mount_name].titlecase)
        mount.update(description: chargen_data[:custom][:mount_desc])
        mount.update(shortdesc: chargen_data[:custom][:mount_shortdesc])
      else
        mount_data = [chargen_data[:custom][:mount_type], chargen_data[:custom][:mount_name],  chargen_data[:custom][:mount_desc], chargen_data[:custom][:mount_shortdesc]]

        return [t('expandedmounts.already_mount_named')] if (!mount_data.join.blank? && Mount.named(chargen_data[:custom][:mount_name]))

        mount = Mount.create(bonded: char, name: chargen_data[:custom][:mount_name].titlecase, expanded_mount_type: chargen_data[:custom][:mount_type], description: chargen_data[:custom][:mount_desc], shortdesc: chargen_data[:custom][:mount_shortdesc])
        char.update(bonded: mount)
        Global.logger.info "Creating new mount for #{char.name}: Name-#{mount.name} Type-#{mount.expanded_mount_type}"
      end
      return []
    end

  end
end