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
   def test_can_create_update_get_and_delete_table
      testtable_name = "TestTable125"
      testtable_new_name = "NewTestTable124"
      
      testtable = Dav::Table.create(@testdevuser.jwt, testtable_name, @testdevapp_id)
      assert_equal(testtable_name, testtable.name)
      
      testtable.update(@testdevuser.jwt, {"name" => testtable_new_name})
      assert_equal(testtable_new_name, testtable.name)
      
      table = Dav::Table.get(@testdevuser.jwt, @testdevapp_id, testtable.name)
      assert_same(testtable.id, table.id)
      assert_equal(testtable_new_name, table.name)
      
      table.delete(@testdevuser.jwt)
   end
   
   def test_cant_create_table_for_app_of_another_dev
      begin
         testtable = Dav::Table.create(@testdevuser.jwt, "TestTable142", @cards_id)
         assert false
      rescue StandardError => e
         assert e.message.include? "1102"
      end
   end
   
   def test_cant_create_table_with_too_long_name
      begin
         testtable = Dav::Table.create(@testdevuser.jwt, "T"*30, @testdevapp_id)
         assert false
      rescue StandardError => e
         assert e.message.include? "2305"
      end
   end
   
   def test_cant_create_table_with_too_short_name
      begin
         testtable = Dav::Table.create(@testdevuser.jwt, "T", @testdevapp_id)
         assert false
      rescue StandardError => e
         assert e.message.include? "2205"
      end
   end
   # End create tests
   
   # Get table tests
   def test_can_get_own_table_from_the_website
      testtable = Dav::Table.get(@testdevuser.jwt, @testdevapp_id, @testdevtable_name)
      assert_equal(@testdevtable_name, testtable.name)
   end
   # End get table tests
end