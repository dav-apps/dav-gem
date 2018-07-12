require "test_helper"

class EventTest < Minitest::Test
	# Log tests
   def test_can_log
      begin
         Dav::Event.log($testuser_dev["api_key"], $testapp["id"], "TestLog", "testdata")
         assert true
      rescue StandardError => e
         assert false
      end
   end
   
   def test_cant_log_with_too_short_name
      begin
         Dav::Event.log($testuser_dev["api_key"], $testapp["id"], "a", nil)
         assert false
      rescue StandardError => e
         assert e.message.include? "2203"
      end
   end
   
   def test_cant_log_with_too_long_name
      begin
         Dav::Event.log($testuser_dev["api_key"], $testapp["id"], "a"*50, nil)
         assert false
      rescue StandardError => e
         assert e.message.include? "2303"
      end
   end

   def test_cant_log_with_too_long_data
      begin
         Dav::Event.log($testuser_dev["api_key"], $testapp["id"], "TestLog", 'n'*65100)
         assert false
      rescue StandardError => e
         assert e.message.include? "2308"
      end
   end
   # End log tests
end