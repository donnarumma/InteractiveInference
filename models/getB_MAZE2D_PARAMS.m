%% function B = getB_MAZE2D_PARAMS(T,states,maze,belief_propagation)
function B = getB_MAZE2D_PARAMS(T,states,maze,belief_propagation)

% try
%     original_version=original_code;
% catch
%     original_version=1;
% end
% Transition matrixes B{f}(Ns(f),Ns(f),u)
%--------------------------------------------------------------------------
% where f = 1,...,Nf and
% u =  (1,1), (1,2), (1,3), (1,4), (1,5), (2,1), (2,2),..., (2,5), (3,1),
% (3,2),..., (3,5), (4,1),..., (4,5), (5,1),..., (5,5). Actions 
% (in an allocentric system) are encoded following the sequence shown above
% where up = 1, down = 2, left = 3, right = 4, wait = 5.

% transitions for the T generative model
B{1} = zeros(T.Ns(1),T.Ns(1),T.Nu);
B{2} = zeros(T.Ns(2),T.Ns(2),T.Nu);
B{3} = zeros(T.Ns(3),T.Ns(3),T.Nu);

hm=5;
for u = 1:T.Nu
%   if original_version
%       belief_propagation=1;
%   end
    BM=eye(T.Ns(2))*belief_propagation;
    BM(BM==0)=(1-belief_propagation)/(T.Ns(2)-1);
    B{2}(:,:,u)  = BM;
    for s = 1:T.Ns(1)
        switch floor((u-1)/hm) 
            case 0
                if states{s}(1) > 1 && ~isempty(maze{states{s}(1)-1,states{s}(2)})
                    B{1}(maze{states{s}(1)-1,states{s}(2)},s,u) = 1;
                else
                    B{1}(s,s,u) = 1;
                end
            case 1
                if states{s}(1) < size(maze,1) && ~isempty(maze{states{s}(1)+1,states{s}(2)})
                    B{1}(maze{states{s}(1)+1,states{s}(2)},s,u) = 1;
                else
                    B{1}(s,s,u) = 1;
                end
            case 2
                if states{s}(2) > 1 && ~isempty(maze{states{s}(1),states{s}(2)-1})
                    B{1}(maze{states{s}(1),states{s}(2)-1},s,u) = 1;
                else
                    B{1}(s,s,u) = 1;
                end
            case 3
                if states{s}(2) < size(maze,2) && ~isempty(maze{states{s}(1),states{s}(2)+1})
                    B{1}(maze{states{s}(1),states{s}(2)+1},s,u) = 1;
                else
                    B{1}(s,s,u) = 1;
                end
            otherwise
                B{1}(:,:,u) = eye(T.Ns(1));
        end
        switch mod(u,hm)
            case 1
                if states{s}(1) > 1 && ~isempty(maze{states{s}(1)-1,states{s}(2)})
                    B{3}(maze{states{s}(1)-1,states{s}(2)},s,u) = 1;
                else
                    B{3}(s,s,u) = 1;
                end
            case 2
                if states{s}(1) < size(maze,1) && ~isempty(maze{states{s}(1)+1,states{s}(2)})
                    B{3}(maze{states{s}(1)+1,states{s}(2)},s,u) = 1;
                else
                    B{3}(s,s,u) = 1;
                end
            case 3
                if states{s}(2) > 1 && ~isempty(maze{states{s}(1),states{s}(2)-1})
                    B{3}(maze{states{s}(1),states{s}(2)-1},s,u) = 1;
                else
                    B{3}(s,s,u) = 1;                   
                end
            case 4
                if states{s}(2) < size(maze,2) && ~isempty(maze{states{s}(1),states{s}(2)+1})
                     B{3}(maze{states{s}(1),states{s}(2)+1},s,u) = 1;                   
                else
                    B{3}(s,s,u) = 1;
                end
            case 0
                    B{3}(:,:,u) = eye(T.Ns(1));                
        end
    end 
end
