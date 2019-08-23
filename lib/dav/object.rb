module Dav
   class Object
      attr_reader :id, :table_id, :user_id, :uuid, :visibility, :is_file, :properties, :etag
      attr_accessor :file
      
      def initialize(attributes)
         @id = attributes["id"]
         @table_id = attributes["table_id"]
         @user_id = attributes["user_id"]
         @uuid = attributes["uuid"]
         @visibility = attributes["visibility"]
         @properties = attributes["properties"]
         @is_file = attributes["file"]
         @etag = attributes["etag"]
      end
      
      def self.create(jwt, table_name, app_id, properties, visibility)
         url = $api_url + "apps/object?table_name=#{table_name}&app_id=#{app_id}"
         url += "&visibility=#{visibility}" if visibility
         result = send_http_request(url, "POST", {"Authorization" => jwt, "Content-Type" => "application/json"}, properties)
         if result["code"] == 201
            Object.new(JSON.parse(result["body"]))
         else
            raise_error(result["body"])
         end
      end

      def self.create_file(jwt, table_name, app_id, file, content_type, ext)
         url = $api_url + "apps/object?table_name=#{table_name}&app_id=#{app_id}&ext=#{ext}"
         result = send_http_request(url, "POST", {"Authorization" => jwt, "Content-Type" => content_type}, file)
         if result["code"] == 201
            Object.new(JSON.parse(result["body"]))
         else
            raise_error(result["body"])
         end
      end
      
      def self.get(jwt, object_id, access_token)
         url = $api_url + "apps/object/#{object_id}"
         url += "?access_token=#{access_token}" if access_token
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)

         if result["code"] == 200
            obj = Object.new(JSON.parse(result["body"]))

            if obj.is_file
               # Get the file
               url = $api_url + "apps/object/#{object_id.to_s}?file=true"
               url += "&access_token=#{access_token}" if access_token
               result2 = send_http_request(url, "GET", {"Authorization" => jwt}, nil)

               if result2["code"] == 200
                  obj.file = result2["body"]
                  return obj
               else
                  raise_error(result2["body"])
               end
            else
               return obj
            end
         else
            raise_error(result["body"])
         end
      end

      def self.get_with_auth(auth_token, id)
         url = $api_url + "apps/object/#{id}/auth"
         result = send_http_request(url, "GET", {'Authorization' => auth_token}, nil)

         if result["code"] == 200
            obj = Object.new(JSON.parse(result["body"]))

            if obj.is_file
               # Get the file
               url = $api_url + "apps/object/#{id}/auth?file=true"
               result2 = send_http_request(url, "GET", {'Authorization' => auth_token}, nil)

               if result2["code"] == 200
                  obj.file = result2["body"]
                  return obj
               else
                  raise_error(result2["body"])
               end
            else
               return obj
            end
         else
            raise_error(result["body"])
         end
      end
      
      def update(jwt, properties, visibility)
         url = $api_url + "apps/object/#{@id}"
         url += "?visibility=#{visibility}" if visibility
         result = send_http_request(url, "PUT", {"Authorization" => jwt, "Content-Type" => "application/json"}, properties)
         if result["code"] == 200
            # Update local object
            @properties = JSON.parse(result["body"])["properties"]
         else
            raise_error(result["body"])
         end
      end

      def update_file(jwt, file, content_type, ext, visibility)
         url = $api_url + "apps/object/#{@id}?"
         url += "ext=#{ext}&" if ext
         url += "visibility=#{visibility}" if visibility
         result = send_http_request(url, "PUT", {"Authorization" => jwt, "Content-Type" => content_type}, file)

         if result["code"] == 200
            @file = file
            @properties = JSON.parse(result["body"])["properties"]
         else
            raise_error(result["body"])
         end
      end
      
      def delete(jwt)
         url = $api_url + "apps/object/#{@id}"
         result = send_http_request(url, "DELETE", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            JSON.parse(result["body"])
         else
            raise_error(result["body"])
         end
      end

      def create_access_token(jwt)
         url = $api_url + "apps/object/#{@id}/access_token"
         result = send_http_request(url, "POST", {"Authorization" => jwt}, nil)
         if result["code"] == 201
            return JSON.parse(result["body"])["token"]
         else
            raise_error(result["body"])
         end
      end

      def get_access_token(jwt)
         url = $api_url + "apps/object/#{@id}/access_token"
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            return JSON.parse(result["body"])["access_token"]
         else
            raise_error(result["body"])
         end
      end

      def add_access_token(jwt, token)
         url = $api_url + "apps/object/#{@id}/access_token/#{token}"
         result = send_http_request(url, "PUT", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            return true
         else
            raise_error(result["body"])
         end
      end

      def remove_access_token(jwt, token)
         url = $api_url + "apps/object/#{@id}/access_token/#{token}"
         result = send_http_request(url, "DELETE", {"Authorization" => jwt}, nil)
         if result["code"] == 200
            return true
         else
            raise_error(result["body"])
         end
      end
   end
end