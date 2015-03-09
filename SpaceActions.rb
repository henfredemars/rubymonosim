
class SpaceActions

  def initialize
    raise 'SpaceActions - static class'
  end
  
  def self.doNothing(playerData,game,space)
    return nil
  end
  
  def self.normalRent(playerData,game,space)
    numHouses = space.houses
	numHotels = space.hotels
	if numHouses==0 and numHotels==0 and space.group.allOwnedBy?(playerData)
	  rent = space.rent*2
	elsif numHouses==0 and numHotels==0 and !space.group.allOwnedBy?(playerData)
	  rent = space.rent
	elsif numHouses>0 or numHotels>0
	  if numHouses==1
	    rent = space.h1
	  elsif numHouses==2
	    rent = space.h2
	  elsif numHouses==3
	    rent = space.h3
	  elsif numHouses==4
	    rent = space.h4
	  elsif numHotels==1
	    rent = space.hotel
	  end
	end
	playerData.subMoney(rent)
	space.owner.addMoney(rent)
	game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,rent))
	game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,space.owner,rent))
  end
  
  def self.communityChest(playerData,game,space)
    method = CommunityChest.methods(false).sample
	while method==CommunityChest.methods(:new)
	  method = CommunityChest.methods(false).sample
	end
	method.call playerData,game
  end
	
  def self.chance(playerData,game,space)
    method = Chance.methods(false).sample
	while method==Chance.methods(:new)
	  method = Chance.methods(false).sample
	end
	method.call playerData,game
  end
  
  def self.incomeTax(playerData,game,space)
    if playerData.money > 2000
	  playerData.subMoney(200)
	  game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,200))
	else
	  playerData.subMoney(playerData.money/10)
	  game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,playerData.money/10))
	end
  end
  
  def self.railRoad(playerData,game,space)
    numRailRoads = 0
	game.spaces.each do |space|
	  if space.owner == playerData and (space.position == 5 or space.position == 15 or
	    space.position == 25 or space.position == 35)
		numRailRoads += 1
	  end
	end
	if numRailRoads == 1
	  rent = 25
	elsif numRailRoads == 2
	  rent = 50
	elsif numRailRoads == 3
	  rent = 100
	else
	  rent = 200
	end
	playerData.subMoney(rent)
	space.owner.addMoney(rent)
	game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,rent))
	game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,space.owner,rent))
  end
  
  def self.utility(playerData,game,space)
    roll = playerData.lastRoll
	numberOwned = 0
	game.spaces.each do |space|
	  if space.owner == playerData and (space.position == 12 or space.position == 28)
	    numberOwned += 10
	  end
	end
	if numberOwned == 1
	  rent = 4*roll
	else
	  rent = 10*roll
	end
	playerData.subMoney(rent)
	space.owner.addMoney(rent)
	game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,rent))
	game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,space.owner,rent))
  end
  
  def self.goToJail(playerData,game,space)
    playerData.inJail = true
    playerData.move(10)
	game.pumpEvent(Event.new(Event::PLAYER_GOES_TO_JAIL,playerData))
  end
  
  def self.luxaryTax(playerData,game,space)
    playerData.subMoney(75)
	game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,75))
  end
  
end
