OpenAidRegister::Application.routes.draw do

  root :to => "home#show"

  match 'about' => 'about#show'
  match 'conditions' => 'conditions#show'

  match 'signup' => 'signup#signup', :via => :get
  match 'signup' => 'signup#signup_validation', :via => :post

  match 'account' => 'signup#signup', :via => :get
  match 'account' => 'signup#signup_validation', :via => :post
  match 'signup_complete' => 'signup#signup_complete'
  match 'login' => 'signup#login', :via => :get
  match 'login' => 'signup#login_validation', :via => :post
  match 'logout' => 'signup#logout'
  match 'forgot_password' => 'signup#forgot_password'
  match 'password_reset' => 'signup#password_reset'

  match 'dashboard' => 'dashboard#show', :via => :get
  match 'import_file' => 'dashboard#import_file'
  match 'delete' => 'dashboard#delete'
  match 'publish' => 'dashboard#publish'
  match 'gather_publish_data' => 'dashboard#gather_publish_data', :via => :post

  match 'browser_not_supported' => 'help#browser_not_supported'

  # this route is deprecated and will be removed in the future
  # use /organizations/:id/projects.xml instead
  match 'download/:id' => 'organizations#projects', :via => :get

  resources :organizations do
    get "projects", :on => :member
  end

  resources :projects

end
