function params=custom_simmetric_maze_open(params)

params.MAZE         = [
                       1 1 1 1 1
                       1 0 1 0 1
                       1 1 1 1 1
                       1 0 1 0 1
                       1 1 1 1 1
                      ];

% Five actions up = 1, down = 2, left = 3, right = 4, wait = 5.

params.Nactions     =  5;
                  
params.squargoal    = 12;      % point where is placed the square
params.cirgoal      = 10;      % point where is placed the circle

params.startT1      = 19;
params.startT2      = 3;


params.V1=[
             1     1    14    14     7    25   25   25   25   % T1, T2 long policy to circle                            LC1LC2=LC2LC1
             7     7    14    14     1    25   25   25   25   % T1, T2 long policy to square                            LS1LS2=LS2LS1
            11    11     4    24    22    25   25   25   25   % T1 straight policy to circle, T2 long policy to circle  SC1LC2
            12    12     9    24    21    25   25   25   25   % T1 straight policy to square, T2 long policy to square  SS1LS2  
            % middle
            14    14     1    25    25    25   25   25   25   % T1 and T2 straight policy to circle                     SC1SC2=SC2SC1
            14    14     2    25    25    25   25   25   25   % T1 straight policy to circle, T2 straight policy to square SC1SS2
            14    14     6    25    25    25   25   25   25   % T1 straight policy to square, T2 straight policy to circle SS1SC2
            14    14     7    25    25    25   25   25   25   % T1 and T2 straight policy to square                     SS1SS2=SS2SS1
            % square 
            22    22    14    14     6     25   25   25   25  % T1 waits and middle to square, T2 long policy to square WMS1LS2
            12    12    24    24     6     25   25   25   25  % T1 middle and waits to square, T2 long policy to square MWS1LS2
            %
             9     9     15    15    2     25   25   25   25  % T1 long policy to square, T2 middle and waits to square LS1MWS2
            10    10     14    14    2     25   25   25   25  % T1 long policy to square, T2 waits and middle to square LS1WMS2
            % circle
            21    21    14    14     2     25   25   25   25  % T1 waits and middle to circle, T2 long policy to circle WMC1LC2
            11    11    24    24     2     25   25   25   25  % T1 middle and waits to circle, T2 long policy to circle MWC1LC2
            %
             4     4    15    15     6     25   25   25   25  % T1 long policy to circle, T2 middle and waits to circle LC1MWC2
             5     5    14    14     6     25   25   25   25  % T1 long policy to circle, T2 waits and middle to circle LC1WMC2
            %
             6     6    14    14     2     25   25   25   25  % T1 long policy to square, T2 long policy to circle      LS1LC1
             2     2    14    14     6     25   25   25   25  % T1 long policy to circle, T2 long policy to square      LC1LS1
            %
            12    12    24    24     1     25   25   25   25  % T1 middle and waits to circle, T2 long policy to square MWC1LS2
            11    11    24    24     7     25   25   25   25  % T1 middle and waits to square, T2 long policy to circle MWS1LC2
            %
            4      4    11    15    10     25   25   25   25  % T1 long policy to circle, T2 straight policy to circle LC1SC2
            9      9    12    15     5     25   25   25   25  % T1 long policy to square, T2 straight policy to square LS1SS2
            9      9    15    15     1     25   25   25   25  % T1 long policy to square, T2 middle and waits to circle LS1MWC2
            4      4    15    15     7     25   25   25   25  % T1 long policy to circle, T2 middle and waits to square LC1MWS2
            25    25    25    25    25     25   25   25   25  % T1, T2 wait                                             W1W2=W2W1
            ]';
   
   
