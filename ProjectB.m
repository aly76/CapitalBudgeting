%Alan Ly 
%Capital budgeting - Project B 

clear all 
clc 

format bank 

r = 0.1; %Discount rate
initial = 1000*[-150 -4000 -350 -400 -300 -250 2000]; %Initial outlay

%Cash flow for each year
y1 = 1000*[-15 800];
y2 = 1000*[-15 800];
y3 = 1000*[-15 800]; 
y4 = 1000*[-15 800];
y5 = 1000*[-15 800];
y6 = 1000*[-15 800]; 
y7 = 1000*[-15 3000 800]; 
y8 = 1000*[-22 800]; 
y9 = 1000*[-22 800]; 
y10 = 1000*[-22 800];
y11 = 1000*[-22 800];
y12 = 1000*[-22 800];

%Insert arguments into cBudget, a custom-made function for calculating NPV, BCR and EAA.
%For more information on cBudget, call 'help cBudget' in the command window.
[npv, bcr, eaa, pvb, pvc] = cBudget(r, initial, y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12)

%%
%Solve for the internal rate of return numerically
syms r
z = 1 + r; 
irr = vpasolve( sum(y1)*z^-1 + sum(y2)*z^-2 + sum(y3)*z^-3 + sum(y4)*z^-4 + sum(y5)*z^-5 ...
    + sum(y6)*z^-6 + sum(y7)*z^-7 + sum(y8)*z^-8 + sum(y9)*z^-9 + sum(y10)*z^-10 ...
    + sum(y11)*z^-11 + sum(y12)*z^-12 + sum(initial) == 0, r, [0 1]) %Specify a range for IRR that makes sense i.e. 0->1

%%
%Cash flow diagram
years = {'2018';'2019';'2020';'2021';'2022';'2023';'2024';'2025';'2026';'2027';'2028';'2029';'2030'};
yFormat = 'yyyy';
serialY = datenum(years,yFormat); %Convert years to serial date numbers

cfAmounts = NaN(7,13); %Columns represent years, and rows repesent cash flows for that year.

%Insert cash flows into matrix.
cfAmounts(:,1) = initial;
cfAmounts(1:2,2) = y1;
cfAmounts(1:2,3) = y2; 
cfAmounts(1:2,4) = y3;
cfAmounts(1:2,5) = y4;
cfAmounts(1:2,6) = y5;
cfAmounts(1:2,7) = y6;
cfAmounts(1:3,8) = y7; 
cfAmounts(1:2,9) = y8; 
cfAmounts(1:2,10) = y9; 
cfAmounts(1:2,11) = y10; 
cfAmounts(1:2,12) = y11; 
cfAmounts(1:2,13) = y12;

cfDates = NaN(7,13); 

%Insert serial date numbers into matrix. 
cfDates(:,1) = serialY(1);
cfDates(1:2,2) =  serialY(2); 
cfDates(1:2,3) = serialY(3); 
cfDates(1:2,4) = serialY(4);
cfDates(1:2,5) = serialY(5);
cfDates(1:2,6) = serialY(6);
cfDates(1:2,7) = serialY(7);
cfDates(1:3,8) = serialY(8); 
cfDates(1:2,9) = serialY(9);
cfDates(1:2,10) = serialY(10);
cfDates(1:2,11) = serialY(11);
cfDates(1:2,12) = serialY(12); 
cfDates(1:2,13) = serialY(13);  

%Plot cash flow diagram
% cfplot(cfDates, cfAmounts, 'Groups', {[1:7]}, 'ShowAmnt', 1, 'DateFormat', 10, 'DateSpacing', 100, 'Stacked', 1);
% title('Cash flow - Project B', 'FontSize', 26);
% xlabel('Years', 'FontSize', 18);
% ylabel('Cash In/Out', 'FontSize', 18);

%%
%Payback period
netCashFlow = [sum(y1) sum(y2) sum(y3) sum(y4) sum(y5) sum(y6) sum(y7) sum(y8) sum(y9) sum(y10) sum(y11) sum(y12)]; %Net cash flow for each year
cumCashFlow = cumsum(netCashFlow); %Cumulative sum of net cash flows
pp = find(cumCashFlow > abs(sum(initial)),1); %Find the index of the year in which the initial outlay is fully recovered
pp = pp - 1 + ((abs(sum(initial)) - cumCashFlow(1,pp-1))/netCashFlow(1,pp)) %Payback period = years before full recovery + (Unrecovered cost at start of the year)/(Cash flow during the year)

%%
% Plot of NPV against discount rate
x = 0:0.001:1;
h = @(x) sum(y1)*(1+x).^-1 + sum(y2)*(1+x).^-2 + sum(y3)*(1+x).^-3 + sum(y4)*(1+x).^-4 + sum(y5)*(1+x).^-5 ...
    + sum(y6)*(1+x).^-6 + sum(y7)*(1+x).^-7 + sum(y8)*(1+x).^-8 + sum(y9)*(1+x).^-9 + sum(y10)*(1+x).^-10 ...
    + sum(y11)*(1+x).^-11 + sum(y12)*(1+x).^-12 + sum(initial);
figure(2)
plot(x,h(x))
legend('Project A', 'Project B');
line([0 1], [0 1], 'Color', 'k', 'LineStyle', '--')

plot(0.258, 0, 'x', 'MarkerSize', 16, 'MarkerFaceColor','k')
plot(0.173, 0, 'x', 'MarkerSize', 16, 'MarkerFaceColor','r')
