
class Event
  public

  PLAYER_LOST_MONEY = 0
  PLAYER_GOT_MONEY = 1
  PLAYER_LANDED = 2
  PLAYER_GOES_TO_JAIL = 3
  PLAYER_LANDED_DONT_PAY = 4
  PLAYER_NEW_TURN = 5
  PLAYERS_TRADED = 6
  
  def initialize type, *args
    attr_reader :type
    @type = type
	if type==PLAYER_LOST_MONEY or type==PLAYER_GOT_MONEY
	  raise 'Event - incorrect number of options' unless args.length==2
	  attr_reader :amount, :who
	  @amount = args[1]
	  @who = args[0]
	elsif type==PLAYER_LANDED or type==PLAYER_LANDED_DONT_PAY
	  raise 'Event - incorrect number of options' unless args.length==2
	  attr_reader :who, :position
	  @who = args[0]
	  @position = args[1]
	elsif type==PLAYER_GOES_TO_JAIL
	  raise 'Event - incorrect number of options' unless args.length==1
	  attr_reader :who
	  @who = args[0]
	elsif type==PLAYER_NEW_TURN
	  raise 'Event - incorrect number of options' unless args.length==1
	  attr_reader :who
	  @who = args[0]
	elsif type==PLAYERS_TRADED
	  raise 'Event - incorrect number of options' unless args.length==6
	  attr_reader :whoStarted, :whoAccepted, :offerSpaces, :offerMoney,
	    :askSpaces, :askMoney
	  @whoStarted = args[0]
	  @whoAccepted = args[1]
	  @offerSpaces = args[2]
	  @offerMoney = args[3]
	  @askSpaces = args[4]
	  @askMoney = args[5]
	else
	  raise 'Event - unrecognized type'
	end
  end
  
end