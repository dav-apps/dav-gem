module Dav
   class Table
      attr_accessor :id, :app_id, :name
      
      def initialize(attributes)
         @id = attributes["id"]
         @app_id = attributes["app_id"]
         @name = attributes["name"]
      end
      
      def self.create(user, table_name, app_id)
         create_table_url = Dav::API_URL + "apps/table?table_name=" + table_name + "&app_id=" + app_id.to_s
         json = send_http_request(create_table_url, "POST", {"Authorization" => user.jwt}, nil)
         Table.new(json)
      end
      
      def self.get(user, app, table_name)
         url = Dav::API_URL + "apps/table?app_id=" + app.id.to_s + "&table_name=" + table_name
         json = send_http_request(url, "GET", {"Authorization" => user.jwt}, nil)
         Table.new(json)
      end
   end
end