
require_relative 'Space'

class SpaceGroup

  attr_reader :name, :spaces

  def initialize (groupName, spaces)
    @name = name
    @spaces = spaces
	spaces.each do |space|
	  raise 'SpaceGroup - space already in group' unless space.group.nil?
	  space.group = self
	end
  end
  
  def allOwnedBy? player
    spaces.each do |space|
	  if space.owner != player
	    return false
      end
	end
	return true
  end
  
  def length
    return spaces.length
  end
  
  def self.makeGroups(spaces)
    groups = []
	groups.push(SpaceGroup.new('Purple',[spaces[1],spaces[3]]))
	groups.push(SpaceGroup.new('RailRoads',[spaces[5],spaces[15],spaces[25],spaces[35]]))
	groups.push(SpaceGroup.new('LightBlue',[spaces[6],spaces[8],spaces[9]]))
	groups.push(SpaceGroup.new('Pink',[spaces[11],spaces[13],spaces[14]]))
	groups.push(SpaceGroup.new('Utilities',[spaces[12],spaces[28]]))
	groups.push(SpaceGroup.new('Orange',[spaces[16],spaces[18],spaces[19]]))
	groups.push(SpaceGroup.new('Red',[spaces[21],spaces[23],spaces[24]]))
	groups.push(SpaceGroup.new('Yellow',[spaces[26],spaces[27],spaces[29]]))
    groups.push(SpaceGroup.new('Green',[spaces[31],spaces[32],spaces[34]]))
	groups.push(SpaceGroup.new('DarkBlue',[spaces[37],spaces[39]]))
	return groups
  end
end