module RedmineProjectHeader
  # Prepended into IssuesController.
  # Appends an X-Project response header containing the current project's
  # name on every action that resolves a project (index, show, new,
  # create, edit, update, destroy, …).
  module IssuesControllerPatch

    # Register the after_action callback when this module is prepended.
    def self.prepended(base)
      base.after_action :append_project_header
    end

    private

    def append_project_header
      response.set_header('X-Project', @project.name) if @project.present?
    end
  end
end

