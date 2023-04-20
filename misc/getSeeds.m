function seeds = getSeeds(howmany)
   seeds=unique(randi(2^32-1,1,howmany));
   hm=length(seeds);
   
   while hm<howmany 
        seeds=unique([seeds,randi(2^32-1,1,howmany-hm)]);
        hm=length(seeds);
   end
end