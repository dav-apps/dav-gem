require "test_helper"

class AppTest < Minitest::Test
   
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
   
   # create tests
   def test_can_create_update_get_and_delete_app
      testapp_name = "TestApp121131"
      testapp_desc = "This is the description of the test app"
      testapp_new_name = "NewTestApp131"
      testapp_new_desc = "New test app description"
      
      testapp = Dav::App.create(@user.jwt, testapp_name, testapp_desc)
      assert_equal(testapp_name, testapp.name)
      assert_equal(testapp_desc, testapp.description)
      
      testapp.update(@user.jwt, {"name" => testapp_new_name, "description" => testapp_new_desc})
      assert_equal(testapp_new_name, testapp.name)
      assert_equal(testapp_new_desc, testapp.description)
      
      app = Dav::App.get(@user.jwt, testapp.id)
      assert_equal(testapp_new_name, app.name)
      assert_equal(testapp_new_desc, app.description)
      
      testapp.delete(@user.jwt)
   end
   
   def test_cant_create_app_with_too_long_name
      begin
         Dav::App.create(@user.jwt, "n"*30, "Hello World!")
         assert false
      rescue StandardError => e
         assert e.message.include? "2303"
      end
   end
   
   def test_cant_create_app_with_too_short_name
      begin
         Dav::App.create(@user.jwt, "n", "Hello World!")
         assert false
      rescue StandardError => e
         assert e.message.include? "2203"
      end
   end
   
   def test_cant_create_app_with_too_long_description
      begin
         Dav::App.create(@user.jwt, "TestApp12131", "hello"*50)
         assert false
      rescue StandardError => e
         assert e.message.include? "2304"
      end
   end
   
   def test_cant_create_app_with_too_short_description
      begin
         Dav::App.create(@user.jwt, "TestApp12131", "H")
         assert false
      rescue StandardError => e
         assert e.message.include? "2204"
      end
   end
   # End create tests
   
   # Get tests
   def test_can_get_app
      testapp = Dav::App.get(@user.jwt, @testapp_id)
      assert_same(@testapp_id, testapp.id)
   end
   
   def test_cant_get_app_that_user_does_not_own
      begin
         testapp = Dav::App.get(@user.jwt, 2)
         assert false
      rescue StandardError => e
         assert e.message.include? "1102"
      end
   end
   # End get tests
   
   # Log event tests
   def test_can_log_event
      testapp = Dav::App.get(@user.jwt, @testapp_id)
      testapp.log_event(@auth, "TestEvent")
   end
   # End log event tests
end