
#Data structure used by the board to track player information
#Interface to AIs without making assumptions about their internal data
class PlayerData

  attr_reader :lastRoll, :money, :name
  attr_accessor :inJail, :player

  def initialize name,game,startMoney=1500
    #Please use getter and setter methods to change these values
	@name = name
	@game = game
	@player = nil
	@lastRoll = nil
    @money = startMoney
	@jailFreeCards = 0
	@inJail = false
	@turnsInJail = 0
	@position = 0 #Go
	@spaces = {}
	@prng = Random.new
  end
	
  def addMoney(amount)
    @money += amount
  end
  
  def addJailCard
    @jailFreeCards += 1
  end
  
  def subJailCard
    @jailFreeCards -= 1
  end
  
  def jailFreeCard?
    return @jailFreeCards > 0
  end
  
  def inJail?
    return @inJail
  end
	
  def subMoney(amount)
    @money -= amount
  end
	
  def addSpace(space)
    space.owner = @name
    @spaces.push(space)
  end
	
  def buySpace(space)
    raise 'PlayerData - space is not for sale' unless space.forSale?
	raise 'PlayerData - not enough money' unless space.price <= @money
	raise 'PlayerData - not on space' unless @position==space.position
	@money -= space.price
	@game.pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,self,space.price))
	@spaces.push(space)
  end
	
  def moveForward(distance)
    oldPosition = @position
    @position = (@position+distance) % 40
	if oldPosition > newPosition
	  @game.pumpEvent(Event.new(Event::PLAYER_GOT_MONEY,playerData,200))
	end
  end
  
  def move(position)
    raise 'PlayerData - out of range move' unless position >= 0 and position < 40
    @position = position
  end

  def rollDice()
    @lastRoll = (prng.rand(6)+1) + (prng.rand(6)+1)
	return lastRoll
  end
end
  