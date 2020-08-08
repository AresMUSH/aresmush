$:.unshift File.dirname(__FILE__)

# Must be loaded before other job commands


module AresMUSH
  module Jobs
    def self.plugin_dir
      File.dirname(__FILE__)
    end
 
    def self.shortcuts
      Global.read_config("jobs", "shortcuts")
    end
 
    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "job"
        case cmd.switch
        when "addparticipant", "removeparticipant"
          return JobChangeParticipantCmd
        when "all"
          return ListJobsCmd
        when "backup"
          return JobsBackupCmd
        when "cat"
          return ChangeCategoryCmd
        when "categories"
          return ListJobCaegoriesCmd
        when "categorycolor"
          return JobCategoryColorCmd
        when "categorytemplate"
          return JobCategoryTemplateCmd
        when "categoryroles"
          return JobCategoryRolesCmd
        when "createcategory"
          return CreateJobCategoryCmd
        when "catchup"
          return JobsCatchupCmd
        when "deletecategory"
          return DeleteJobCategoryCmd
        when "discuss", "respond"
          return JobCommentCmd
        when "close"
          return CloseJobCmd
        when "confirmpurge"
          return PurgeJobsConfirmCmd
        when "create"
          return CreateJobCmd
        when "delete"
          return DeleteJobCmd
        when "deletereply"
          return JobDeleteReplyCmd
        when "handle", "assign"
          return HandleJobCmd
        when "filter"
          return JobsFilterCmd
        when "mail"
          return JobMailCmd
        when "new"
          return JobsNewCmd
        when "purge"
          return PurgeJobsCmd
        when "query"
          return CreateQueryJobCmd
        when "renamecategory"
          return RenameJobCategoryCmd
        when "scan"
          return JobScanCmd
        when "search"
          return JobSearchCmd
        when "status"
          return JobStatusCmd
        when "subscribe", "unsubscribe"
          return JobsSubscribeCmd
        when "title"
          return ChangeTitleCmd
        when "unread"
          return JobUnreadCmd
        when nil
          if (cmd.args)
            return ViewJobCmd
          else
            return ListJobsCmd
          end
        end
         
      when "request"
        case cmd.switch
        when "addparticipant", "removeparticipant"
          return JobChangeParticipantCmd
        when "all"
          return ListRequestsCmd
        when "respond"
          return RequestCommentCmd
        when "filter"
          return RequestFilterCmd
        when "create"
          return CreateRequestCmd
        when "mail"
          return RequestMailCmd
        when "new"
          return RequestNewCmd
        when nil
          if (!cmd.args)
            return ListRequestsCmd
          elsif (cmd.args =~ /\=/)
            return CreateRequestCmd
          else
            return ViewRequestCmd
          end
        end
      end
       
      nil
    end

    def self.get_event_handler(event_name) 
      case event_name
      when "CronEvent"
        return JobArchiveCronHandler
      when "RoleDeletedEvent"
        return RoleDeletedEventHandler
      else
        return nil
      end
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "jobs"
        return JobsRequestHandler
      when "job"
        return JobRequestHandler
      when "jobChangeParticipants"
        return JobChangeParticipantsRequestHandler
      when "jobCreate"
        return JobCreateRequestHandler
      when "jobReply"
        return JobReplyRequestHandler
      when "jobCategoryCreate"
        return CreateJobCategoryRequestHandler
      when "jobCategoryDelete"
        return DeleteJobCategoryRequestHandler
      when "jobCategoryEdit"
        return EditJobCategoryRequestHandler
      when "jobCategorySave"
        return SaveJobCategoryRequestHandler
      when "jobCategoriesManage"
        return ManageJobCategoriesRequestHandler
      when "jobClose"
        return JobCloseRequestHandler
      when "jobDeleteReply"
        return JobDeleteReplyRequestHandler
      when "jobAssign"
        return JobAssignRequestHandler
      when "jobsFilter"
        return JobsFilterRequestHandler
      when "jobChangeData"
        return JobChangeDataRequestHandler
      when "jobOptions"
        return JobOptionsRequestHandler
      when "jobsCatchup"
        return JobsCatchupRequestHandler
      when "searchJobs"
        return SearchJobsRequestHandler
      end
      nil
    end
    
    def self.check_config
      validator = JobsConfigValidator.new
      validator.validate
    end
  end
end
