require "test_helper"

class AnalyticsTest < Minitest::Test
   def test_can_create_get_update_and_delete_event
      begin
         event_name = "TestLog"
         new_event_name = "TestLog2"

         Dav::Event.log($testuser_dev["api_key"], $testapp["id"], event_name, "testdata")
         event = Dav::Event.get_by_name($testuserXdav.jwt, event_name, $testapp["id"])
         assert_equal(event_name, event.name)
         
         event.update($testuserXdav.jwt, new_event_name)
         assert_equal(new_event_name, event.name)

         event.delete($testuserXdav.jwt)
         assert true
      rescue StandardError => e
         assert false
      end
   end
end