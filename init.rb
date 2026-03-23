Redmine::Plugin.register :redmine_project_header do
  name        'Redmine Project Header'
  author      'Dmitrii Baskakov dmitry@bask.ws'
  description 'Adds X-Project response header with the project name on all Redmine Issues requests'
  version     '1.0.0'
  url         'https://github.com/yourname/redmine_project_header'
  author_url  'https://github.com/baskakov'

  requires_redmine version_or_higher: '5.0'
end

# Patch IssuesController to inject the X-Project response header
require_relative 'lib/redmine_project_header/issues_controller_patch'

Rails.configuration.to_prepare do
  unless IssuesController.ancestors.include?(RedmineProjectHeader::IssuesControllerPatch)
    IssuesController.prepend(RedmineProjectHeader::IssuesControllerPatch)
  end
end

