require "test_helper"

class DavTest < Minitest::Test
   
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
   
   # get tests
   
   def test_can_get_own_user
      user = Dav::User.get(@user.jwt, @user.id)
      assert_equal(user.username, @user.username)
      assert_equal(user.email, @user.email)
      assert_equal(user.id, @user.id)
   end
   
   def test_cant_get_another_user
      begin
         user = Dav::User.get(@user.jwt, @user.id+1)
         assert false
      rescue StandardError => e
         assert e.message.include? "1102"
      end
   end
   
   # End get tests
   
   # Update tests
   
   def test_can_update_the_user
      new_email = "newtest@example.com"
      @user.update({"email": new_email})
      assert_equal(new_email, @user.new_email)
      
      @user.update({"email": @testuser_email})
      assert_equal(@user.new_email, @testuser_email)
      
      @user.update({"avatar_file_extension": ".jpg"})
      assert_equal(".jpg", @user.avatar_file_extension)
   end
   
   def test_cant_update_user_with_invalid_email
      begin
         @user.update({"email": "1234"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2401"
      end
   end
   
   def test_cant_update_user_with_too_short_username
      begin
         @user.update({"username": "2"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2201"
      end
   end
   
   def test_cant_update_user_with_too_long_username
      begin
         @user.update({"username": "2"*50})
         assert false
      rescue StandardError => e
         assert e.message.include? "2301"
      end
   end
   
   def test_cant_update_user_with_too_short_password
      begin
         @user.update({"password": "1234"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2202"
      end
   end
   
   def test_cant_update_user_with_too_long_password
      begin
         @user.update({"password": "1234"*30})
         assert false
      rescue StandardError => e
         assert e.message.include? "2302"
      end
   end
   # End update tests
end
