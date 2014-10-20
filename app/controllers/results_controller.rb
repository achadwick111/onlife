class ResultsController < ApplicationController
  def home
	  max = 0;		# initialize mostimproved batting avg by 0
	  first = Batting.select("playerID,AB,H").where("yearID = 2009") # select playerid , add_bats, hits of players played in 2009
		f= first.where("AB > 199") # select players with add_bats atleast 200
		second = Batting.select("playerID,AB,H").where("yearID = 2010") # select playerid , add_bats, hits of players played in 2009
		s= second.where("AB > 199")         # select players with add_bats atleast 200
		final = f.all.map(&:playerID) & s.all.map(&:playerID)    # merge record from 2009 and 2010 by their player_id
				
		final.each do |x|         # loop for all players
			@max_id = x
			totalAB = 0				# initialize local variables
			totalH = 0
			demofirst = Batting.where("playerID" => x).where("yearID = 2009")   
			totalAB = totalAB + demofirst[0][:AB]				# evaluate total add_bats in 2009
			totalH = totalH + demofirst[0][:H]   # evaluate total hits in 2009
			avg2009 = (totalH/totalAB)*100			  
			sumAB = 0
			sumH = 0
			  demosecond = Batting.where("playerID" => x).where("yearID = 2010")
		 	sumAB = totalAB + demosecond[0][:AB]     # evaluate total add_bats in 2010
		 	sumH = totalH + demosecond[0][:H]       # evaluate total hits in 2010
			avg2010 = (totalH/totalAB)*100
			avg = avg2010 - avg2009		 # Calculate improvement of player
			if avg > max then
				max = avg		# evaluate maximum improved player
				@max_id = x
			end
		end
  end

  def slugging
  
  	person = Batting.where("teamID = 'OAK' AND yearID = 2007")   # extract all players from team "oak" and of year 2007

  	hits = person.map {|i| i.H}.compact.sum      # evaluate total hits
  	doubles = person.map {|i| i.B2}.compact.sum   # evaluate total doubles
  	triples = person.map {|i| i.B3}.compact.sum    # evaluate total triples
  	hr = person.map {|i| i.HR}.compact.sum      # evaluate total home runs
  	ab = person.map {|i| i.AB}.compact.sum      # evaluate total add_bats

 	@slug = ((hits-doubles-triples-hr)+(2*doubles)+(3*triples)+(4*hr))/ab      # Evaluate Slug percentage
  end

	def triple_crown
	
		uniq_record = Batting.all.map(&:playerID).uniq     # Evaluate players with unique player id  
		@batting_title = Array.new    # Declare an array for batting title players
		@average = Array.new        # Declare an array for average of players
		@hr = Array.new            # Declare an array for home runs players
		@rbi = Array.new	     # Declare an array for RBI of players
		uniq_record.each do |x|         # Loop for each player with unique id
			one = Batting.where("playerID" => x )      # extract all record for a particular player
                        
		
				h = one.map {|i| i.H}.compact.sum    # evaluate sum of all Hits
				ab = one.map {|i| i.AB}.compact.sum    # evaluate sum of all ADD_bats
				if ab >= 400 then			# condition for batting title	
					@batting_title.push x
				end
				hr = one.map {|i| i.HR}.compact.sum      # evaluate sum of all Home Runs 
				rbi = one.map {|i| i.RBI}.compact.sum     # evaluate sum of all RBI
				if ab != 0 then				# condition for not to be divided by 0
					avg = h/ab
				else
					avg = 0
				end
				@average.push avg
	                    
				@hr.push hr                      # push items in array
				@rbi.push rbi

		end
			aa= @average.each_with_index.max             # evaluate player with max average        
			hh = @hr.each_with_index.max             # evaluate player with max home run
			rr =@rbi.each_with_index.max              # evaluate player with max rbi

		if (aa[0] == hh[0]) then 			# condition for Triple crown winner
			if (rr[0] == hh[0]) then
		@message = "Triple crown winner = #{aa[1]}"       
			else
			@message = "There is no Triple crown winner"
		end
		else
		@message = "There is no Triple crown winner"
		end

	
	end
end








 
