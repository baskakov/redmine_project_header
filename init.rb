Redmine::Plugin.register :redmine_project_header do
  name        'Redmine Project Header'
  author      'Dmitrii Baskakov dmitry@bask.ws'
  description 'Adds X-Project response header with the project name on all Redmine Issues requests'
  version     '1.0.0'
  url         'https://github.com/baskakov/redmine_project_header'
  author_url  'https://github.com/baskakov'

  requires_redmine version_or_higher: '5.0'
end

require_relative 'lib/redmine_project_header/issues_controller_patch'

# ActiveSupport::Reloader.to_prepare runs:
#   - once during boot in production (after all classes are available)
#   - on every code reload in development
# This is the standard Redmine 5.x plugin pattern for monkey-patching controllers.
ActiveSupport::Reloader.to_prepare do
  IssuesController.prepend(RedmineProjectHeader::IssuesControllerPatch) unless
    IssuesController.ancestors.include?(RedmineProjectHeader::IssuesControllerPatch)
end
