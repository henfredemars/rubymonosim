
require_relative 'Space'
require_relative 'SpaceGroup'
require_relative 'PlayerData'
require_relative 'Player'
require_relative 'Action'
require_relative 'Event'

#Main class
class Game

  attr_reader :spaces, :numPlayers, :playerDatas, :groups

  def initialize numPlayers
    @numPlayers = numPlayers
	@spaces = Space.make
	@groups = SpaceGroup.makeGroups @spaces
	@playerDatas = []
	@players = []
	@playerTurn = 0
	
	numPlayers.times do |i|
	  playerData = PlayerData.new(i.to_s,self)
	  playerDatas.push(playerData)
	  player = Player.new self,playerData
	  playerData.player = player
	  @players.push(player) #Will change depending on the players to test
	end
  end
  
  def start
    turn = 0
    while @players.length > 1
		pumpEvent(Event::PLAYER_NEW_TURN,@players[turn])
		turn = (turn + 1) % @players.length
	end
  end
  
  def describeEvent event
    if event.type==Event::PLAYER_LOST_MONEY
	  who = event.who
	  amount = event.amount
	  puts 'Player #{who.name} lost $#{amount}'
	elsif event.type==Event::PLAYER_GOT_MONEY
	  who = event.who
	  amount = event.amount
	  puts 'Player #{who.name} got $#{amount}'
	elsif event.type==Event::PLAYER_LANDED or event.type==Event::PLAYER_LANDED_DONT_PAY
	  who = event.who
	  position = event.position
	  space = @spaces[position]
	  if space.owner
	    puts 'Player #{who.name} landed on #{space.name} owned by #{space.owner}'
      else
	    puts 'Player #{who.name} landed on #{space.name} (unowned)'
	  end
	elsif event.type==Event::PLAYER_GOES_TO_JAIL
	  who = event.who
	  puts 'Oh no! Player #{who.name} goes to jail!'
	elsif event.type==Event::PLAYER_NEW_TURN
	  who = event.who
	  puts "It's Player #{who.name}'s turn!"
	elsif event.type==Event::PLAYERS_TRADED
	  whoStarted = event.whoStarted
	  whoAccepted = event.whoAccepted
	  offerSpaces = event.offerSpaces
	  offerMoney = event.offerMoney
	  askSpaces = event.askSpaces
	  askMoney = event.askMoney
	  puts 'Player #{whoStarted.name} traded away:'
	  offerSpaces.each do |space|
	    puts space.name
      end
	  if offerMoney > 0
	    puts offerMoney.to_s
      end
	  puts 'For the following from Player #{whoAccepted.name}:'
	  askSpaces.each do |space|
	    puts space.name
	  end
	  if askMoney > 0
	    puts askMoney.to_s
      end
	else
	  raise 'Game - unknown event in the event pumper'
	end
  end
  
  #TODO handleAuction
  
  def handleTrade action, playerWhoPostedAction
    if action.type==Action::OFFER_TRADE
	  who = action.who
	  if (who.player.trade? action)
		action.offerSpaces.each do |space|
		  space.owner = who
		end
		who.player.addMoney(offerMoney)
		playerWhoPostedAction.subMoney(offerMoney)
		action.askSpaces.each do |space|
		  space.owner = playerWhoPostedAction.playerData
		end
		who.player.subMoney(askMoney)
		playerWhoPostedAction.playerData.addMoney(askMoney)
		pumpEvent(Event.new(Event::PLAYERS_TRADED,playerWhoPostedAction,who,action.offerSpaces,action.offerMoney,
			action.askSpaces,action.askMoney))
	  end
	else
	  raise 'Game - must be a trade action to handle trade'
	end
  end
  
  def pumpEvent event
    describeEvent(event)
    @players.each do |player|
	  action = player.processEvent event
	  if event.type==Event::PLAYER_LOST_MONEY or event.type==Event::PLAYER_GOT_MONEY
	    if action.type==Action::DO_NOTHING
		  #Do nothing
		elsif action.type==Action::OFFER_TRADE
		  handleTrade action,player
	    else
		  raise 'Game - PLAYER_LOST_MONEY got illegal action'
		end
	  elsif event.type==Event::PLAYER_LANDED
	    if action.type!=Action::BUY_SPACE_FROM_BANK and @spaces[player.playerData.position].forSale? and event.who = player.playerData
		  handleAuction @spaces[player.playerData.position]
		end
	    if action.type==Action::DO_NOTHING
		  #Do nothing
		elsif action.type==Action::OFFER_TRADE
		  handleTrade action,player
		elsif action.type==Action::BUY_SPACE_FROM_BANK
		  raise 'Game - cannot buy space you didnt land on' unless player.playerData==event.who
		  player.playerData.subMoney(@spaces[event.position].price)
		  @spaces[event.position].owner = player.playerData
		  pumpEvent(Event.new(Event::PLAYER_LOST_MONEY,player.playerData,@spaces[event.position].price))
		elsif action.type==Action::DEMAND_RENT
		  raise 'Game - must own space to demand rent' unless @spaces[event.position].owner = player.playerData
		  @spaces[event.position].doAction(event.who,self)
		else
		  raise 'Game - PLAYER_LANDED illegal action'
		end
	  elsif event.type==Event::PLAYER_GOES_TO_JAIL
	    if action.type==Action::DO_NOTHING
		  #Do nothing
		elsif action.type==Action::OFFER_TRADE
		  handleTrade action,player
		else
		  raise 'Game - PLAYER_GOES_TO_JAIL illegal action'
		end
      elsif event.type==Event::PLAYER_LANDED_DONT_PAY
	    if action.type==Action::DO_NOTHING
		  #Do nothing
		elsif action.type==Action::OFFER_TRADE
		  handleTrade action,player
		else
		  raise 'Game - PLAYER_LANDED_DONT_PAY illegal action'
		end
	  elsif event.type==Event::PLAYER_NEW_TURN
	    if @players.index player == @playerTurn and action.type != Event::ROLL_DICE
	      raise 'Game - you must roll the dice when it is your turn'
	    end
	    if action.type==Action::DO_NOTHING
		   #Do nothing
		elsif action.type==Action::OFFER_TRADE
		  handleTrade action,player
	    else
		  raise 'Game - PLAYER_NEW_TURN illegal action'
		end
	  elsif event.type==Event::PLAYERS_TRADED
	    if action.type==Action::DO_NOTHING
		   #Do nothing
		elsif action.type==Action::OFFER_TRADE
		  handleTrade action,player
	    else
		  raise 'Game - PLAYERS_TRADED illegal action'
		end
	  else
	    raise 'Game - unknown event type'
	  end
	end
  end
  
  def forEachPlayer proc
    playerDatas.each proc
  end
end