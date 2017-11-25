require "test_helper"

class TableTest < Minitest::Test
   
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
   def test_can_create_update_get_and_delete_object
      testtable_name = "tablename"
      testapp_id = 2
      
      page1 = "Hello World"
      page2 = "Hallo Welt"
      new_page1 = "Geaendert page1"
      page3 = "Hello Test"
      
      obj = Dav::Object.create(@user.jwt, testtable_name, testapp_id, {"page1" => page1, "page2" => page2})
      assert_equal(page1, obj.properties["page1"])
      assert_equal(page2, obj.properties["page2"])
      
      obj.update(@user.jwt, {"page1" => new_page1, "test" => page3})
      assert_equal(new_page1, obj.properties["page1"])
      assert_equal(page3, obj.properties["test"])
      
      object = Dav::Object.get(@user.jwt, obj.id)
      assert_same(object.id, obj.id)
      
      obj.delete(@user.jwt)
   end
   
   def test_cant_create_object_with_too_long_property_value
      testtable_name = "tablename"
      testapp_id = 2
      
      begin
         obj = Dav::Object.create(@user.jwt, testtable_name, testapp_id, {"property" => "hallo"*500})
         assert false
      rescue StandardError => e
         assert e.message.include? "2307"
      end
   end
   
   def test_cant_create_object_with_too_long_property_name
      testtable_name = "tablename"
      testapp_id = 2
      
      begin
         obj = Dav::Object.create(@user.jwt, testtable_name, testapp_id, {"p"*30 => "hello"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2306"
      end
   end
   # End create tests
   
   # Update object tests
   def test_cant_update_object_with_too_long_property_value
      testtable_name = "tablename"
      testapp_id = 2
      
      begin
         obj = Dav::Object.create(@user.jwt, testtable_name, testapp_id, {"property" => "hallo"})
         obj.update(@user.jwt, {"property" => "hallo"*500})
         assert false
      rescue StandardError => e
         assert e.message.include? "2307"
      end
   end
   
   def test_cant_update_object_with_too_long_property_name
      testtable_name = "tablename"
      testapp_id = 2
      
      begin
         obj = Dav::Object.create(@user.jwt, testtable_name, testapp_id, {"property" => "hello"})
         obj.update(@user.jwt, {"p"*30 => "hallo"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2306"
      end
   end
   # End update object tests
end