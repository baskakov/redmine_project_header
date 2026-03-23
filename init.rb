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

# Patch IssuesController after Rails has fully initialized and all
# autoloaded constants are available.  In production classes are loaded
# eagerly, so IssuesController is guaranteed to exist at this point.
Rails.application.config.after_initialize do
  puts '[RedmineProjectHeader] after_initialize fired'
  IssuesController.prepend(RedmineProjectHeader::IssuesControllerPatch) unless
    IssuesController.ancestors.include?(RedmineProjectHeader::IssuesControllerPatch)
  puts "[RedmineProjectHeader] IssuesController patched: #{IssuesController.ancestors.include?(RedmineProjectHeader::IssuesControllerPatch)}"
end
