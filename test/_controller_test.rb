require File.dirname(__FILE__) + '/init'

class TestController < ActionController::Base
	before_filter :authentication_required, :only => :login_required
	
	def login_required
		render :text => 'test'
	end
	
	def login_not_required
		render :text => 'test'
	end
	
	def rescue_action(e)
		raise e
	end
end

ActionController::Routing::Routes.append do |map|
	map.connect 'login_required', :controller => 'test', :action => 'login_required'
	map.connect 'login_not_required', :controller => 'test', :action => 'login_not_required'
end

class ControllerTest < Test::Unit::TestCase
	
	def setup
    create_users_table
		@user = create_user

		@controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

		@controller.instance_variable_set('@_session', @request.session)
  end
  
  def teardown
    drop_all_tables
  end

	def test_logged_in?
		assert !@controller.send(:logged_in?)
		
		@controller.send :login, @user
		assert @controller.send(:logged_in?)
		
		@controller.send :logout
		assert !@controller.send(:logged_in?)
	end
	
	def test_logged_in_yields_block_on_true
		assert_equal nil, @controller.send(:logged_in?) { 'some_value' }
		
		@controller.send :login, @user
		assert_equal 'some_value', @controller.send(:logged_in?) { 'some_value' }
	end
	
	def test_current_user
		assert_nil @controller.send(:current_user)
		
		@controller.send :login, @user
		assert_equal @user, @controller.send(:current_user)
		
		@controller.send :logout
		assert_nil @controller.send(:current_user)
	end

	def test_should_require_login
		get :login_required
		assert_response :redirect
		assert flash.has_key?(:error)
		assert_equal @controller.unauthenticated_message, flash[:error]
		assert_redirected_to '/'
	end
	
	def test_should_not_require_login
		get :login_not_required
		assert_response :success
	end
	
	def test_should_login_and_get_authentication_required
		@controller.send :login, @user
		get :login_required
		assert_response :success
	end
	
	def test_find_current_user_with_valid_user
		@request.session[:user_id] = @user.id
		assert_equal @user, @controller.send(:find_current_user)
	end
	
	def test_find_current_user_with_nil_user
		assert_nil @controller.send(:find_current_user)
	end
	
	def test_find_current_user_with_invalid_user
		@request.session[:user_id] = 2
		assert_nil @controller.send(:find_current_user)
	end
	
	def test_find_current_user_force_query
		assert_nil @controller.send(:find_current_user)
		
		@request.session[:user_id] = @user.id
		assert_nil @controller.send(:find_current_user)
		assert_equal @user, @controller.send(:find_current_user, true)
	end
	
	def test_unauthenticated_sets_return_to_session_variable
		get :login_required
		assert_equal @controller.session[:return_to], '/login_required'
	end
	
end