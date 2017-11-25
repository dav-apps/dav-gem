require "test_helper"

class AnalyticsTest < Minitest::Test
   
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
   
   # Log tests
   
   def test_can_log
      Dav::Event.log(@auth, @testapp_id, "TestLog")
   end
   
   def test_cant_log_with_too_short_name
      begin
         Dav::Event.log(@auth, @testapp_id, "a")
         assert false
      rescue StandardError => e
         assert e.message.include? "2203"
      end
   end
   
   def test_cant_log_with_too_long_name
      begin
         Dav::Event.log(@auth, @testapp_id, "a"*50)
         assert false
      rescue StandardError => e
         assert e.message.include? "2303"
      end
   end
   
   # End log tests
end