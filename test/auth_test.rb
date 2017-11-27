require "test_helper"

class AuthenticationTest < Minitest::Test
   
   def before_setup
      super
      @dev_api_key = "-AFBbtM8968dnAyPWpv4BK2B1zDtt70YwNmGzVWs"
      @dev_secret_key = "11JTmdRyItz4N3rgsZhpLBrTQXRhmHcBw3Zi_aBq3rROawKPH8yaRg"
      @dev_uuid = "fd02c38f-50ec-4a0c-a9af-c9c841ade0e6"
      
      @testuser_id = 2
      @testuser_email = "test@example.com"
      @testuser_password = "password"
      @testuser_username = "testuser"
      
      @testdev_id = 3
      @testdev_email = "testdev@example.com"
      @testdev_password = "password"
      @testdev_username = "testdev"
      
      @testdev_api_key = "gHgHKRbIjdguCM4cv5481hdiF5hZGWZ4x12Ur-7v"
      @testdev_secret_key = "ucvak5gYUdjDbQU-j0q6uXN9y5HBrqFGtjpf_NrVstw4Wdhd5VFvQg"
      @testdev_uuid = "614c2e23-8ffa-4858-be59-621da2ec5c57"
      
      @testdevapp_id = 1
      @testdevapp_name = "TestApp"
      @testdevtable_name = "TestTable"
      @cards_id = 3
      @cards_app_name = "Cards"
      @cards_table_name = "Card"
      
      @auth = Dav::Auth.new(:api_key => @dev_api_key, :secret_key => @dev_secret_key, :uuid => @dev_uuid)
      @testuser = @auth.login(@testuser_email, @testuser_password)
      @testdevuser = @auth.login(@testdev_email, @testdev_password)
   end
   
   def after_teardown
      
      super
   end
   
   # Login tests
   def test_can_login_user
      user = @auth.login(@testuser_email, @testuser_password)
      assert_equal(user.email, @testuser_email)
      assert_equal(user.username, @testuser_username)
      assert_same(user.id, @testuser_id)
   end
   
   def test_trying_logging_in_user_with_incorrect_password_throws_exception
      begin
         user = @auth.login(@testuser_email, "wrongpassword")
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