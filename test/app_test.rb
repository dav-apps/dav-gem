require "test_helper"

class AppTest < Minitest::Test
   # create tests
   def test_can_create_update_get_and_delete_app
      testapp_name = "TestApp121131"
      testapp_desc = "This is the description of the test app"
      testapp_new_name = "NewTestApp131"
      testapp_new_desc = "New test app description"
      
      testapp = Dav::App.create($testuserXdav.jwt, testapp_name, testapp_desc)
      assert_equal(testapp_name, testapp.name)
      assert_equal(testapp_desc, testapp.description)
      
      testapp.update($testuserXdav.jwt, {"name" => testapp_new_name, "description" => testapp_new_desc})
      assert_equal(testapp_new_name, testapp.name)
      assert_equal(testapp_new_desc, testapp.description)
      
      app = Dav::App.get($testuserXdav.jwt, testapp.id)
      assert_equal(testapp_new_name, app.name)
      assert_equal(testapp_new_desc, app.description)
      
      testapp.delete($testuserXdav.jwt)
   end
   
   def test_cant_create_app_with_too_long_name
      begin
         Dav::App.create($testuserXdav.jwt, "n"*55, "Hello World!")
         assert false
      rescue StandardError => e
         assert e.message.include? "2303"
      end
   end
   
   def test_cant_create_app_with_too_short_name
      begin
         Dav::App.create($testuserXdav.jwt, "n", "Hello World!")
         assert false
      rescue StandardError => e
         assert e.message.include? "2203"
      end
   end
   
   def test_cant_create_app_with_too_long_description
      begin
         Dav::App.create($testuserXdav.jwt, "TestApp12131", "h"*510)
         assert false
      rescue StandardError => e
         assert e.message.include? "2304"
      end
   end
   
   def test_cant_create_app_with_too_short_description
      begin
         Dav::App.create($testuserXdav.jwt, "TestApp12131", "H")
         assert false
      rescue StandardError => e
         assert e.message.include? "2204"
      end
   end
   # End create tests
   
   # Get tests
   def test_can_get_app
      begin
         testapp = Dav::App.get($testuserXdav.jwt, $testapp["id"])
         assert true
      rescue StandardError => e
         assert false
      end
   end
   
   def test_cant_get_app_that_user_does_not_own
      begin
         testapp = Dav::App.get($testuserXdav.jwt, $cards["id"])
         assert false
      rescue StandardError => e
         assert e.message.include? "1102"
      end
   end
   # End get tests
   
   # Log event tests
   def test_can_log_event
      testapp = Dav::App.get($testuserXdav.jwt, $testapp["id"])
      testapp.log_event($testuser_dev_auth, "TestEvent")
   end
   # End log event tests
end