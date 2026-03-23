module RedmineProjectHeader
  # Prepended into IssuesController.
  # Appends an X-Project response header containing the current project's
  # identifier on every action that resolves a project (index, show, new,
  # create, edit, update, destroy, …).
  module IssuesControllerPatch
    # Called by every action in IssuesController (via before_action in the
    # base ApplicationController / IssuesController chain) AFTER @project is
    # set.  We hook in at the Rack response level so the header is always
    # written, even when the action redirects or renders an error.
    def set_project_header
      super if defined?(super)

      if @project.present?
        response.set_header('X-Project', @project.name)
      end
    end

    # Ensure our callback runs after the controller has had a chance to
    # populate @project (which happens inside find_optional_project /
    # find_project called by before_action hooks in IssuesController).
    def self.prepended(base)
      # after_action fires once the action has finished but before the
      # response is sent to the client, so @project is already set.
      base.after_action :append_project_header
    end

    private

    def append_project_header
      response.set_header('X-Project', @project.name) if @project.present?
    end
  end
end

