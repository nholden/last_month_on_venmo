require "json"
require "net/http"

print "Access token: "
access_token = gets.chomp

def recent_payments(access_token)
  url = "https://api.venmo.com/v1/payments?access_token=#{access_token}"
  response = Net::HTTP.get_response(URI.parse(url))
  data = response.body
  JSON.parse(data)
end

puts recent_payments(access_token)
