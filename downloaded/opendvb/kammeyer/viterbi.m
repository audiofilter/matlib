% ##############################################################################
% ##  Viterbi-Algorithmus zur Decodierung von Faltungscodes                   ##
% ##############################################################################
%
%  Syntax: x_hat = viterbi(y,trellis,r_flag,term,ddepth,demo,La,EsN0)
%  benoetigt:
%  communication toolbox: de2bi.m
%
%--------------------------------------------------------------------------
%  Eingangsparameter
%        y      : Empfangsvektor (reelle Werte, nicht komplex!)
%        trellis: Struct mit Komponenten .next, .pre und .out (s. make_trellis)
%   r_flag : binaeres flag
%        0: nicht-rekursiver Code
%         >0: rekursiver Code mit g(r_flag,:) als rekursives Polynom
%   term   : binaeres flag
%        1: terminierter Faltungscode
%        0: keine Terminierung
%   ddepth : Entscheidungstiefe, default: ddepth==N_total
%   demo   : demo==1: Nach jedem Trellisuebergang wird Trellisdiagramm
%                     ausgegeben
%   La     : a-priori-Information pro Informationsbit
%   EsN0   : Signal-Rausch-Verhaeltnis auf dem Kanal, linearer Wert (kein dB!)
%
%  Ausgangsparameter
%        x_hat:  decodierter Datenstrom
%
% ------------------------------------------------------------------------------
function x_hat = viterbi(y,trellis,r_flag,term,ddepth,demo,La,EsN0)

if (nargin<2)
  error('Nicht genuegend Eingangsargumente!')
end

if (nargin<3)
  r_flag = 0;
end

if (nargin<4)
  term = 0;
end

if (nargin<6)
  demo = 0;
end

if (nargin<8)
  EsN0 = 1;
end

[anz_states,h] = size(trellis.out);
n              = ceil(log2(max(max(trellis.out))));

N_total        = length(y) / n;               % Anzahl Codeworte im Block
y              = reshape(y(:),n,N_total);

if ((nargin<5) | (ddepth>N_total))
  ddepth = N_total;
end

code_words     = 1 - 2 * de2bi([0:2^n-1]',n); % alle moeglichen Codeworte 
%                                               (antipodal)

inf            = 10^6;


if (nargin<7)
  La = zeros(N_total,1);
elseif (length(La)~=N_total)
  error(['Laenge der a-priori-Information entspricht nicht der ',...
         'Anzahl der Codeworte!']);
end

% Initialisierung
metric_sum  = -inf*ones(anz_states,1);    % Summenmetrik fuer jeden Zustand
path_state  = zeros(anz_states,N_total);  % Matrix enthaelt beste Vorzustaende
%                                           fuer alle Zustaende und Zeitpunkte
if r_flag
  path_bit = zeros(anz_states,N_total);  % geschaetzte Infobit fuer jeden
  %                                        Zustandsuebergang in path_state
else
  path_bit = zeros(anz_states,N_total);  % Zustaende 1:anz_states/2 nur mit 
  %                                        Infobit=0 erreichbar
  path_bit(2:2:anz_states,:) = 1;        % Zustaende anz_states/2:anz_states
  %                                        nur mit Infobit=1 erreichbar
end
x_hat = zeros(N_total,1);                 % entschiedene Infobit


% Berechnen der Summenmetriken und speichern des lokal besten Pfades
metric_sum(1,1) = 0;                      % Starten im Nullzustand fuer time=0

for time=1:N_total

  % Korrelation mit allen moeglichen Codeworten
  korr = code_words * y(:,time) * EsN0;

  % Summenmetriken fuer jeden Ausgangszustand bei info = 0
  metric0 = metric_sum + La(time)*ones(anz_states,1) + korr(trellis.out(:,1)+1);
  % Summenmetriken fuer jeden Ausgangszustand bei info = 1
  metric1 = metric_sum - La(time)*ones(anz_states,1) + korr(trellis.out(:,2)+1);

  if r_flag

    metric_sum(trellis.next(:,1)+1)       = metric0;                 % info = 0
    path_state(trellis.next(:,1)+1, time) = [1:anz_states]';

    u = find(metric1 > metric_sum(trellis.next(:,2)+1));             
    % Suche fuer info = 1 bessere Pfade
    if ~isempty(u)
      metric_sum(trellis.next(u,2)+1)       = metric1(u);
      path_state(trellis.next(u,2)+1, time) = u;
      path_bit(trellis.next(u,2)+1, time)   = 1;
    end

  else    % nicht-rekursive Codes

    for state = 1:anz_states/2
      [metric_sum(2*state-1),u]  = max(metric0(trellis.pre(2*state-1,:)+1)); 
      % info = 0
      path_state(2*state-1,time) = trellis.pre(2*state-1,u) + 1 ;

      [metric_sum(2*state),u]    = max(metric1(trellis.pre(2*state,:)+1)); 
      % info = 1
      path_state(2*state,time)   = trellis.pre(2*state,u) + 1;
    end
  end

  % Entscheidungstiefe erreicht --> Infobit decodieren
  if (time>ddepth)
    [tmp,u] = max(metric_sum);                   % bestimme besten Endzustand
    survivor = min(u);
    for i = time:-1:time-ddepth+1
      survivor = path_state(survivor,i);
    end
    x_hat(time-ddepth) = path_bit(survivor,time-ddepth);
  end

  if demo
    metrics.metric_sum  = metric_sum;
    metrics.metric0     = metric0;
    metrics.metric1     = metric1;
    show_trellis(trellis,N_total,path_state(:,1:time)-1,metrics,0,ddepth,x_hat);
    pause
  end

end % for time=1:N_total

% Bestimme Ueberlebenspfade
if term > 0                               % Terminierter Faltungscode
  survivor = 1;
else
  [tmp,u] = max(metric_sum);             % bestimme besten Endzustand
  survivor = min(u);
end

% Bestimmung der restlichen Informationsbit

x_hat(N_total) = path_bit(survivor,N_total);

for time = N_total-1:-1:N_total-ddepth+1
  survivor    = path_state(survivor,time+1);
  x_hat(time) = path_bit(survivor,time);
end

% Ausgabe des Survivor bei bekanntem Endzustand
if (demo & term)
  metrics.metric_sum  = metric_sum;
  metrics.metric0     = metric0;
  metrics.metric1     = metric1;
  show_trellis(trellis,N_total,path_state-1,metrics,term,ddepth,x_hat);
end

% ### EOF ######################################################################
