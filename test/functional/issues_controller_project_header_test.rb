# Redmine Project Header Plugin — Test Suite
#
# Run from your Redmine root:
#   bundle exec rake redmine:plugins:test NAME=redmine_project_header
#
require File.expand_path('../../../../test/test_helper', __dir__)

class IssuesControllerProjectHeaderTest < Redmine::ControllerTest
  tests IssuesController

  fixtures :projects, :users, :roles, :members, :member_roles,
           :trackers, :projects_trackers, :issue_statuses, :issues,
           :enumerations, :custom_fields, :custom_values, :custom_fields_trackers

  setup do
    @request.session[:user_id] = 2   # jsmith — has browse rights
    @project = Project.find(1)       # ecookbook
  end

  # --- index ----------------------------------------------------------------

  test 'GET index sets X-Project header' do
    get :index, params: { project_id: @project.identifier }
    assert_response :success
    assert_equal @project.name, response.headers['X-Project'],
                 'Expected X-Project header to contain the project name'
  end

  # --- show -----------------------------------------------------------------

  test 'GET show sets X-Project header' do
    issue = Issue.find(1)
    get :show, params: { id: issue.id }
    assert_response :success
    assert_equal issue.project.name, response.headers['X-Project'],
                 'Expected X-Project header to contain the issue project name'
  end

  # --- new ------------------------------------------------------------------

  test 'GET new sets X-Project header' do
    get :new, params: { project_id: @project.identifier }
    assert_response :success
    assert_equal @project.name, response.headers['X-Project']
  end

  # --- no project scope -----------------------------------------------------

  test 'GET index without project does not set X-Project header' do
    get :index
    assert_response :success
    assert_nil response.headers['X-Project'],
               'X-Project header should not be present when no project is scoped'
  end
end

