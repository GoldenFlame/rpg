require File.dirname(__FILE__) + '/spec_helper.rb'
SimpleCov.start
Blueprints.enable
describe "avatar" do
  before(:each) do
    build :avatar
    build :item_armor
    build :item_weapon
    build :item_armor2
    build :item_weapon2
    build :city
    build :city2

    @monster = @city.fight_areas[0].monsters[0]
    
    @avatar.city = @city
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor2.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon2.id)
    @avatar.create_fight(:monster_id => @monster.id, 
      :monster_hp => @monster.max_hp,
      :ended => false,
      :fight_area_id => @avatar.city.fight_areas[0].id)
      @avatar.save
      @avatar.reload
  end
  
  describe "Area monster finder" do
    it "should return " do
      a = stub("Random", {:rand => 0})
      Random.stub!(:new).and_return(a)
      @avatar.go_to_area(@city.fight_areas[0]).should == @city.fight_areas[0].monsters[0]
    end
  end
  
  describe "Class selection" do
    it "should specify characters class as warrior and save data" do
      @avatar.class_warrior()
      expected = {:avatar_class => 1, 
        :base_dmg_min => 20, 
        :base_dmg_max => 30, 
        :max_hp => 100, 
        :hp => 100, 
        :max_mana => 10, 
        :mana => 10}
      @avatar.attributes.should have_hash_values(expected)
    end
    
    it "should specify characters class as archer and save data" do
      @avatar.class_archer()
      expected = {:avatar_class => 2, 
        :base_dmg_min => 10, 
        :base_dmg_max => 50, 
        :max_hp => 75, 
        :hp => 75, 
        :max_mana => 30, 
        :mana => 30}
      @avatar.attributes.should have_hash_values(expected)
    end
    
    it "should specify characters class as mage and save data" do
      @avatar.class_mage()
      expected = {:avatar_class => 3, 
        :base_dmg_min => 10, 
        :base_dmg_max => 20, 
        :max_hp => 50, 
        :hp => 50, 
        :max_mana => 100, 
        :mana => 100}
      @avatar.attributes.should have_hash_values(expected)
    end
  end
  
  describe "travel" do
    it"should travel to city 2" do
      @avatar.city = @city
      @avatar.travel(@city2)
      @avatar.city.name.should == @city2.name
    end
  end
  
  describe "buy item" do
    it "should add two swords and armor to avatars backpack and decrease gold amount by 30" do
      @avatar.gold = 1000
      @avatar.buy_item(@item_weapon)
      @avatar.buy_item(@item_weapon)
      @avatar.buy_item(@item_armor)
      @avatar.items.should have(5).items
    end      
  end
  
  describe "sell item" do
    it "should sell test sword and refund half the price" do      
      @avatar.buy_item(@item_weapon)
      before = AvatarItem.find_or_create_by_avatar_id_and_item_id(@avatar.id, @item_weapon.id)
      @avatar.gold = 1000
      @avatar.sell_item(@item_weapon)
      @avatar.gold.should == 1005
      after = AvatarItem.find_or_create_by_avatar_id_and_item_id(@avatar.id, @item_weapon.id)
      after.amount.should == before.amount - 1
    end
  end
  
      describe "attack" do
      
      it "should return 1 as dealt dmg" do
        #damage is calculated by taking random number in range of avataracters min damage and max damage
        #therefor mock object a returning value 1 instead of random
        a = stub("Random", {:rand => 1})
        Random.stub!(:new).and_return(a)
        @avatar.attack(@avatar.fight)
        @avatar.fight.monster_hp.should == 99
      end
      
      it "should decrease monsters health points by 2 when avatar has a weapon" do
        #damage is calculated by taking random number in range of avataracters min damage and max damage
        #therefor mock object a returning value 1 instead of random
        a = stub("Random", {:rand => 2})
        Random.stub!(:new).and_return(a)
        @avatar.eq_weapon = @item_weapon
        @avatar.attack(@avatar.fight)
        @avatar.fight.monster_hp.should == 98
      end
    end
    
    describe "skill attack" do
      it "should decrease defenders health points by 20" do
        a = stub("Random", {:rand => 10})
        Random.stub!(:new).and_return(a)
        @avatar.base_dmg_max = 10
        @avatar.skill_attack(@avatar.fight)
        @avatar.fight.monster_hp.should == 80
      end
      
      it "should decrease defenders health points by 20" do
        a = stub("Random", {:rand => 10})
        Random.stub!(:new).and_return(a)
        @avatar.eq_weapon = @item_weapon
        @avatar.base_dmg_max = 10
        @avatar.skill_attack(@avatar.fight)
        @avatar.fight.monster_hp.should == 80
      end
      
    end
    
    describe "heal" do
      it "should increase avatars health points by 10" do
        @avatar.hp = 0
        @avatar.heal
        @avatar.hp.should be_equal(10)
      end
    end
  
  describe "level up" do
    describe "experience for level" do
      it "should return 50 for level 2" do
        @avatar.level = 1
        @avatar.experience_for_level.should == 41
      end
        
      it "should return 100 for level 3" do
        @avatar.level = 2
        @avatar.experience_for_level.should == 100
      end
    end
    
    describe "check level up" do
      it "should set avatar`s level to 2" do
        @avatar.level = 1
        @avatar.exp = 100
        @avatar.check_lvlup
        @avatar.level.should == 2
      end
      
      it "should set avatar`s level to 10" do
        @avatar.level = 9
        @avatar.exp = 5000
        @avatar.check_lvlup
        @avatar.level.should == 10
      end
    end
  end
  
  
  
  describe "equip" do
    it"should equip sword" do
      @avatar.eq_weapon = nil
      @avatar.equip(@item_weapon)
      @avatar.weapon.should == @item_weapon.id
    end
    
    it"should equip armor" do
      @avatar.eq_armor = nil
      @avatar.equip(@item_armor)
      @avatar.armor.should == @item_armor.id
    end
    
    it"should put equiped test armor into backpack and test metal armor" do
      @avatar.armor = @item_armor.id
      @avatar.eq_armor = @item_armor
      @avatar.equip(@item_armor2)
      @avatar.eq_armor.should == @item_armor2
    end
    
    it"should put equiped item test bow into backpack and equip test sword" do
      @avatar.weapon = @item_weapon.id
      @avatar.eq_weapon = @item_weapon
      @avatar.equip(@item_weapon2)
      @avatar.eq_weapon.should == @item_weapon2
    end
  end
  
  describe "disequip" do
    it"should disequip test armor" do
      @avatar.equip(@item_armor)
      @avatar.disequip(@item_armor)
      @avatar.items.should include(@item_armor)
    end
    
    it"should disequip test sword" do
      @avatar.equip(@item_weapon)
      @avatar.disequip(@item_weapon)
      @avatar.items.should include(@item_weapon)
    end
  end
end