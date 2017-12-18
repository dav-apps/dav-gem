require "test_helper"

class AnalyticsTest < Minitest::Test
   # Log tests
   def test_can_log
      Dav::Event.log($testuser_dev_auth, $testapp["id"], "TestLog")
   end
   
   def test_cant_log_with_too_short_name
      begin
         Dav::Event.log($testuser_dev_auth, $testapp["id"], "a")
         assert false
      rescue StandardError => e
         assert e.message.include? "2203"
      end
   end
   
   def test_cant_log_with_too_long_name
      begin
         Dav::Event.log($testuser_dev_auth, $testapp["id"], "a"*50)
         assert false
      rescue StandardError => e
         assert e.message.include? "2303"
      end
   end
   # End log tests
end