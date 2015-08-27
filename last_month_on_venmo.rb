require "json"
require "net/http"
require "date"

class LastMonthPayments
  def initialize(access_token)
    thirty_days_ago = ((Date.today)-30).to_s
    url = "https://api.venmo.com/v1/payments?access_token=#{access_token}&after=#{thirty_days_ago}"
    response = Net::HTTP.get_response(URI.parse(url))
    data = response.body
    @payments = JSON.parse(data)["data"]
  end

  def with_user(username)
    payments_with_user = []
    @payments.each do |payment|
      if payment["target"]["user"]["username"].downcase == username.downcase or 
         payment["actor"]["username"].downcase == username.downcase
        date = payment['date_created'][0,10]
        actor = payment['actor']['first_name']
        target = payment['target']['user']['first_name']
        amount = '%.2f' % payment['amount']
        note = payment['note']
        payments_with_user << "On #{date}, #{actor} paid #{target} $#{amount} for #{note}"
      end
    end
    payments_with_user
  end     
end

print "Your access token: "
access_token = gets.chomp
print "Other persons's username: "
username = gets.chomp

@user_last_month_payments = LastMonthPayments.new(access_token)
@user_last_month_payments.with_user(username).each { |payment| puts payment }
