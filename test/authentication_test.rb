require "test_helper"

class AuthenticationTest < Minitest::Test
   
   def before_setup
      super
      @testuser_email = "test@example.com"
      @testuser_password = "password"
      @testuser_username = "testuser"
      
      @testapp_id = 1
    
      @auth = Dav::Auth.new(:api_key => "T_i8UphbI4V1R8UCNGt8qsbqdkk", :secret_key => "j60BkpIgf0Qe2IwbMHh3_IqLxXYtGcFyaU8TR4KDsrdopUKZwjbOkw", :uuid => "e6799b1c-e87a-4d9d-8238-8bd4b84b25fe", :dev_user_id => "1", :dev_id => "1")
      @user = @auth.login(@testuser_email, @testuser_password)
   end
   
   def after_teardown
      
      super
   end
   
   # Login tests
   def test_can_login_user
      user = @auth.login("test@example.com", "password")
      assert_equal(user.email, "test@example.com")
      assert_equal(user.username, "testuser")
   end
   
   def test_trying_logging_in_user_with_incorrect_password_throws_exception
      begin
         user = @auth.login("test@example.com", "wrongpassword")
         assert false
      rescue StandardError => e
         assert e.message.include? "1201"
      end
   end
   
   # End login tests
   
   # Signup tests
   
   def test_cant_signup_user_with_taken_email
      begin
         user = @auth.signup(@testuser_email, "password", "testtest")
         assert false
      rescue StandardError => e
         assert e.message.include? "2702"
      end
   end
   
   def test_cant_signup_user_with_taken_username
      begin
         user = @auth.signup("test123@example.com", "password", @testuser_username)
         assert false
      rescue StandardError => e
         assert e.message.include? "2701"
      end
   end
   
   # End signup tests
end