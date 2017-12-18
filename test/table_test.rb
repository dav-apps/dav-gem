require "test_helper"

class TableTest < Minitest::Test
   # create tests
   def test_can_create_update_get_and_delete_table
      testtable_name = "TestTable125"
      testtable_new_name = "NewTestTable124"
      
      testtable = Dav::Table.create($testuserXdav.jwt, testtable_name, $testapp["id"])
      assert_equal(testtable_name, testtable.name)
      
      testtable.update($testuserXdav.jwt, {"name" => testtable_new_name})
      assert_equal(testtable_new_name, testtable.name)
      
      table = Dav::Table.get($testuserXdav.jwt, $testapp["id"], testtable.name)
      assert_same(testtable.id, table.id)
      assert_equal(testtable_new_name, table.name)
      
      table.delete($testuserXdav.jwt)
   end
   
   def test_cant_create_table_for_app_of_another_dev
      begin
         testtable = Dav::Table.create($testuserXdav.jwt, "TestTable142", $cards["id"])
         assert false
      rescue StandardError => e
         assert e.message.include? "1102"
      end
   end
   
   def test_cant_create_table_with_too_long_name
      begin
         testtable = Dav::Table.create($testuserXdav.jwt, "T"*40, $testapp["id"])
         assert false
      rescue StandardError => e
         assert e.message.include? "2305"
      end
   end
   
   def test_cant_create_table_with_too_short_name
      begin
         testtable = Dav::Table.create($testuserXdav.jwt, "T", $testapp["id"])
         assert false
      rescue StandardError => e
         assert e.message.include? "2205"
      end
   end
   # End create tests
   
   # Get table tests
   def test_can_get_own_table_from_the_website
      testtable = Dav::Table.get($testuserXdav.jwt, $testapp["id"], $testtable["name"])
      assert_equal($testtable["name"], testtable.name)
   end
   # End get table tests
end