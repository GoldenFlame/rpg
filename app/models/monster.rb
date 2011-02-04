
class Monster < ActiveRecord::Base
  has_many :fights
  def attack(enemy)
      dmg = Random.new.rand(base_dmg_min..base_dmg_max)
      if(enemy.eq_armor != nil)
        dmg = dmg - dmg * enemy.eq_armor.armor / (100 + enemy.eq_armor.armor)
      end
      enemy.hp -= dmg
      enemy.save
    end
end