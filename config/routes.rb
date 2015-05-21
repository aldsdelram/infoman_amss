
AMSS::Application.routes.draw do

  get 'schedules/getEvent' => 'schedules#getEvent'
  # get 'update_grade/:id/exam/:exam_id' => 'applicants#update_grade', :as => :update_grade

  put 'update_grade/:id/exam/:exam_id' => 'applicants#update_grade', :as => :update_grade

  post 'assign_grade/:id' => 'applicants#assign_grade', :as => :assign_grade

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  get 'applicants/matched_db_applicants' => 'applicants#matched_db_applicants', :as => 'applicants/verify'

  resources :admins

  resources :schools

  resources :departments

  get 'interviewers/show_all' => 'interviewers#show_all'

  post 'interviewers/show_all' => 'interviewers#show_all'

  get 'schedules/new/:id' => 'schedules#new', :as => 'schedules/new'

  get 'positions/:id/exams/unassign/:exam_id' => 'positions#unassign', :as => :unassign

  get 'positions/:id/exams/assign/:exam_id' => 'positions#assign', :as => :assign

  controller :applicants do
    con = 'applicants/'
    get con+'show_all' => :show_all
    post con+'show_all' => :show_all, :as => 'show_all'
    post con+':id' => :show
    get 'search_applicant' => :search_applicant
    get con+'header_search' => :header_search
    get 'assign_interviewer/:id' => :assign_interviewer, :as => con+'assign_interviewer'
    post 'assign_interviewer/:id' => :assign_interviewer, :as => con+'assign_interviewer'

  	get con+'get_info' => :get_info
  	get con+'get_interviewer' => :get_interviewer
  end

  resources :schedules

  resources :grades

  resources :exams

  resources :interviewers

  resources :positions, :only =>[:index, :create, :update, :destroy, :show]

  resources :applicants



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "home#index", :as => "index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
