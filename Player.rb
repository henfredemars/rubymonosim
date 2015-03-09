
require_relative 'Action'
require_relative 'Event'

#Player base class with trivial AI
#Prescribes the interface of a new AI to the rest of the system
class Player

  attr_reader :playerData

  def initialize game, playerData
    #Perform any initialization that you require here
	@game = game
	@playerData = playerData
  end
  
  #Find the playerData structures for all the other players
  def getOtherPlayerDatas
    players = []
	game.playerDatas.each do |playerData|
	  if playerData.player!=self
	    players.push(playerData.player)
	  end
	end
	return players
  end
  
  #List all the playerData data structures
  def getAllPlayerDatas
    players = []
	game.playerDatas.each do |playerData|
	  players.push(playerData.player)
	end
	return players
  end
  
  #How much money do I have?
  def myMoney
    return getMoney @playerData
  end
  
  #What spaces do I own?
  def mySpaces
    return getSpaces @playerData
  end
  
  #What spaces does a player own?
  def getSpaces playerData
    spaces = []
	game.spaces.each do |space|
	  if space.owner==playerData
	    spaces.push(space)
	  end
	end
	return spaces
  end
  
  #How much money does a player have?
  def getMoney playerData
    return playerData.money
  end
  
  #What space groups are all owned by a player?
  def getGroupsTotallyOwnedBy playerData
    allOwnedGroups = []
    game.groups.each do |group|
	  if group.allOwnedBy? playerData
	    allOwnedGroups.push(group)
	  end
	end
	return allOwnedGroups
  end
  
  #Process game event and return an action
  #You MUST check for and respond to every possible event appropriately
  def processEvent event
    if event.type==Event::PLAYER_LOST_MONEY
	  return Action.new(Action::DO_NOTHING)
	elsif event.type==Event::PLAYER_GOT_MONEY
	  return Action.new(Action::DO_NOTHING)
	elsif event.type==Event::PLAYER_LANDED
	  space = game.space[event.position]
	  who = event.who
	  #Landed on my space!
	  if space.owner==@playerData and who!=@playerData
	    return Action.new(Action::DEMAND_RENT,who)
	  end
	  if space.forSale? and myMoney > (space.price + 500) and who==@playerData
	    return Action.new(Action::BUY_SPACE_FROM_BANK,space)
	  end
	elsif event.type==Event::PLAYER_GOES_TO_JAIL
	  return Action.new(Action::DO_NOTHING)
	elsif event.type==Event::PLAYER_LANDED_DONT_PAY
	  return Action.new(Action::DO_NOTHING)
	elsif event.type==PLAYER_NEW_TURN and event.who==@playerData
	  return Action.new(Action::ROLL_DICE)
	elsif event.type==PLAYERS_TRADED
	  return Action.new(Action::DO_NOTHING)
	end
	return Action.new(Action::DO_NOTHING)
  end
  
  #Bank asks you to make a bid in an auction
  def auction space, maxBid, playerData
    if maxBid < space.price-5 and playerData!=@playerData
	  return Action.new(Action::AUCTION_OFFER_MONEY,maxBid+5)
	else
	  return Action.new(Action::DO_NOTHING)
	end
  end
  
  #Bank demands us to come up with more funds
  def demandFunds req
    fundsFound = 0
	mySpaces.each do |space|
	  if !space.hotels.nil? and space.hotels > 0
	    while space.hotels > 0 and fundsFound < req
		  fundsFound += space.hotelCost
		  space.hotels -= 1
		end
	  end
	  if !space.houses.nil? and space.houses > 0
	    while space.houses > 0 and fundsFound < req
		  fundsFound += space.houseCost
		  space.houses -= 1
		end
      end
	end
	return fundsFound
  end
  
  #Bankrupt with outstanding debt to who
  def dissolveFunds who
    mySpaces.each do |space|
	  space.owner = who
	end
	who.addMoney(myMoney)
	@playerData.subMoney(myMoney)
  end
  
  #Someone offered to trade with you
  def trade? tradeActionObject
    return false
  end
  
  #Is player in jail
  def inJail? playerData
    return playerData.inJail?
  end
  
  #Does player have get out of jail free card
  def hasJailCard? playerData
    return playerData.jailFreeCard?
  end
  
  #Mortgage a property
  def mortgage space
    raise 'Player - must own space to mortgage' unless space.owner==@playerData
    @playerData.addMoney(space.mValue)
	space.mortgage
  end
  
  #Un-mortgage a property
  def Unmortgage space
    raise 'Player - must own space to unmortgage' unless space.owner==@playerData
	@playerData.subMoney(space.mValue)
	space.unMortgage
  end
  
end
