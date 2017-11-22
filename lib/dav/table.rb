module Dav
   class Table
      attr_accessor :id, :app_id, :name
      
      def initialize(attributes)
         @id = attributes["id"]
         @app_id = attributes["app_id"]
         @name = attributes["name"]
      end
      
      def self.create(user, table_name, app_id)
         url = Dav::API_URL + "apps/table?table_name=" + table_name + "&app_id=" + app_id.to_s
         result = send_http_request(url, "POST", {"Authorization" => user.jwt}, nil)
         if result["code"] == 201
            Table.new(JSON.parse result["body"])
         else
            puts "There was an error: "
            puts result["code"]
            puts result["body"]
         end
      end
      
      def self.get(user, app, table_name)
         url = Dav::API_URL + "apps/table?app_id=" + app.id.to_s + "&table_name=" + table_name
         result = send_http_request(url, "GET", {"Authorization" => user.jwt}, nil)
         if result["code"] == 200
            Table.new(JSON.parse result["body"])
         else
            puts "There was an error: "
            puts result["code"]
            puts result["body"]
         end
      end
      
      def update(jwt, table_name)
         url = Dav::API_URL + "apps/table/" + @id.to_s + "?table_name=" + table_name
         result = send_http_request(url, "PUT", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            # Update local objects
            @name = table_name
         else
            puts "There was an error: "
            puts result["code"]
            puts result["body"]
         end
      end
      
      def delete(jwt)
         url = Dav::API_URL + "apps/table/" + @id.to_s
         result = send_http_request(url, "DELETE", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            result["body"]
         else
            puts "There was an error: "
            puts result["code"]
            puts result["body"]
         end
      end
   end
end