params.V2=[
            1      1   18    18     7    25   25   25   25  % T1, T2 signaling to circle
            7      7   18    18     1    25   25   25   25  % T1, T2 signaling to square
            3      3   16    20    10    25   25   25   25  % T1 straight policy to the circle, T2 long policy to circle
            8      8   17    20     5    25   25   25   25  % T1 straight policy to square, T2 long policy to square
            % middle
            18    18    1    25    25    25   25   25   25  % T1 and T2 straight policy to circle
            18    18    6    25    25    25   25   25   25  % T1 straight policy to circle, T2 straight policy to square
            18    18    2    25    25    25   25   25   25  % T1 straight policy to square, T2 straight policy to circle
            18    18    7    25    25    25   25   25   25  % T1 and T2 straight policy to square
            % square
            10    10   18    18     2    25   25   25   25  % T1 waits and middle, T2 long policy to square
             8     8   20    20     2    25   25   25   25  % T1 middle and wait to square, T2 long policy to square     
            %
            17    17   23    23     6    25   25   25   25  % T1 long policy to square, T2 middle and waits to square
            22    22   18    18     6    25   25   25   25  % T1 long policy to square, T2 waits and middle to square
            % circle
             5     5   18    18     6    25   25   25   25  % T1 waits and middle to circle, T2 long policy to circle
             3     3   20    20     6    25   25   25   25  % T1 middle and waits to circle, T2 long policy to circle
            %
             16   16   23    23     2    25   25   25   25  % T1 long policy to circle, T2 middle and waits to circle
             21   21   18    18     2    25   25   25   25  % T1 long policy to circle, T2 waits and middle to circle
            % 
             2    2    18    18     6    25   25   25   25  % T1 long policy to square, T2 long policy to circle 
             6    6    18    18     2    25   25   25   25  % T1 long policy to circle, T2 long policy to square
            %
             8    8    20    20     1    25   25   25   25  % T1 middle than wait to circle, T2 long policy to square
             3    3    20    20     7    25   25   25   25  % T1 middle and waits to square, T2 long policy to circle
            %
            16   16     3    23    22    25   25   25   25  % T1 long policy to circle, T2 straight policy to circle
            17   17     8    23    21    25   25   25   25  % T1 long policy to square, T2 straight policy to square
            17   17    23    23     1    25   25   25   25  % T1 long policy to square, T2 middle and waits to circle 
            16   16    23    23     7    25   25   25   25  % T1 long policy to circle, T2 middle and waits to square 
            25    25    25    25    25   25   25   25   25  % T1, T2 wait
            ]';
    

params.Tt       = min(size(params.V1,1),size(params.V2,1));
params.Nagents  =2;
    
slab{1}     ='T1, T2 long policy to circle';                                        %01 
slab{end+1} ='T1, T2 long policy to square';                                        %02
slab{end+1} ='T1 straight policy to circle, T2 long policy to circle';              %03
slab{end+1} ='T1 straight policy to square, T2 long policy to square';              %04
% slab{6} ='T1, T2 one step to circle than wait';
% slab{7} ='T1, T2 two steps to circle than wait';
% slab{8} ='T1 one step to square then waits, T2 one step to circle then waits';
% slab{9} ='T1 two steps to square then waits, T2 two steps to circle then waits';
slab{end+1}='T1 and T2 straight policy to circle';                                  %06
slab{end+1}='T1 straight policy to circle, T2 straight policy to square';       
slab{end+1}='T1 straight policy to square, T2 straight policy to circle';
slab{end+1}='T1 and T2 straight policy to square';
slab{end+1}='T1 waits and middle to square, T2 long policy to square';
slab{end+1}='T1 middle and waits to square, T2 long policy to square';
slab{end+1}='T1 long policy to square, T2 middle and waits to square';
slab{end+1}='T1 long policy to square, T2 waits and middle to square';
slab{end+1}='T1 waits and middle to circle, T2 long policy to circle';
slab{end+1}='T1 middle and waits to circle, T2 long policy to circle';
slab{end+1}='T1 long policy to circle, T2 middle and waits to circle';
slab{end+1}='T1 long policy to circle, T2 waits and middle to circle';
slab{end+1}='T1 long policy to square, T2 long policy to circle';
slab{end+1}='T1 long policy to circle, T2 long policy to square';
slab{end+1}='T1 middle and waits to circle, T2 long policy to square';
slab{end+1}='T1 middle and waits to square, T2 long policy to circle';

% slab{end+1}='T1 long policy then wait to circle, T2 two steps to square than middle to circle';
% slab{end+1}='T1 long policy than one wait to circle, T2 one step to square then middle to circle';
% slab{end+1}='T1 long policy than two wait to square, T2 two stepa to circle then middle to square';
% slab{end+1}='T1 long policy than one wait to square, T2 one step to circle then middle to square';

slab{end+1}='T1 long policy to circle, T2 straight policy to circle';
slab{end+1}='T1 long policy to square, T2 straight policy to square';

slab{end+1}='T1 long policy to square, T2 middle and waits to circle ';
slab{end+1}='T1 long policy to circle, T2 middle and waits to square ';
slab{end+1}='T1, T2 wait';                                                         %05

% slab{end+1}='T1 straight to square, T2 straight to circle then corrects to square';

% slab{33}='T1 one step to circle then waits, T2 one step to square then waits';
% slab{34}='T1 two steps to circle then waits, T2 two steps to square then waits';
% slab{31}='T1 and T2 straight policy to circle then up';
% slab{32}='T1 and T2 straight policy to circle then down';
% slab{33}='T1 and T2 straight policy to square then up';
% slab{34}='T1 and T2 straight policy to square then down';

params.policy_labels=slab;