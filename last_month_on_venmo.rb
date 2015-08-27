require "json"
require "net/http"

class RecentPayments
  attr_accessor :payments

  def initialize(access_token)
    url = "https://api.venmo.com/v1/payments?access_token=#{access_token}"
    response = Net::HTTP.get_response(URI.parse(url))
    data = response.body
    @payments = JSON.parse(data)["data"]
  end

  def with_user(user_id)
    payments_with_user = []
    self.payments.each do |payment|
      if payment["target"]["user"]["id"] == user_id or payment["actor"]["id"] == user_id
        payments_with_user << payment
      end
    end
    payments_with_user
  end
end
