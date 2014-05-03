function x = person_data(in)

% PERSON_DATA .... Age, height, weight profile generation.
%
%     X = PERSON_DATA(N) generates records of N persons between the ages of
%		20 to 50.  Each record contains the age, the height (in cm),
%		and the weight (in kg) of one person stored in one row of the
%		output matrix X.  The first column of X stores the age, the
%     		second column stores the height, and the third column stores 
%		the height.

%	AUTHORS : M. Zeytinoglu & N. W. Ma
%             Department of Electrical & Computer Engineering
%             Ryerson Polytechnic University
%             Toronto, Ontario, CANADA
%
%	DATE    : August 1991.
%	VERSION : 1.0

%===========================================================================
% Modifications history:
% ----------------------
%	o	Tested (and modified) under MATLAB 4.0/4.1 08.16.1993 MZ
%===========================================================================

age = fix(rand(in,1)*30+20.5);
height = fix(randn(in,1)*12+168);
height(height<150) = 150 + randn(sum(height<150),1)*3;
weight = fix((height-168)*1.1 +64 + randn(in,1)*6+2);
weight(weight<45) = 45 + randn(sum(weight<45),1)*2;
weight(age>=35) = fix(weight(age>=35) + randn(sum(age>=35),1)*1+3);
weight(age>=40) = fix(weight(age>=40) + randn(sum(age>=40),1)*2+4);
weight(age>=45) = fix(weight(age>=45) + randn(sum(age>=45),1)*2+5);
x = [age height weight];
