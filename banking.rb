class Person 
  attr_reader :name
  attr_accessor :balance, :cash, :other_bank_balance, :other_bank_name, :credit_limit, :card_type
  
  def initialize (name, cash)
    @name = name
    @cash = cash
    @credit_limit = 0
    puts "Hi, #{name}. You have $#{cash}!"
  end
end

class Bank
  attr_reader :bank_name
  attr_accessor :clients_list, :total_cash_balance, :credit_card_clients_list, :total_revenue, :swipe_fee, :over_the_limit_fee

  @@banks = []

  def initialize (bank_name)
    @bank_name = bank_name
    @@banks << bank_name
    @clients_list = []
    @credit_card_clients_list = []
    @total_cash_balance = 0
    @total_revenue = 0
    puts "#{bank_name} bank was just created."
  end

  def open_account (client)
    clients_list << client
    client.balance = 0
    client.other_bank_balance = 0

    puts "#{client.name}, thanks for opening an account at #{bank_name}!"
  end

  def deposit (client, cash)
    if client.cash < cash
      puts "#{client.name} does not have enough cash to deposit $#{cash}."
    else
      client.cash -= cash
      client.balance += cash
      self.total_cash_balance += cash
      puts "#{client.name} deposited $#{cash} to #{bank_name}. #{client.name} has $#{client.cash}. #{client.name}'s account has $#{client.balance}."
    end
  end

  def withdraw (client, cash)
    if client.balance < cash
      puts "#{client.name} does not have enough money in the account to withdraw $#{cash}."
    else
      client.cash += cash
      client.balance -= cash
      self.total_cash_balance -= cash
      puts "#{client.name} withdrew $#{cash} from #{bank_name}. #{client.name} has $#{client.cash}. #{client.name}'s account  has $#{client.balance}."
    end
  end

  def transfer (client, other_bank_name, cash)
    client.balance -= cash
    client.other_bank_balance += cash
    
    if @@banks.include?(other_bank_name.bank_name)
      other_bank_name = other_bank_name.bank_name
    else
      puts "This bank does not exist. Choose a different bank."
    end
    
    puts "#{client.name} transferred $#{cash} from the #{self.bank_name} account to the #{other_bank_name} account. The #{self.bank_name} bank account has $#{client.balance} and the #{other_bank_name} account has $#{client.other_bank_balance}."
  end

  def total_cash_in_bank
    return "#{self.bank_name} has $#{self.total_cash_balance} in the bank."
  end
  
  def apply_credit_card (client, card_type)
    credit_card_clients_list << client
    client.card_type = card_type
    self.over_the_limit_fee = 25

    if card_type.downcase == "gold"
      client.credit_limit = 5000
    elsif card_type.downcase == "platinum"
      client.credit_limit = 10000
    end

    puts "#{client.name}, you have successfully applied for a #{card_type.capitalize} credit card with a credit limit of $#{client.credit_limit} at #{bank_name}. Happy spending!"
  end

  def use_credit_card (client, cash)
    @swipe_fee = 5
    client.credit_limit -= cash
    self.total_revenue += swipe_fee

    puts "#{client.name}, you have charged $#{cash} to your credit card. Happy spending!"

    if client.credit_limit < 0
      self.total_revenue += self.over_the_limit_fee
      puts "#{client.name}, you are now $#{client.credit_limit.abs} over your credit limit and have been charged $#{self.over_the_limit_fee + swipe_fee} in fees."
    end
  end

  def reset_credit_card (client)
    if client.card_type == "gold"
      client.credit_limit = 5000
    elsif client.card_type == "platinum"
      client.credit_limit = 10000
    end
      puts "#{client.name}, your credit limit has been restored to $#{client.credit_limit}. Happy spending!"
  end
end

chase = Bank.new("JP Morgan Chase")
wells_fargo = Bank.new("Wells Fargo")
me = Person.new("Shehzan", 500)
friend1 = Person.new("John", 1000)
chase.open_account(me)
chase.open_account(friend1)
wells_fargo.open_account(me)
wells_fargo.open_account(friend1)

chase.apply_credit_card(me, "gold")
chase.use_credit_card(me, 200)
puts chase.total_revenue
chase.use_credit_card(me, 6000)
puts chase.total_revenue
chase.reset_credit_card(me)



  





