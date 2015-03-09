
#Community chest cards
class CommunityChest

  def initialize
    raise 'CommunityChest - static class'
  end
  
  def self.pay_property_tax_40_115(playerData,game)
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
	playerData.subMoney(hotels*115+houses*40)
	game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,hotels*115+houses*40))
  end
  
  def self.collect_each_player_fifty(playerData,game)
    numPlayers = game.numPlayers
	game.forEachPlayer do |player|
	  if !player.equals(playerData)
	    player.subMoney(50)
		game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,player,50))
	  else
	    player.addMoney(50*numPlayers-1)
		game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,playerData,50*numPlayers-1))
	  end
	end
  end
  
  def self.pay_school_tax(playerData,game)
    playerData.subMoney(150)
	game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,150))
  end
  
  def self.pay_doctors_fee(playerData,game)
    playerData.subMoney(50)
	game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,50))
  end
  
  def self.receive_for_services(playerData,game)
    playerData.addMoney(25)
	game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,playerData,25))
  end
  
  def self.income_tax_refund(playerData,game)
    playerData.addMoney(20)
	game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,playerData,20))
  end
  
  def self.inherit(playerData,game)
    playerData.addMoney(100)
	game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,playerData,100))
  end
  
  def self.go_to_jail(playerData,game)
    playerData.inJail = true
	playerData.move(10)
	game.pumpEvent(Event.new(Event::PLAYER_GOES_TO_JAIL,playerData))
  end
  
  def self.pay_hospital(playerData,game)
    playerData.subMoney(100)
	game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,playerData,100))
  end
  
  def self.beauty_contest(playerData,game)
    playerData.addMoney(100)
	game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,playerData,100))
  end
  
  def self.sale_of_stock(playerData,game)
    playerData.addMoney(45)
	game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,playerData,45))
  end
  
  def self.xmas_fund(playerData,game)
    playerData.addMoney(100)
	game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,playerData,100))
  end
  
  def self.bank_error(playerData,game)
    playerData.addMoney(200)
	game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,playerData,200))
  end
  
  def self.go_to_go(playerData,game)
    playerData.move(0)
	playerData.addMoney(200)
	game.pumpEvent(Event.new(Event::PLAYER_LANDED,playerData,playerData.position))
  end
end
