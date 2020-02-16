-module(erlangAssessment).
-compile(export_all).

% Raymond Ward, 2020/19/13.


% 1)a)
pos_bids(Bids) -> lists:filter(fun({_,Amount}) -> Amount > 0 end, Bids).

% 1)b)
success(Bids, Threshold) -> Threshold =< lists:foldl(fun({_,Amount}, Sum) -> Amount + Sum end, 0, pos_bids(Bids)).

% 1)c) 
winners(Threshold,Bids) -> winners(Threshold,Bids,0).
winners(Threshold,[Bid|Bids],Sum) when Sum < Threshold -> [Bid] ++ winners(Threshold,Bids,Sum+element(2,Bid));
winners(_,[],_)  -> [];
winners(_,[_|_],_)  -> [].



% 2)a)
init([X|[]], [Y|_]) when X == Y-> true;
init ([X|Xs], [Y|Ys]) when X == Y -> init(Xs,Ys);
init(_, _) -> false.


% 2)b)
drop(_,[]) -> "";
drop(N,St) when N > 0  -> [_|Xs]  = St, drop(N-1,Xs);
drop(_,St) -> St.


% 2)c)
subst(_,_, St) when length(St) == 0 -> [];
subst (Old, New, St) -> 
        case init(Old,St) of
            true -> New ++ drop(length(Old), St);
            false -> [X|Xs] = St, [X] ++ subst(Old,New,Xs)
        end.

%2)d)
% To replace all occurances of Old with New I would change the true case to also recall the subst function with the 
% new string as St with the same values for New and Old, this would then search for the next occurance of old as the previous one would
% have already been replaced.

% To replace the last occurance I think I would first reverse all the inputs to the function subst, carry out the same function and then
% reverse the result, This should work as long as you reverse all the inputs.


% 3)a)
isxwin([X|_]) when X =/= x -> false;
isxwin([_|Xs]) -> isxwin(Xs);
isxwin([]) -> true.

% My own function to check if o won in a row
isowin([X|_]) when X =/= o -> false;
isowin([_|Xs]) -> isowin(Xs);
isowin([]) -> true.

% 3)b)
linexwin([X|[]]) -> isxwin(X);
linexwin([X|Xs]) ->
    case isxwin(X) of 
        true -> true;
        false -> linexwin(Xs)
    end.

% 3)c)
pick(0,[X|_]) -> X;
pick(N, [_|Xs]) -> pick(N-1,Xs).


% My own function, gets the column given by N eg. 0 1 2
getcol(N,X) ->  lists:map(fun(Y) -> pick(N,Y) end,X).


% 3)d) 
wincol(X) -> N=2, wincol(N,X).
wincol(0,X) -> isxwin(getcol(0,X)) or isowin(getcol(0,X));
wincol(N,X) -> 
    case isxwin(getcol(N,X)) or isowin(getcol(N,X)) of 
        true -> true;
        false -> wincol(N-1,X)
end.