require "test_helper"

class UserTest < Minitest::Test
   
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
   
   # get tests
   def test_can_get_own_user
      user = Dav::User.get(@testdevuser.jwt, @testdevuser.id)
      assert_equal(user.username, @testdevuser.username)
      assert_equal(user.email, @testdevuser.email)
      assert_equal(user.id, @testdevuser.id)
   end
   
   def test_cant_get_another_user
      begin
         user = Dav::User.get(@testdevuser.jwt, @testuser_id)
         assert false
      rescue StandardError => e
         assert e.message.include? "1102"
      end
   end
   
   def test_can_get_apps_of_user
      user = Dav::User.get(@testdevuser.jwt, @testdevuser.id)
      assert_same(3, user.apps[0])
   end
   # End get tests
   
   # Update tests
   def test_can_update_the_user
      new_email = "newtest@example.com"
      @testdevuser.update({"email": new_email})
      assert_equal(new_email, @testdevuser.new_email)
      
      @testdevuser.update({"email": @testdev_email})
      assert_equal(@testuser.new_email, @testuser_email)
      
      @testdevuser.update({"avatar_file_extension": ".jpg"})
      assert_equal(".jpg", @testdevuser.avatar_file_extension)
   end
   
   def test_cant_update_user_with_invalid_email
      begin
         @testdevuser.update({"email": "1234"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2401"
      end
   end
   
   def test_cant_update_user_with_too_short_username
      begin
         @testdevuser.update({"username": "2"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2201"
      end
   end
   
   def test_cant_update_user_with_too_long_username
      begin
         @testdevuser.update({"username": "2"*50})
         assert false
      rescue StandardError => e
         assert e.message.include? "2301"
      end
   end
   
   def test_cant_update_user_with_too_short_password
      begin
         @testdevuser.update({"password": "1234"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2202"
      end
   end
   
   def test_cant_update_user_with_too_long_password
      begin
         @testdevuser.update({"password": "1234"*30})
         assert false
      rescue StandardError => e
         assert e.message.include? "2302"
      end
   end
   # End update tests
   
   #create_dev tests
   def test_can_create_dev_from_user
      dev = @testuser.create_dev
      assert !dev.id.nil?
      
      dev.delete(@testuser.jwt)
   end
   # End create_dev tests
end
