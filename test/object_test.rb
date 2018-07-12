require "test_helper"

class ObjectTest < Minitest::Test
   # create tests
   def test_can_create_update_get_and_delete_object
      page1 = "Hello World"
      page2 = "Hallo Welt"
      new_page1 = "Geaendert page1"
      page3 = "Hello Test"
      
      obj = Dav::Object.create($normaloXdav.jwt, $card["name"], $cards["id"], {"page1" => page1, "page2" => page2}, nil)
      assert_equal(page1, obj.properties["page1"])
      assert_equal(page2, obj.properties["page2"])
      
      obj.update($normaloXdav.jwt, {"page1" => new_page1, "test" => page3}, nil)
      assert_equal(new_page1, obj.properties["page1"])
      assert_equal(page3, obj.properties["test"])
      
      object = Dav::Object.get($normaloXdav.jwt, obj.id, nil)
      assert_same(object.id, obj.id)
      
      obj.delete($normaloXdav.jwt)
   end
   
   def test_cant_create_object_with_too_long_property_value
      begin
         obj = Dav::Object.create($normaloXdav.jwt, $card["name"], $cards["id"], {"property" => "hallo"*65100}, nil)
         assert false
      rescue StandardError => e
         assert e.message.include? "2307"
      end
   end
   
   def test_cant_create_object_with_too_long_property_name
      begin
         obj = Dav::Object.create($normaloXdav.jwt, $card["name"], $cards["id"], {"p"*240 => "hello"}, nil)
         assert false
      rescue StandardError => e
         assert e.message.include? "2306"
      end
   end

   def test_can_create_object_with_file_get_and_delete_it
      begin
         ext = "txt"
         textfile1 = "Hallo Welt! Dies ist eine Textdatei!"
         textfile2 = '{"Test": "test", "test2": "test2"}'

         obj = Dav::Object.create_file($normaloXtestuser.jwt, $testtable["name"], $testapp["id"], textfile1, "text/plain", ext)
         obj2 = Dav::Object.get($normaloXtestuser.jwt, obj.id, nil)
         assert_equal(ext, obj2.properties["ext"])

         obj2.update_file($normaloXtestuser.jwt, textfile2, "application/json", "json", nil)
         assert_equal(textfile2, obj2.file)

         obj.delete($normaloXtestuser.jwt)
      rescue StandardError => e
         assert false
      end
   end
   # End create tests
   
   # Update object tests
   def test_cant_update_object_with_too_long_property_value
      begin
         obj = Dav::Object.create($normaloXdav.jwt, $card["name"], $cards["id"], {"property" => "hallo"}, nil)
         obj.update($normaloXdav.jwt, {"property" => "hallo"*65100}, nil)
         assert false
      rescue StandardError => e
         assert e.message.include? "2307"
         obj.delete($normaloXdav.jwt)
      end
   end
   
   def test_cant_update_object_with_too_long_property_name
      begin
         obj = Dav::Object.create($normaloXdav.jwt, $card["name"], $cards["id"], {"property" => "hello"}, nil)
         obj.update($normaloXdav.jwt, {"p"*240 => "hallo"}, nil)
         assert false
      rescue StandardError => e
         assert e.message.include? "2306"
         obj.delete($normaloXdav.jwt)
      end
   end
   # End update object tests

   def test_can_create_get_add_and_remove_access_token
      begin
         jwt = $normaloXdav.jwt
         obj = Dav::Object.create(jwt, $card["name"], $cards["id"], {"page1": "Hello World", "page2": "Hallo Welt"}, nil)
         token = obj.create_access_token(jwt)
         
         access_tokens = obj.get_access_token(jwt)
         assert_equal(token, access_tokens[0]["token"])

         obj2 = Dav::Object.create(jwt, $card["name"], $cards["id"], {"page1": "Good day", "page2": "Guten Tag"}, nil)
         assert obj2.add_access_token(jwt, token)

         assert obj.remove_access_token(jwt, token)
         assert obj2.remove_access_token(jwt, token)

         obj.delete(jwt)
         obj2.delete(jwt)
      rescue StandardError => e
         assert false
      end
   end
end