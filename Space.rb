
require_relative 'SpaceActions'

class Space

  attr_reader :name, :price, :mValue, :rent, :h1, :h2, :h3, :h4, :hotelCost, :houseCost,
    :hotel, :drawChance, :drawCommunityChest, :luxaryTax, :incomeTax, :jail, :position
  attr_accessor :owner, :houses, :group

  def initialize name, position, action, opts = {}
    @name = name
	@position = position
	@action = action
	@price = opts.delete :price
	@mValue = opts.delete :mValue
	@owner = opts.delete :owner #playerData, not player
	@group = opts.delete :group
	@mortgaged = opts.delete :mortgaged
	@houses = opts.delete :houses
	@hotels = opts.delete :hotels
	@rent = opts.delete :rent
	@h1 = opts.delete :h1
	@h2 = opts.delete :h2
	@h3 = opts.delete :h3
	@h4 = opts.delete :h4
	@hotelCost = opts.delete :hotelCost
	@houseCost = opts.delete :houseCost
	@hotel = opts.delete :hotel
	@chance = opts.delete(:chance) || false
	@communityChest = opts.delete(:communityChest) || false
	@luxaryTax = opts.delete(:luxaryTax) || false
	@incomeTax = opts.delete(:incomeTax) || false
	@jail = opts.delete(:jail) || false
	
	raise 'Space - unrecognized opts' unless opts.length==0
	raise 'Space - must have action' unless @action
	raise 'Space - must have a name' unless @name
	raise 'Space - must have a position' unless @position
	raise 'Space - housing costs not equal to hotel cost' unless @houseCost.nil? or @houseCost==@hotelCost
	raise 'Space - mortgage cost is not half the property value' unless @mValue.nil? or @mValue==@price/2
	
	if !@houses.nil? and (@houses < 0 or @houses > 4)
	  raise 'Space - invalid number of houses'
    end
	  
    if !@price.nil? and (@price <= 0)
	  raise 'Space - prices must be positive'
    end
	
    if !@mValue.nil? and (@mValue <= 0)
	  raise 'Space - mortgage value must be positive'
    end
	
    if !@rent.nil? and @rent <= 0
	  raise 'Space - rent must be positive if it exists'
    end
	
    if !@h1.nil? and (@h1<0 or !(@hotel > @h4 and @h4 > @h3 and @h3 > @h2 and @h2 > @h1 and @h1 > @rent))
      raise 'Space - house costs do not make sense'
    end
  end
	
  def forSale?
    return (!@owner and !!price)
  end
  
  def purchase! playerData
    raise 'Space - already owned' unless !@owner
    playerData.subMoney(@price)
	@owner = playerData
  end
	
  def mortgaged?
    return @mortgaged
  end
  
  def mortgage
    raise 'Space - cannot have houses on property before mortgage' unless @houses.nil? or @houses==0
	raise 'Space - cannot have hotels on property before mortgage' unless @hotels.nil? or @hotels==0
    @mortgaged = true
  end
  
  def unMortgage
    @mortgaged = false
  end
	
  def jail?
    return @jail
  end
	
  def luxaryTax?
    return @luxaryTax
  end
	
  def incomeTax?
    return @incomeTax
  end
	
  def chance?
    return @chance
  end
	
  def communityChest?
    return @communityChest
  end
  
  def doAction playerData,game
    @action.call(playerData,game,self)
  end
  
  def self.make
	spaces = []
	spaces.push(Space.new('Go',0,SpaceActions.method(:doNothing),{owner: 'board'}))
	spaces.push(Space.new('Mediteranean Ave',1,SpaceActions.method(:normalRent),{price: 60,mValue: 30,mortgaged: false,houses: 0,rent: 2,
		h1: 10, h2: 30, h3: 90, h4: 160, hotelCost: 50, houseCost: 50, hotel: 250, hotels: 0}))
	spaces.push(Space.new('Community Chest',2,SpaceActions.method(:communityChest),{owner: 'board',communityChest: true}))
	spaces.push(Space.new('Baltic Ave',3,SpaceActions.method(:normalRent),{price: 60,mValue: 30,mortgaged: false,houses: 0,rent: 4,
		h1: 20, h2: 60, h3: 180, h4: 320, hotelCost: 50, houseCost: 50, hotel: 450, hotels: 0}))
	spaces.push(Space.new('Income Tax',4,SpaceActions.method(:incomeTax),{owner: 'board',incomeTax: true}))
	spaces.push(Space.new('Reading RR',5,SpaceActions.method(:railRoad),{price: 200, mValue: 100,mortgaged: false}))
	spaces.push(Space.new('Oriental Ave',6,SpaceActions.method(:normalRent),{price: 100,mValue: 50,mortgaged: false,houses: 0,rent: 6,
		h1: 30, h2: 90, h3: 270, h4: 400, hotelCost: 50, houseCost: 50, hotel: 550, hotels: 0}))
	spaces.push(Space.new('Chance',7,SpaceActions.method(:chance),{owner: 'board',chance: true}))
	spaces.push(Space.new('Vermont Ave',8,SpaceActions.method(:normalRent),{price: 100,mValue: 50,mortgaged: false,houses: 0,rent: 6,
		h1: 30, h2: 90, h3: 270, h4: 400, hotelCost: 50, houseCost: 50, hotel: 550, hotels: 0}))
	spaces.push(Space.new('Connecticut Ave',9,SpaceActions.method(:normalRent),{price: 120,mValue: 60,mortgaged: false,houses: 0,rent: 8,
		h1: 40, h2: 100, h3: 300, h4: 450, hotelCost: 50, houseCost: 50, hotel: 600, hotels: 0}))
	spaces.push(Space.new('Just Visiting',10,SpaceActions.method(:doNothing),{owner: 'board'}))
	spaces.push(Space.new('St. Charles Pl',11,SpaceActions.method(:normalRent),{price: 140,mValue: 70,mortgaged: false,houses: 0,rent: 10,
		h1: 50, h2: 150, h3: 450, h4: 625, hotelCost: 100, houseCost: 100, hotel: 750, hotels: 0}))
	spaces.push(Space.new('Electric Company',12,SpaceActions.method(:utility),{price: 150,mValue: 75,mortgaged: false}))
	spaces.push(Space.new('States Ave',13,SpaceActions.method(:normalRent),{price: 140,mValue: 70,mortgaged: false,houses: 0,rent: 10,
		h1: 50, h2: 150, h3: 450, h4: 625, hotelCost: 100, houseCost: 100, hotel: 750, hotels: 0}))
	spaces.push(Space.new('Virginia Ave',14,SpaceActions.method(:normalRent),{price: 160,mValue: 80,mortgaged: false,houses: 0,rent: 12,
		h1: 60, h2: 180, h3: 500, h4: 700, hotelCost: 100, houseCost: 100, hotel: 900, hotels: 0}))
	spaces.push(Space.new('Pennsylvania RR',15,SpaceActions.method(:railRoad),{price: 200, mValue: 100, mortgaged: false}))
	spaces.push(Space.new('St. James Pl',16,SpaceActions.method(:normalRent),{price: 180,mValue: 90,mortgaged: false,houses: 0,rent: 14,
		h1: 70, h2: 200, h3: 550, h4: 750, hotelCost: 100, houseCost: 100, hotel: 950, hotels: 0}))
	spaces.push(Space.new('Community Chest',17,SpaceActions.method(:communityChest),{owner: 'board',communityChest: true}))
	spaces.push(Space.new('Tennessee Ave',18,SpaceActions.method(:normalRent),{price: 180,mValue: 90,mortgaged: false,houses: 0,rent: 14,
		h1: 70, h2: 200, h3: 550, h4: 750, hotelCost: 100, houseCost: 100, hotel: 950, hotels: 0}))
	spaces.push(Space.new('New York Ave',19,SpaceActions.method(:normalRent),{price: 200,mValue: 100,mortgaged: false,houses: 0,rent: 16,
		h1: 80, h2: 220, h3: 600, h4: 800, hotelCost: 100, houseCost: 100, hotel: 1000, hotels: 0}))
	spaces.push(Space.new('Free Parking',20,SpaceActions.method(:doNothing),{owner: 'board'}))
	spaces.push(Space.new('Kentucky Ave',21,SpaceActions.method(:normalRent),{price: 220,mValue: 110,mortgaged: false,houses: 0,rent: 18,
		h1: 90,h2: 250,h3: 700,h4: 875,hotelCost: 150,houseCost: 150,hotel: 1050, hotels: 0}))
	spaces.push(Space.new('Chance',22,SpaceActions.method(:chance),{owner: 'board',chance: true}))
	spaces.push(Space.new('Indiana Ave',23,SpaceActions.method(:normalRent),{price: 220,mValue: 110,mortgaged: false,houses: 0,rent: 18,
		h1: 90, h2: 250, h3: 700, h4: 875, hotelCost: 150,houseCost: 150, hotel: 1050, hotels: 0}))
	spaces.push(Space.new('Illinoise Ave',24,SpaceActions.method(:normalRent),{price: 240,mValue: 120,mortgaged: false,houses: 0,rent: 20,
		h1: 100, h2: 300, h3: 750, h4: 925, hotelCost: 150, houseCost: 150, hotel: 1100, hotels: 0}))
	spaces.push(Space.new('BO RR',25,SpaceActions.method(:railRoad),{price: 200,mValue: 100,mortgaged: false}))
	spaces.push(Space.new('Atlantic Ave',26,SpaceActions.method(:normalRent),{price: 260,mValue: 130,mortgaged: false,houses: 0,rent: 22,
		h1: 110, h2: 330, h3: 800, h4: 975, hotelCost: 150, houseCost: 150, hotel: 1150, hotels: 0}))
	spaces.push(Space.new('Ventor Ave',27,SpaceActions.method(:normalRent),{price: 260,mValue: 130,mortgaged: false,houses: 0,rent: 22,
		h1: 110, h2: 330, h3: 800, h4: 975, hotelCost: 150, houseCost: 150, hotel: 1150, hotels: 0}))
	spaces.push(Space.new('Water Works',28,SpaceActions.method(:utility),{price: 150,mValue: 75,mortgaged: false}))
	spaces.push(Space.new('Marvin Gardens',29,SpaceActions.method(:normalRent),{price: 280,mValue: 140,mortgaged: false,houses: 0,rent: 24,
		h1: 120, h2: 360, h3: 850, h4: 1025, hotelCost: 150, houseCost: 150, hotel: 1200, hotels: 0}))
	spaces.push(Space.new('Go To Jail',30,SpaceActions.method(:goToJail),{owner: 'board',jail: true}))
	spaces.push(Space.new('Pacific Ave',31,SpaceActions.method(:normalRent),{price: 300,mValue: 150,mortgaged: false,houses: 0,rent: 26,
		h1: 130, h2: 390, h3: 900, h4: 1100, hotelCost: 200, houseCost: 200, hotel: 1275, hotels: 0}))
	spaces.push(Space.new('North Carolina Ave',32,SpaceActions.method(:normalRent),{price: 300,mValue: 150,mortgaged: false,houses: 0,rent: 26,
		h1: 130, h2: 390, h3: 900, h4: 1100, hotelCost: 200, houseCost: 200, hotel: 1275, hotels: 0}))
	spaces.push(Space.new('Community Chest',33,SpaceActions.method(:communityChest),{owner: 'board',communityChest: true}))
	spaces.push(Space.new('Pennsylvania Ave',34,SpaceActions.method(:normalRent),{price: 320,mValue: 160,mortgaged: false,houses: 0,rent: 28,
		h1: 150, h2: 450, h3: 1000, h4: 1200, hotelCost: 200, houseCost: 200, hotel: 1400, hotels: 0}))
	spaces.push(Space.new('Short Line',35,SpaceActions.method(:railRoad),{price: 200,mValue: 100,mortgaged: false}))
	spaces.push(Space.new('Chance',36,SpaceActions.method(:chance),{owner: 'board',chance: true}))
	spaces.push(Space.new('Park Place',37,SpaceActions.method(:normalRent),{price: 350,mValue: 175,mortgaged: false,houses: 0,rent: 35,
		h1: 175, h2: 500, h3: 1100, h4: 1300, hotelCost: 200, houseCost: 200, hotel: 1500, hotels: 0}))
	spaces.push(Space.new('Luxury Tax',38,SpaceActions.method(:luxaryTax),{owner: 'board',luxaryTax: true}))
	spaces.push(Space.new('Boardwalk',39,SpaceActions.method(:normalRent),{price: 400,mValue: 200,mortgaged: false,houses: 0,rent: 50,
		h1: 200, h2: 600, h3: 1400, h4: 1700, hotelCost: 200, houseCost: 200, hotel: 2000, hotels: 0}))
    return spaces
  end
end


	
	