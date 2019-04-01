function cBudgetWrapper
    try 
        cBudget([1 2 5 1], [1 ; 5 ; 7 ; 8]); 
    catch ME
        rethrow(ME);
    end 
end 