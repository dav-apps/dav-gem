require "test_helper"

class AppTest < Minitest::Test
   
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
   
   # create tests
   def test_can_create_update_get_and_delete_app
      testapp_name = "TestApp121131"
      testapp_desc = "This is the description of the test app"
      testapp_new_name = "NewTestApp131"
      testapp_new_desc = "New test app description"
      
      testapp = Dav::App.create(@testdevuser.jwt, testapp_name, testapp_desc)
      assert_equal(testapp_name, testapp.name)
      assert_equal(testapp_desc, testapp.description)
      
      testapp.update(@testdevuser.jwt, {"name" => testapp_new_name, "description" => testapp_new_desc})
      assert_equal(testapp_new_name, testapp.name)
      assert_equal(testapp_new_desc, testapp.description)
      
      app = Dav::App.get(@testdevuser.jwt, testapp.id)
      assert_equal(testapp_new_name, app.name)
      assert_equal(testapp_new_desc, app.description)
      
      testapp.delete(@testdevuser.jwt)
   end
   
   def test_cant_create_app_with_too_long_name
      begin
         Dav::App.create(@testdevuser.jwt, "n"*30, "Hello World!")
         assert false
      rescue StandardError => e
         assert e.message.include? "2303"
      end
   end
   
   def test_cant_create_app_with_too_short_name
      begin
         Dav::App.create(@testdevuser.jwt, "n", "Hello World!")
         assert false
      rescue StandardError => e
         assert e.message.include? "2203"
      end
   end
   
   def test_cant_create_app_with_too_long_description
      begin
         Dav::App.create(@testdevuser.jwt, "TestApp12131", "hello"*50)
         assert false
      rescue StandardError => e
         assert e.message.include? "2304"
      end
   end
   
   def test_cant_create_app_with_too_short_description
      begin
         Dav::App.create(@testdevuser.jwt, "TestApp12131", "H")
         assert false
      rescue StandardError => e
         assert e.message.include? "2204"
      end
   end
   # End create tests
   
   # Get tests
   def test_can_get_app
      testapp = Dav::App.get(@testdevuser.jwt, @testdevapp_id)
      assert_same(@testdevapp_id, testapp.id)
   end
   
   def test_cant_get_app_that_user_does_not_own
      begin
         testapp = Dav::App.get(@testdevuser.jwt, 3)
         assert false
      rescue StandardError => e
         assert e.message.include? "1102"
      end
   end
   # End get tests
   
   # Log event tests
   def test_can_log_event
      testapp = Dav::App.get(@testdevuser.jwt, @testdevapp_id)
      testapp.log_event(@auth, "TestEvent")
   end
   # End log event tests
end