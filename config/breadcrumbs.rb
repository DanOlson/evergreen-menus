crumb :root do
  if user_signed_in?
    link 'Home', after_sign_in_path_for(current_user)
  end
end

crumb :account do |account|
  if account.persisted?
    link account.name, account_path(account)
  else
    link 'New Account'
  end
end

crumb :establishment do |account, establishment|
  if establishment.persisted?
    link establishment.name, edit_account_establishment_path(account, establishment)
  else
    link 'New Establishment'
  end
  parent :account, account
end

crumb :list do |account, establishment, list|
  if list.persisted?
    link list.name, edit_account_establishment_list_path(account, establishment, list)
  else
    link 'New List'
  end
  parent :establishment, account, establishment
end

crumb :menu do |account, establishment, menu|
  if menu.persisted?
    path = edit_account_establishment_menu_path(account, establishment, menu)
    link menu.name, path
  else
    link 'New Menu'
  end
  parent :establishment, account, establishment
end

crumb :web_menu do |account, establishment, web_menu|
  if web_menu.persisted?
    path = edit_account_establishment_web_menu_path(account, establishment, web_menu)
    link web_menu.name, path
  else
    link 'New Web Menu'
  end
  parent :establishment, account, establishment
end

crumb :google_menu do |account, establishment, google_menu|
  path = edit_account_establishment_google_menu_path(account, establishment, google_menu)
  link 'Google Menu', path
  parent :establishment, account, establishment
end

crumb :digital_display_menu do |account, establishment, digital_display_menu|
  if digital_display_menu.persisted?
    path = edit_account_establishment_digital_display_menu_path(
            account,
            establishment,
            digital_display_menu
          )
    link digital_display_menu.name, path
  else
    link 'New Digital Display'
  end
  parent :establishment, account, establishment
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
