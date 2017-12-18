require "test_helper"

class ObjectTest < Minitest::Test
   # create tests
   def test_can_create_update_get_and_delete_object
      page1 = "Hello World"
      page2 = "Hallo Welt"
      new_page1 = "Geaendert page1"
      page3 = "Hello Test"
      
      obj = Dav::Object.create($normaloXdav.jwt, $card["name"], $cards["id"], {"page1" => page1, "page2" => page2})
      assert_equal(page1, obj.properties["page1"])
      assert_equal(page2, obj.properties["page2"])
      
      obj.update($normaloXdav.jwt, {"page1" => new_page1, "test" => page3})
      assert_equal(new_page1, obj.properties["page1"])
      assert_equal(page3, obj.properties["test"])
      
      object = Dav::Object.get($normaloXdav.jwt, obj.id)
      assert_same(object.id, obj.id)
      
      obj.delete($normaloXdav.jwt)
   end
   
   def test_cant_create_object_with_too_long_property_value
      begin
         obj = Dav::Object.create($normaloXdav.jwt, $card["name"], $cards["id"], {"property" => "hallo"*500})
         assert false
      rescue StandardError => e
         assert e.message.include? "2307"
      end
   end
   
   def test_cant_create_object_with_too_long_property_name
      begin
         obj = Dav::Object.create($normaloXdav.jwt, $card["name"], $cards["id"], {"p"*30 => "hello"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2306"
      end
   end
   # End create tests
   
   # Update object tests
   def test_cant_update_object_with_too_long_property_value
      begin
         obj = Dav::Object.create($normaloXdav.jwt, $card["name"], $cards["id"], {"property" => "hallo"})
         obj.update($normaloXdav.jwt, {"property" => "hallo"*500})
         assert false
      rescue StandardError => e
         assert e.message.include? "2307"
      end
   end
   
   def test_cant_update_object_with_too_long_property_name
      begin
         obj = Dav::Object.create($normaloXdav.jwt, $card["name"], $cards["id"], {"property" => "hello"})
         obj.update($normaloXdav.jwt, {"p"*30 => "hallo"})
         assert false
      rescue StandardError => e
         assert e.message.include? "2306"
      end
   end
   # End update object tests
end