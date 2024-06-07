require "csv"

Character = Struct.new(:name, :element, :path, :rarity, :type)

chars = []
CSV.foreach("output.csv") do |row|
  chars << Character.new(*row)
end


five_stars = chars.select { |c| c.rarity == "5" && c.type =="Standard"}
four_stars = chars.select { |c| c.rarity == "4" }
banner_five_star = "Fu Xuan"
banner_four_stars = ["March 7th", "Xueyi", "Hanya"]

five_star_pity = 0
four_star_pity = 0

pulled_five_stars = 0
pulled_four_stars = 0
times_hit_hard_pity = 0
times_hit_soft_pity = 0
early_five_stars = 0
fifty_fifties_won = 0
five_star_pull = []
total_pulls = 0

lost_fifty_fifty = false

repeat = 1

while (repeat <= 2000000) do
  for a in 1..10 do
    total_pulls += 1
    if four_star_pity == 10
     current_pull = 315
    elsif five_star_pity >= 75 && five_star_pity < 90
      upper_ceiling = 380 + ((five_star_pity - 75) * 20)
      #puts(upper_ceiling)
      current_pull = rand(1..upper_ceiling)
    elsif five_star_pity >= 90
      current_pull = 333
      pulled_five_stars += 1
      times_hit_hard_pity += 1
    else
      current_pull = rand(1..333)
    end
    if current_pull >= 332
      if five_star_pity >= 75
        times_hit_soft_pity += 1
      else
        early_five_stars += 1
      end
      pulled_five_stars += 1
      #puts("Five star")
      #puts("#{five_star_pity}")
      five_star_pull << five_star_pity
      if lost_fifty_fifty
        #puts("You pulled: #{banner_five_star}")
        #puts("Won the 50/50")
        fifty_fifties_won += 1
        lost_fifty_fifty = false
      elsif (rand(1..2)) == 1
        #puts("You pulled: #{banner_five_star}")
        fifty_fifties_won += 1
        #puts("Won the 50/50")
      else
        lost_fifty_fifty = true
        #puts("You pulled: #{five_stars[rand(five_stars.length())].name}")
        #puts("Lost the 50/50")
      end
      five_star_pity = 0
      four_star_pity += 1
    elsif current_pull <= 331 && current_pull >= 314
      #puts("Four star")
      pulled_four_stars += 1
      if (rand(1..2)) == 1
        #puts("You pulled: #{banner_four_stars[rand(banner_four_stars.length())]}")
        #puts("Won the 50/50")
      else
        pull = four_stars[rand(four_stars.length())].name
        while banner_four_stars.include?(pull) do
          pull = four_stars[rand(four_stars.length())].name
        end
        #puts("You pulled: #{pull}")
        #puts("Lost the 50/50")
      end
      five_star_pity += 1
      four_star_pity = 0
    else
      #puts("Three star")
      five_star_pity += 1
      four_star_pity += 1
    end
  end
  #puts("5* pity: #{five_star_pity}")
  #puts("4* pity: #{four_star_pity}")
repeat += 1
end

puts("Total pulls = #{total_pulls}")
puts("Pulled 5*s = #{pulled_five_stars}")
puts("Pulled 4*s = #{pulled_four_stars}")
puts("Times hit hard pity =  #{times_hit_hard_pity}")
puts("Hard pity rate = #{((times_hit_hard_pity.to_f/pulled_five_stars.to_f) * 100).round(2)}%")
puts("Times hit soft pity =  #{times_hit_soft_pity}")
puts("Soft pity rate = #{((times_hit_soft_pity.to_f/pulled_five_stars.to_f) * 100).round(2)}%")
puts("Early 5*s = #{early_five_stars}")
puts("Early rate = #{((early_five_stars.to_f/pulled_five_stars.to_f) * 100).round(2)}%")
puts("50/50s won = #{fifty_fifties_won}")
puts("50/50 win rate = #{((fifty_fifties_won.to_f/pulled_five_stars.to_f) * 100).round(2)}%")
#puts("Pulls where a 5* was gotten #{five_star_pull}")
puts("Average pull where a 5* was gotten = #{five_star_pull.sum.fdiv(five_star_pull.size).round(2)}")
five_star_rate = (pulled_five_stars.to_f/total_pulls.to_f) * 100
four_star_rate = (pulled_four_stars.to_f/total_pulls.to_f) * 100
puts("5* rate: #{five_star_rate.round(2)}%" )
puts("4* rate: #{four_star_rate.round(2)}%" )
