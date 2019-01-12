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
        when "all"
          return ListJobsCmd
        when "backup"
          return JobsBackupCmd
        when "cat"
          return ChangeCategoryCmd
        when "catchup"
          return JobsCatchupCmd
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
        when "search"
          return JobSearchCmd
        when "status"
          return JobStatusCmd
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
        when "respond"
          return RequestCommentCmd
        when "all"
          return ListRequestsCmd
        when "create"
          return CreateRequestCmd
        when "mail"
          return RequestMailCmd
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
      nil
    end
    
    def self.get_web_request_handler(request)
      case request.cmd
      when "jobs"
        return JobsRequestHandler
      when "job"
        return JobRequestHandler
      when "jobCreate"
        return JobCreateRequestHandler
      when "jobReply"
        return JobReplyRequestHandler
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
      when "searchJobs"
        return SearchJobsRequestHandler
      end
      nil
    end
  end
end
