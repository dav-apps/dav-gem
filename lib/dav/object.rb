module Dav
   class Object
      attr_accessor :id, :table_id, :user_id, :visibility, :properties
      
      def initialize(attributes)
         @id = attributes["id"]
         @table_id = attributes["table_id"]
         @user_id = attributes["user_id"]
         @visibility = attributes["visibility"]
         @properties = attributes["properties"]
      end
      
      def self.create(user, table, app, properties)
         create_object_url = Dav::API_URL + "apps/object?table_name=" + table.name + "&app_id=" + app.id.to_s
         json = send_http_request(create_object_url, "POST", {"Authorization" => user.jwt, "Content-Type" => "application/json"}, properties)
         Object.new(json)
      end
      
      def self.get(user, object_id)
         url = Dav::API_URL + "apps/object/" + object_id.to_s
         json = send_http_request(url, "GET", {"Authorization" => user.jwt}, nil)
         Object.new(json)
      end
   end
end