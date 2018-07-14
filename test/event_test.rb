require "test_helper"

class EventTest < Minitest::Test
	# Log tests
   def test_can_log
      begin
         Dav::Event.log($testuser_dev["api_key"], $testapp["id"], "TestLog", {"test" => "bla"}, true)
         assert true
      rescue StandardError => e
         assert false
      end
   end
   
   def test_cant_log_with_too_short_name
      begin
         Dav::Event.log($testuser_dev["api_key"], $testapp["id"], "a", {}, false)
         assert false
      rescue StandardError => e
         assert e.message.include? "2203"
      end
   end
   
   def test_cant_log_with_too_long_name
      begin
         Dav::Event.log($testuser_dev["api_key"], $testapp["id"], "a"*50, {}, false)
         assert false
      rescue StandardError => e
         assert e.message.include? "2303"
      end
   end

   def test_cant_log_with_too_long_property_name
      begin
         Dav::Event.log($testuser_dev["api_key"], $testapp["id"], "TestLog", {"n"*65100 => "test"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2306"
      end
   end

   def test_cant_log_with_too_long_property_value
      begin
         Dav::Event.log($testuser_dev["api_key"], $testapp["id"], "TestLog", {"name" => "t"*65100})
         assert false
      rescue StandardError => e
         assert e.message.include? "2307"
      end
   end
   # End log tests
end