function guess(a,b)

% GUESS ....... guessing game.
%
%     GUESS(A,B) given certain information of a person (age, height or
%		weight as specified by the input argument A),  you are asked 
%		to guess the other piece of information as specified by the 
%		input argument B for the same person.  Valid options for the
%		input arguments A and B are:
%
%			'age'		'height'	'weight'
%
%		You score a correct guess if:
%		    1) true weight and your guess is within +/- 5 kg.
%		    2) true height and your guess is within +/- 5 cm.
%		    3) true age and your guess is within +/- 2 year.

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

n = 1000;
x = person_data(n);
score = [0 0];
if (strcmp(a,'age') & strcmp(b,'height'))
  y1 = x(:,1);
  y2 = x(:,2);
  for k = 1:n
    number = fix(rand(1)*n + 0.5);
    fprintf('\n The age is %4.0f.',y1(number));
    pred = input(' Guess the height [in cm] = ');
    if(pred<=y2(number)+5 & pred >=y2(number)-5)
	  fprintf('\n Congratulations! you have a correct guess.\n\n');
	  score(1) = score(1) + 1;
    else
	  fprintf('\n Sorry! your guess is incorrect.\n\n');
	  score(2) = score(2) +1;
    end
    fprintf('TOTAL SCORE:\n');
    fprintf('Number of correct guesses   = %4.0f\n',score(1));
    fprintf('Number of incorrect guesses = %4.0f\n',score(2));
yes = input('To continue to play, hit RETURN. To terminate, type TERM = ','s'); 
    if strcmp(yes,'TERM') break; end
  end
elseif (strcmp(a,'age') & strcmp(b,'weight'))
  y1 = x(:,1);
  y2 = x(:,3);
  for k = 1:n
    number = fix(rand(1)*n + 0.5);
    fprintf('\n The age is %4.0f.',y1(number));
    pred = input('Guess the weight [in kg] = ');
    if(pred<=y2(number)+5 & pred >=y2(number)-5)
	  fprintf('C\n ongratulation! you have a correct guess.\n\n');
	  score(1) = score(1) + 1;
    else
	  fprintf('\n Sorry! your guess is incorrect.\n\n');
	  score(2) = score(2) +1;
    end
    fprintf('TOTAL SCORE:\n');
    fprintf('Number of correct guesses   = %4.0f\n',score(1));
    fprintf('Number of incorrect guesses = %4.0f\n',score(2));
yes = input('To continue to play, hit return. To terminate, type TERM = ','s'); 
    if strcmp(yes,'TERM') break; end
  end
elseif (strcmp(a,'weight') & strcmp(b,'age'))
  y1 = x(:,3);
  y2 = x(:,1);
  for k = 1:n
    number = fix(rand(1)*n + 0.5);
    fprintf('\n The weight is %4.0f kg.',y1(number));
    pred = input('Guess the age = ');
    if(pred<=y2(number)+2 & pred >=y2(number)-2)
	  fprintf('\n Congratulations! you have a correct guess.\n\n');
	  score(1) = score(1) + 1;
    else
	  fprintf('\n Sorry! your guess is incorrect.\n\n');
	  score(2) = score(2) +1;
    end
    fprintf('TOTAL SCORE:\n');
    fprintf('Number of correct guesses   = %4.0f\n',score(1));
    fprintf('Number of incorrect guesses = %4.0f\n',score(2));
yes = input('To continue to play, hit return. To terminate, type TERM = ','s'); 
    if strcmp(yes,'TERM') break; end
  end
elseif (strcmp(a,'weight') & strcmp(b,'height'))
  y1 = x(:,3);
  y2 = x(:,2);
  for k = 1:n
    number = fix(rand(1)*n + 0.5);
    fprintf('\n The weight is %4.0f kg.',y1(number));
    pred = input('Guess the height [in cm] = ');
    if(pred<=y2(number)+5 & pred >=y2(number)-5)
	  fprintf('\n Congratulations! you have a correct guess.\n\n');
	  score(1) = score(1) + 1;
    else
	  fprintf('\n Sorry! your guess is incorrect.\n\n');
	  score(2) = score(2) +1;
    end
    fprintf('TOTAL SCORE:\n');
    fprintf('Number of correct guesses   = %4.0f\n',score(1));
    fprintf('number of incorrect guesses = %4.0f\n',score(2));
yes = input('To continue to play, hit return. To terminate, type TERM = ','s'); 
    if strcmp(yes,'TERM') break; end
  end
elseif (strcmp(a,'height') & strcmp(b,'age'))
  y1 = x(:,2);
  y2 = x(:,1);
  for k = 1:n
    number = fix(rand(1)*n + 0.5);
    fprintf('\n The height is %4.0f cm.',y1(number));
    pred = input('Guess the age = ');
    if(pred<=y2(number)+2 & pred >=y2(number)-2)
	  fprintf('\n Congratulations! you have a correct guess.\n\n');
	  score(1) = score(1) + 1;
    else
	  fprintf('\n Sorry! your guess is incorrect.\n\n');
	  score(2) = score(2) +1;
    end
    fprintf('TOTAL SCORE:\n');
    fprintf('Number of correct guesses   = %4.0f\n',score(1));
    fprintf('number of incorrect guesses = %4.0f\n',score(2));
yes = input('To continue to play, hit return. To terminate, type TERM = ','s'); 
    if strcmp(yes,'TERM') break; end
  end
elseif (strcmp(a,'height') & strcmp(b,'weight'))
  y1 = x(:,2);
  y2 = x(:,3);
  for k = 1:n
    number = fix(rand(1)*n + 0.5);
    fprintf('\n The height is %4.0f cm.',y1(number));
    pred = input('Guess the weight [in kg] = ');
    if(pred<=y2(number)+5 & pred >=y2(number)-5)
	  fprintf('\n Congratulations! you have a correct guess.\n\n');
	  score(1) = score(1) + 1;
    else
	  fprintf('\n Sorry! your guess is incorrect.\n\n');
	  score(2) = score(2) +1;
    end
    fprintf('TOTAL SCORE:\n');
    fprintf('Number of correct guesses   = %4.0f\n',score(1));
    fprintf('Number of incorrect guesses = %4.0f\n',score(2));
yes = input('To continue to play, hit return. To terminate, type TERM = ','s'); 
    if strcmp(yes,'TERM') break; end
  end
end
