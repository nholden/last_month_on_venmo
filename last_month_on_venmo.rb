require "json"
require "net/http"
require "date"

class Payments
  def initialize(access_token, past_days = 30)
    after_date = ((Date.today)-past_days).to_s
    url = "https://api.venmo.com/v1/payments?access_token=#{access_token}&after=#{after_date}"
    response = Net::HTTP.get_response(URI.parse(url))
    data = response.body
    @payments = JSON.parse(data)["data"]
  end

  def with_user(username)
    payments_with_user = []
    @payments.each do |payment|
      if payment["target"]["user"]["username"].downcase == username.downcase or 
         payment["actor"]["username"].downcase == username.downcase
        date = payment["date_created"][0,10]
        actor = payment["actor"]["first_name"]
        target = payment["target"]["user"]["first_name"]
        amount = "%.2f" % payment["amount"]
        note = payment["note"]
        payments_with_user << "On #{date}, #{actor} paid #{target} $#{amount} for #{note}"
      end
    end
    payments_with_user
  end     

  def largest
    largest_amount = 0
    largest_payment = nil
    @payments.each do |payment|
      if payment["amount"] > largest_amount
        largest_amount = payment["amount"]
        largest_payment = payment
      end
    end
    date = largest_payment["date_created"][0,10]
    actor = largest_payment["actor"]["first_name"]
    target = largest_payment["target"]["user"]["first_name"]
    amount = "%.2f" % largest_payment["amount"]
    note = largest_payment["note"]
    "On #{date}, #{actor} paid #{target} $#{amount} for #{note}"
  end

  def all
    payments = []
    @payments.each do |payment|
      date = payment["date_created"][0,10]
      actor = payment["actor"]["first_name"]
      target = payment["target"]["user"]["first_name"]
      amount = "%.2f" % payment["amount"]
      note = payment["note"]
      payments << "On #{date}, #{actor} paid #{target} $#{amount} for #{note}"
    end
    payments
  end
end

print "Your access token: "
access_token = gets.chomp
last_month_payments = Payments.new(access_token)
print "Command (all, largest, with_user): "
command = gets.chomp

if command == "with_user"
  print "Other person's username: "
  username = gets.chomp
  last_month_payments_with_user = last_month_payments.with_user(username)
  if last_month_payments_with_user.empty?
    puts "No payments with #{username} found."
  else
    last_month_payments_with_user.each { |payment| puts payment }
  end
elsif command == "largest"
  puts last_month_payments.largest
elsif command == "all"
  last_month_payments.all.each { |payment| puts payment }
else
  puts "Command not recognized."
end
