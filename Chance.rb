
#Chance cards
class Chance

  def initialize
    raise 'Chance - static class'
  end
  
  def self.go_to_reading(playerData,game)
    oldPosition = playerData.position
	playerData.move(5)
	newPosition = 5
	if newPosition < oldPosition
	  playerData.addMoney(200)
	  game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,playerData,200))
	end
	game.pumpEvent(Event.new(Event::PLAYER_LANDED,playerData,playerData.position))
  end
  
  def self.go_to_illinois(playerData,game)
    oldPosition = playerData.position
	playerData.move(24)
	newPosition = 24
	if newPosition < oldPosition
	  playerData.addMoney(200)
	end
	game.pumpEvent(Event.new(Event::PLAYER_LANDED,playerData,playerData.position))
  end
	
  def self.go_back_three(playerData,game)
	playerData.moveForward(-3)
	game.pumpEvent(Event.new(Event::PLAYER_LANDED,playerData,playerData.position))
  end
	
  def self.get_fifty_dollars(playerData,game)
    playerData.addMoney(50)
	game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,playerData,50))
  end
	
  def self.pay_fifteen_dollars(playerData,game)
    playerData.subMoney(15)
	game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,15))
  end
	
  def self.go_to_charles(playerData,game)
    oldPosition = playerData.position
	playerData.move(11)
	newPosition = 11
	if newPosition < oldPosition
	  playerData.addMoney(200)
	end
	game.pumpEvent(Event.new(Event::PLAYER_LANDED,playerData,playerData.position))
  end
  
  def self.pay_each_player_fifty(playerData,game)
    numPlayers = game.numPlayers
	game.forEachPlayer do |player|
	  if !player.equals(playerData)
	    player.addMoney(50)
		game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,player,50))
	  else
	    player.subMoney(50*numPlayers-1)
		game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,50*numPlayers-1))
	  end
	end
  end
  
  def self.get_out_of_jail_free(playerData,game)
    playerData.addJailCard
	game.pumpEvent(Event.new(Event::PLAYER_GOT_JAIL_FREE_CARD,playerData))
  end
  
  def self.go_to_nearest_railroad_pay_double(playerData,game)
    while (playerData.position != 5 and playerData.position != 15 and
	  playerData.position != 25 and playerData.position != 35)
	  player.moveForward(1)
	end
	game.pumpEvent(Event.new(Event::PLAYER_LANDED,playerData,playerData.position))
	game.pumpEvent(Event.new(Event::PLAYER_LANDED,playerData,playerData.position))
  end
  
  def self.go_to_nearest_railroad_pay_double2(playerData,game)
    go_to_nearest_railroad_pay_double(playerData,game)
  end
  
  def self.go_to_nearest_utility_pay_ten(playerData,game)
    while (playerData.position != 12 and playerData.position != 28)
	  playerData.moveForward(1)
	end
	game.pumpEvent(Event.new(Event::PLAYER_LANDED_DONT_PAY,playerData,playerData.position))
	amount = playerData.rollDice*10
	playerData.subMoney(amount)
	game.spaces[playerData.position].owner.addMoney(amount)
	game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,amount))
	game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,game.spaces[playerData.position].owner,amount))
  end
  
  def self.pay_property_tax_25_100(playerData,game)
    hotels = 0
	houses = 0
	game.spaces.each do |space|
	  if space.owner==playerData
	    if !space.houses.nil?
		  houses += space.houses
		end
		if !space.hotels.nil?
		  hotels += space.hotels
		end
	  end
	end
	playerData.subMoney(hotels*100+houses*25)
	game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,hotels*100+houses*25))
  end
  
  def self.go_to_go(playerData,game)
	playerData.move(0)
	playerData.addMoney(200)
	game.pumpEvent(Event.new(Event::PLAYER_LANDED,playerData,playerData.position))
  end
  
  def self.go_to_boardwalk(playerData,game)
    oldPosition = playerData.position
	playerData.move(39)
	newPosition = 39
	if newPosition < oldPosition
	  playerData.addMoney(200)
	end
	game.pumpEvent(Event.new(Event::PLAYER_LANDED,playerData,playerData.position))
  end
end