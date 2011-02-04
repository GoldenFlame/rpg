blueprint :avatar do
  @avatar = Avatar.create(:name         => "test",
                          :password     => "test",
                          :avatar_class => 0,
                          :level        => 1,
                          :exp          => 0,
                          :city_id      => 0,
                          :gold         => 100,
                          :base_dmg_min => 0,
                          :base_dmg_max => 0,
                          :max_hp       => 10,
                          :hp           => 10,
                          :max_mana     => 10,
                          :mana         => 10,
                          :weapon       => nil,
                          :armor        => nil
  )
  item    = Item.create(:name => "test bow")
  @avatar.avatar_items.create(:amount => 1, :item_id => item.id)
end


Item.blueprint(:item_sword, :name => "test sword", :item_class => "sword", :price => 10, :damage_min => 10, :damage_max => 20)
Item.blueprint(:test_bow, :name => "test armor", :item_class => "armor", :price => 10, :armor => 5)
Item.blueprint(:test_armor, :name => "test armor", :item_class => "armor", :price => 10, :armor => 5)
Item.blueprint(:test_metal_armor, :name => "test metal armor", :item_class => "armor", :price => 30, :armor => 10)


City.blueprint(:city, :name => "Testion", :shop => d(:shop))
FightArea.blueprint(:fight_area_forest, :name => "forest", :city => :city)
Monster.blueprint(:monster_blob, :name => "monster_blob",
                  :max_hp              => 100,
                  :base_dmg_min        => 5,
                  :base_dmg_max        => 10,
                  :exp_bonus           => 10,
                  :gold_max            => 100,
                  :fight_area          => d(:fight_area_forest))

Shop.blueprint(:shop, :name => "Testion_shop")

City.blueprint(:city2, :name => "Deli", :shop => d(:shop))