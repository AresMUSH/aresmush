require 'byebug'
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

    def self.required_mount_info(char, chargen_data)
      errors = []
      mount_data = [chargen_data[:custom][:mount_type], chargen_data[:custom][:mount_name],  chargen_data[:custom][:mount_desc], chargen_data[:custom][:mount_shortdesc]]
      if !mount_data.join.blank?
        errors.concat [t('expandedmounts.need_mount_type')] if chargen_data[:custom][:mount_type] == ""
        errors.concat [t('expandedmounts.need_mount_name')] if chargen_data[:custom][:mount_name] == ""
        mount =  Mount.named(chargen_data[:custom][:mount_name])
        errors.concat [t('expandedmounts.already_mount_named')] if mount && mount.bonded != char
        #Minor school can be set separately from the mount, so is not in mount_data
        errors.concat [t('expandedmounts.need_school')] if chargen_data[:custom][:minor_school]  == ""
      end

      return errors
    end

    def self.save_cg_mount(char, chargen_data)
      error = ExpandedMounts.required_mount_info(char, chargen_data)
      return error if !error.empty?

      mount_data = [chargen_data[:custom][:mount_type], chargen_data[:custom][:mount_name],  chargen_data[:custom][:mount_desc], chargen_data[:custom][:mount_shortdesc], chargen_data[:custom][:mount_gender]]
      return [] if mount_data.join.blank?

      if char.bonded
        mount = char.bonded
        mount.update(expanded_mount_type: chargen_data[:custom][:mount_type])
        mount.update(name: chargen_data[:custom][:mount_name].titlecase)
        mount.update(description: chargen_data[:custom][:mount_desc])
        mount.update(shortdesc: chargen_data[:custom][:mount_shortdesc])
        mount.update(gender: chargen_data[:custom][:mount_gender])
      else
        mount = Mount.create(bonded: char, name: chargen_data[:custom][:mount_name].titlecase, expanded_mount_type: chargen_data[:custom][:mount_type], description: chargen_data[:custom][:mount_desc], shortdesc: chargen_data[:custom][:mount_shortdesc], gender: chargen_data[:custom][:mount_gender])
        char.update(bonded: mount)
        Global.logger.info "Creating new mount for #{char.name}: Name-#{mount.name} Type-#{mount.expanded_mount_type}"
      end
      return []
    end

  end
end