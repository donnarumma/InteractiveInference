function [states, maze] =   maze_create(MAZE)

if nargin <1
    % default maze
    MAZE = [
               1 1 1 1 1
               1 0 1 0 1
               1 0 1 1 1
               1 0 1 0 1
               1 1 1 1 1
           ];
end 

    [I,J] = find(MAZE > 0);
    states = cell(numel(I),1);                 % supporting data structures:
    maze = cell(size(MAZE,1),size(MAZE,2));    % They handles the access to the states by MAZE and viceversa. 
                                               % Quite complementar ones

    k = 1;
    for ij = 1:numel(I)                        % filling states and maze
        states{k} = [I(ij),J(ij)];
        maze{I(ij),J(ij)} = k;
        k=k+1;
    end
    