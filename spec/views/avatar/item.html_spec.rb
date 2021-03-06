require 'spec_helper.rb'

describe "avatar/item.html.erb" do
  before(:each) do
    build :avatar
    build :item_armor
    build :item_weapon
    build :item_armor2
    build :item_weapon2
    build :city
    build :city2

    @monster = @city.fight_areas[0].monsters[0]
    session[:user_id] = @avatar.id
    @avatar.city = @city
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_armor2.id)
    @avatar.avatar_items.create(:amount => 1, :item_id => @item_weapon2.id)
  end
  it "should displays name test bow" do
    assign(:item, @avatar.items[0])

    render
    rendered.should include("test bow")
    
  end
  
  it "should displays test bows damage" do
    assign(:item, @item_weapon)
    render
    rendered.should include("Damage")
    
  end
end