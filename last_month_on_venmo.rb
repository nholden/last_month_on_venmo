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
    payments.each do |payment|
      if payment["target"]["user"]["id"] == user_id or payment["actor"]["id"] == user_id
        payments_with_user << payment
      end
    end
    payments_with_user
  end

  def summaries_with_user(user_id)
    payment_summaries_with_user = []
    with_user(user_id).each do |payment|
      date = payment['date_created'][0,10]
      actor = payment['actor']['first_name']
      target = payment['target']['user']['first_name']
      amount = '%.2f' % payment['amount']
      note = payment['note']
      payment_summaries_with_user << "On #{date}, #{actor} paid #{target} $#{amount} for #{note}"
    end
    payment_summaries_with_user
  end     
end

print "Your access token: "
access_token = gets.chomp
print "Other user's ID: "
user_id = gets.chomp

RecentPayments.new(access_token).summaries_with_user(user_id).each { |summary| puts summary }
