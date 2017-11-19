module Dav
   attr_accessor :name, :description, :published
   
   class App
      def initialize(attributes)
         @name = attributes["name"]
         @description = attributes["description"]
         @published = attributes["description"]
      end
      
      def self.create(user, name, desc)
         create_app_url = Dav::API_URL + 'apps/app?name=' + name + '&desc=' + desc
         json = send_http_request(create_app_url, user.jwt, "POST")
         app = App.new(json)
      end
      
      def self.get(user, id)
         get_app_url = Dav::API_URL + 'apps/app/' + id.to_s
         json = send_http_request(get_app_url, user.jwt, "GET")
         app = App.new(json)
      end
   end
end