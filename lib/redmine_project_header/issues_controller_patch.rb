module RedmineProjectHeader
  # Prepended into IssuesController.
  # Appends an X-Project response header containing the current project's
  # name on every action that resolves a project (index, show, new,
  # create, edit, update, destroy, …).
  module IssuesControllerPatch
    LOGGER_TAG = '[RedmineProjectHeader]'.freeze unless const_defined?(:LOGGER_TAG)

    # Register the after_action callback when this module is prepended.
    def self.prepended(base)
      base.after_action :append_project_header
      Rails.logger.info("#{LOGGER_TAG} IssuesController patched — X-Project header enabled") rescue nil
    end

    private

    def append_project_header
      if @project.present?
        response.set_header('X-Project', @project.name)
        Rails.logger.info("#{LOGGER_TAG} Set X-Project: \"#{@project.name}\" " \
                          "(action: #{action_name}, path: #{request.path})")
      elsif @issue.present? && @issue.project.present?
        response.set_header('X-Project', @issue.project.name)
        Rails.logger.info("#{LOGGER_TAG} Set X-Project: \"#{@issue.project.name}\" via @issue " \
                          "(action: #{action_name}, path: #{request.path})")
      else
        Rails.logger.debug("#{LOGGER_TAG} X-Project skipped — no project in scope " \
                           "(action: #{action_name}, path: #{request.path})")
      end
    end
  end
end

