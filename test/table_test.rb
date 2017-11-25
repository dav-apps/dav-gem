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
   def test_can_create_update_get_and_delete_table
      testtable_name = "TestTable125"
      testtable_new_name = "NewTestTable124"
      
      testtable = Dav::Table.create(@user.jwt, testtable_name, @testapp_id)
      assert_equal(testtable_name, testtable.name)
      
      testtable.update(@user.jwt, {"name" => testtable_new_name})
      assert_equal(testtable_new_name, testtable.name)
      
      table = Dav::Table.get(@user.jwt, @testapp_id, testtable.name)
      assert_same(testtable.id, table.id)
      assert_equal(testtable_new_name, table.name)
      
      table.delete(@user.jwt)
   end
   
   def test_cant_create_table_for_app_of_another_dev
      begin
         testtable = Dav::Table.create(@user.jwt, "TestTable142", 2)
         assert false
      rescue StandardError => e
         assert e.message.include? "1102"
      end
   end
   
   def test_cant_create_table_with_too_long_name
      begin
         testtable = Dav::Table.create(@user.jwt, "T"*30, @testapp_id)
         assert false
      rescue StandardError => e
         assert e.message.include? "2305"
      end
   end
   
   def test_cant_create_table_with_too_short_name
      begin
         testtable = Dav::Table.create(@user.jwt, "T", @testapp_id)
         assert false
      rescue StandardError => e
         assert e.message.include? "2205"
      end
   end
   # End create tests
   
   # Get table tests
   def test_can_get_table_of_the_app_of_another_dev_from_the_website
      testtable_name = "tablename"
      testapp_id = 2
      
      testtable = Dav::Table.get(@user.jwt, testapp_id, testtable_name)
      assert_equal(testtable_name, testtable.name)
   end
   # End get table tests
end