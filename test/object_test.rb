require "test_helper"

class TableTest < Minitest::Test
   
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
   def test_can_create_update_get_and_delete_object
      page1 = "Hello World"
      page2 = "Hallo Welt"
      new_page1 = "Geaendert page1"
      page3 = "Hello Test"
      
      obj = Dav::Object.create(@testdevuser.jwt, @cards_table_name, @cards_id, {"page1" => page1, "page2" => page2})
      assert_equal(page1, obj.properties["page1"])
      assert_equal(page2, obj.properties["page2"])
      
      obj.update(@testdevuser.jwt, {"page1" => new_page1, "test" => page3})
      assert_equal(new_page1, obj.properties["page1"])
      assert_equal(page3, obj.properties["test"])
      
      object = Dav::Object.get(@testdevuser.jwt, obj.id)
      assert_same(object.id, obj.id)
      
      obj.delete(@testdevuser.jwt)
   end
   
   def test_cant_create_object_with_too_long_property_value
      begin
         obj = Dav::Object.create(@testdevuser.jwt, @cards_table_name, @cards_id, {"property" => "hallo"*500})
         assert false
      rescue StandardError => e
         assert e.message.include? "2307"
      end
   end
   
   def test_cant_create_object_with_too_long_property_name
      begin
         obj = Dav::Object.create(@testdevuser.jwt, @cards_table_name, @cards_id, {"p"*30 => "hello"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2306"
      end
   end
   # End create tests
   
   # Update object tests
   def test_cant_update_object_with_too_long_property_value
      begin
         obj = Dav::Object.create(@testdevuser.jwt, @cards_table_name, @cards_id, {"property" => "hallo"})
         obj.update(@testdevuser.jwt, {"property" => "hallo"*500})
         assert false
      rescue StandardError => e
         assert e.message.include? "2307"
      end
   end
   
   def test_cant_update_object_with_too_long_property_name
      begin
         obj = Dav::Object.create(@testdevuser.jwt, @cards_table_name, @cards_id, {"property" => "hello"})
         obj.update(@testdevuser.jwt, {"p"*30 => "hallo"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2306"
      end
   end
   # End update object tests
end