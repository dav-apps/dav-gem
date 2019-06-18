module Dav
	class Event
		attr_reader :id, :name
		attr_accessor :logs
      
      def initialize(attributes)
         @id = attributes["id"]
			@name = attributes["name"]
			@logs = Array.new
			
			if attributes["logs"]
				@logs = convert_json_to_event_summaries_array(attributes["logs"])
            @logs.each { |log| log.event_id = @id }
            @logs.each do |log|
               log.event_id = @id
               log.period = attributes["period"]
            end
			end
		end
      
      def self.log(api_key, app_id, name, properties, save_country = false)
			url = $api_url + "analytics/event?api_key=#{api_key}&name=#{name}&app_id=#{app_id}&save_country=#{save_country}"

         result = send_http_request(url, "POST", {"Content-Type" => "application/json"}, properties)
         if result["code"] == 201
				log = EventLog.new(JSON.parse(result["body"]))

				if @logs
					@logs.push(log)
				end
         else
            raise_error(JSON.parse(result["body"]))
         end
		end

      def self.get(jwt, id, sort = "day", start_timestamp = Time.now.to_i - 2629746, end_timestamp = Time.now.to_i)
         url = $api_url + "analytics/event/#{id}?sort=#{sort}&start=#{start_timestamp}&end=#{end_timestamp}"
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)

         if result["code"] == 200
            event = Event.new(JSON.parse(result["body"]))
         else
            raise_error(JSON.parse(result["body"]))
         end
      end

      def self.get_by_name(jwt, name, app_id, sort = "day", start_timestamp = Time.now.to_i - 2629746, end_timestamp = Time.now.to_i)
         url = $api_url + "analytics/event?name=#{name}&app_id=#{app_id}&sort=#{sort}&start=#{start_timestamp}&end=#{end_timestamp}"
         result = send_http_request(url, "GET", {"Authorization" => jwt}, nil)

         if result["code"] == 200
            event = Event.new(JSON.parse(result["body"]))
         else
            raise_error(JSON.parse(result["body"]))
         end
      end

      def update(jwt, name)
         url = $api_url + "analytics/event/#{@id}"
         result = send_http_request(url, "PUT", {"Authorization" => jwt, "Content-Type" => "application/json"}, {name: name})

         if result["code"] == 200
            @name = name
            return self
         else
            raise_error(JSON.parse(result["body"]))
         end
      end

      def delete(jwt)
         url = $api_url + "analytics/event/#{@id}"
         result = send_http_request(url, "DELETE", {"Authorization" => jwt}, nil)

         if result["code"] == 200
            return true
         else
            raise_error(JSON.parse(result["body"]))
         end
      end
   end
end