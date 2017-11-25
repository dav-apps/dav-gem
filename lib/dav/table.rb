module Dav
   class Table
      attr_accessor :id, :app_id, :name
      
      def initialize(attributes)
         @id = attributes["id"]
         @app_id = attributes["app_id"]
         @name = attributes["name"]
         @entries = attributes["entries"]
      end
      
      def self.create(jwt, table_name, app_id)
         url = Dav::API_URL + "apps/table?table_name=#{table_name}&app_id=#{app_id}"
         result = send_http_request(url, "POST", {"Authorization" => jwt}, nil)
         if result["code"] == 201
            Table.new(JSON.parse result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def self.get(jwt, app_id, table_name)
         url = Dav::API_URL + "apps/table?app_id=#{app_id}&table_name=#{table_name}"
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            Table.new(JSON.parse result["body"])
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def update(jwt, properties)
         url = Dav::API_URL + "apps/table/#{@id}"
         result = send_http_request(url, "PUT", {"Authorization" => jwt, "Content-Type" => "application/json"}, properties)
         if result["code"] == 200
            # Update local objects
            @name = properties["name"]
            @entries = properties["entries"]
         else
            raise_error(JSON.parse result["body"])
         end
      end
      
      def delete(jwt)
         url = Dav::API_URL + "apps/table/#{@id}"
         result = send_http_request(url, "DELETE", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            result["body"]
         else
            raise_error(JSON.parse result["body"])
         end
      end
   end
end