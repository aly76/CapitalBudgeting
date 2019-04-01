function [npv, bcr, eaa, pvb, pvc] = cBudget (r, initial, varargin)
    %[npv, bcr, eaa] = cBudget(r, initial, y1, y2, ...) Calculates net present value (npv), benefit-cost
    %ratio (bcr) and equivalent annual annuity (eaa) for the specified discount rate (r),initial outlay
    %(initial) and yearly cash flows (y1, y2, ...).
    %The discount rate is of the form 0<r<1.
    %The initial outlay is of the form initial = [-500 100 -230 -101] i.e. a Nx1 or 1xN array of positve
    %numbers for inflows and negative numbers for outflow.
    %The yearly cash flows are of the form y1 = [100 -50 60 80 -543] i.e. a Nx1 or 1xN array of positive
    %numbers for inflows and negative numbers for outflow.
    %
    %Written by Alan Ly, 2018
    
    %%
    %Perform input validation.
    pin = inputParser; 
    pin.addRequired('discountRate', @(x) x <= 1 && x>=0);
    pin.addRequired('initialOutlay', @(x) isvector(x) && ~iscell(x) && ~ischar(x));
    pin.parse(r, initial); 
    
    if length(varargin) < 1 
            inputException = MException('cBudget:badInput', 'Please input 3 or more arguments.'); 
            throw(inputException) 
    end 
        
    for i = 1:length(varargin)
        
        if ~isvector(varargin{i}) || iscell(varargin{i}) || ischar(varargin{i})
            inputException = MException('cBudget:badInput','Input arguments must be an array of numbers.');
            throw(inputException)
        end 
      
    end 
    %%
    %NPV
    %Calculate net cash flow for each year.
    netFlow = zeros(length(varargin),1); 
    for i = 1:length(varargin)
       netFlow(i,1) = sum(varargin{i});
    end    
    
    %Generate a vector containing present worth factors for each year.
    pwFactor = zeros(length(varargin), 1); 
    for i = 1:length(varargin)
        pwFactor(i,1) = 1/(1+r)^i ;
    end 
    
    pv = netFlow.*pwFactor; %Calculate the present value of each year's net cash flow. 
    npv = sum(pv); %Sum present values of each year to obtain the net present value.
    npv = npv + sum(initial); %Offset the net present value by the initial outlay. 
    
    %%
    %BCR
    %Calculate the cash inflow for each year.
    inflow = zeros(length(varargin),1); 
    isNeg = @(x) x<0; 
    for i = 1:length(varargin)
        maskNeg = ~isNeg(varargin{i}); %Used to mask all outflows by replacing them with zero's. 
        inflow(i,1) = sum(varargin{i}.*maskNeg);
    end 
    
    %Calculate the cash outflow for each year.
    outflow = zeros(length(varargin),1); %
    isPos = @(x) x>0; 
    for i = 1:length(varargin)
        maskPos = ~isPos(varargin{i}); %Used to mask all inflows by replacing them with zero's. 
        outflow(i,1) = sum(varargin{i}.*maskPos); 
    end 
    
    
    pvb = sum(inflow.*pwFactor); %Calculate the present value of benefits (PVB) by summing the present value of cash inflows. 
    pvc = abs(sum(outflow.*pwFactor) + sum(initial)); %Calculate the present value of costs (PVC) by summing the present value of cash outflows, and 
                                                      %offsetting by the initial outay.
    bcr = pvb/pvc;  
    
    %%
    %Equivalent Annual Annuity
    eaa = r*npv/(1-(1+r)^-length(varargin)); 
    
end 
