require "test_helper"

class AnalyticsTest < Minitest::Test
   # Log tests
   def test_can_log
      begin
         Dav::Event.log($testuser_dev_auth, $testapp["id"], "TestLog", "testdata")
         assert true
      rescue StandardError => e
         assert false
      end
   end
   
   def test_cant_log_with_too_short_name
      begin
         Dav::Event.log($testuser_dev_auth, $testapp["id"], "a", nil)
         assert false
      rescue StandardError => e
         assert e.message.include? "2203"
      end
   end
   
   def test_cant_log_with_too_long_name
      begin
         Dav::Event.log($testuser_dev_auth, $testapp["id"], "a"*50, nil)
         assert false
      rescue StandardError => e
         assert e.message.include? "2303"
      end
   end

   def test_cant_log_with_too_long_data
      begin
         Dav::Event.log($testuser_dev_auth, $testapp["id"], "TestLog", 'n'*251)
         assert false
      rescue StandardError => e
         assert e.message.include? "2308"
      end
   end
   # End log tests

   def test_can_create_get_update_and_delete_event
      begin
         event_name = "TestLog"
         new_event_name = "TestLog2"

         Dav::Event.log($testuser_dev_auth, $testapp["id"], event_name, "testdata")
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