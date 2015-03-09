
class Action
  public

  DO_NOTHING = 0
  ROLL_DICE = 1
  OFFER_TRADE = 2
  BUY_SPACE_FROM_BANK = 3
  AUCTION_OFFER_MONEY = 4
  DEMAND_RENT = 5
  
  def initialize type, *args
    attr_reader :type
    @type = type
	if type==DO_NOTHING
	  raise 'Action - incorrect number of options' unless args.length==0
	  return
	elsif type==ROLL_DICE
	  raise 'Action - incorrect number of options' unless args.length==0
	  return
	elsif type==OFFER_TRADE
	  attr_reader :who, :offerSpaces, :offerMoney, :askSpaces, :askMoney
	  raise 'Action - incorrect number of options' unless args.length==5
	  @who = args[0]
	  @offerSpaces = args[1]
	  @offerMoney = args[2]
	  @askSpaces = args[3]
	  @askMoney = args[4]
	elsif type==BUY_SPACE_FROM_BANK
	  attr_reader :space
	  raise 'Action - incorrect number of options' unless args.length==1
	  @space = args[0]
	elsif type==AUCTION_OFFER_MONEY
	  attr_reader :amount
	  raise 'Action - incorrect number of options' unless args.length==1
	  @amount = args[0]
	elsif type==DEMAND_RENT
	  attr_reader :who
	  raise 'Action - incorrect number of options' unless args.length==1
	  @who = args[0]
	else
	  raise 'Action - unrecognized type'
	end
  end
  
end