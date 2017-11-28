module Dav
   class Object
      attr_reader :id, :table_id, :user_id, :visibility, :properties
      
      def initialize(attributes)
         @id = attributes["id"]
         @table_id = attributes["table_id"]
         @user_id = attributes["user_id"]
         @visibility = attributes["visibility"]
         @properties = attributes["properties"]
      end
      
      def self.create(jwt, table_name, app_id, properties)
         url = $api_url + "apps/object?table_name=" + table_name + "&app_id=" + app_id.to_s
         result = send_http_request(url, "POST", {"Authorization" => jwt, "Content-Type" => "application/json"}, properties)
         if result["code"] == 201
            Object.new(JSON.parse(result["body"]))
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def self.get(jwt, object_id)
         url = $api_url + "apps/object/#{object_id.to_s}"
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            Object.new(JSON.parse(result["body"]))
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def update(jwt, properties)
         url = $api_url + "apps/object/#{@id}"
         result = send_http_request(url, "PUT", {"Authorization" => jwt, "Content-Type" => "application/json"}, properties)
         if result["code"] == 200
            # Update local object
            @properties = properties
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def delete(jwt)
         url = $api_url + "apps/object/#{@id}"
         result = send_http_request(url, "DELETE", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end
   end
end