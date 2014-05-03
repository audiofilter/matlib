% ##############################################################################
% ##  show_trellis.m: Darstellung des Trellisdiagramms                        ##
% ##############################################################################
%
% Syntax:  show_trellis(trellis,max_time,path_state,metrics,term,ddepth,x_hat)
%
%--------------------------------------------------------------------------
% Eingabeparameter:
%      trellis           : Struct zur Beschreibung der Zustandsuebergaenge
%        trellis.next    : Matrix mit Folgezustaenden
%                          (erste Spalte fuer info=0, zweite Spalte fuer info=1)
%                           Bsp. trellis.next = [ 0 2 0 2; 1 3 1 3 ]';
%        trellis.out     :  Matrix mit codierten Ausgangsbit
%                          (dezimale Darstellung)
%                          (erste Spalte fuer info=0, zweite Spalte fuer info=1)
%
%      max_time          : max. darzustellender Zeitbereich des Trellisdiagramms
%                               (beginnend mit time=0)
%      path_state        : Matrix mit den besten Vorzustaenden fuer jeden
%                          Zustand bis zum aktuellen Zeitpunkt (<=max_time)
%      metrics           : Struct mit aktuellen Metrikvektoren
%        metrics.sum     : beste Summenmetriken der aktuellen Zustaende
%        metrics.metric0 : Summenmetriken der Vorzustaende fuer info=0
%        metrics.metric1 : Summenmetriken der Vorzustaende fuer info=1
%      term              : binaeres Flag:
%                          term==0 --> Trellisende ist offen
%                          term==1 --> Trellis ist abgeschlossen
%      ddepth            : Entscheidungstiefe: entschiedene Zeitpunkte werden
%                          farbig hervorgehoben
%      x_hat             : geschaetzte Informationsbit
%--------------------------------------------------------------------------
function show_trellis(trellis,max_time,path_state,metrics,term,ddepth,x_hat)

if (nargin<1)
  error('Nicht genuegend Eingabeargumente!')
end

if (nargin==1)
  max_time = 1;
  demo = 0;
  [anz_states,h] = size(trellis.next);

elseif (nargin<5)
  error('Nicht genuegend Eingabeargumente!')

elseif (nargin>=5)
  demo = 1;
  [anz_states,akt_time] = size(path_state);

elseif (nargin<6)
  ddepth = akt_time;
end



n      = ceil(log2(max(max(trellis.out))));
m      = log2(anz_states);
states = [0:anz_states-1]' * ones(1,max_time+1);
vtime  = 0:max_time;


%--------------------------------------------------------------------------
% Neuzeichnen des Trellisdiagramms
%--------------------------------------------------------------------------
clf;

% Dimension des Fensters
if (anz_states <= 16)
  hoehe       = 500;
  start_hoehe = 400;
else
  hoehe       = 800;
  start_hoehe = 100;
end

if (max_time<5)
  breite = 500;
else
  breite = 1000;
end
% set(gcf,'Position',[100 start_hoehe breite hoehe]);  %
axis('off')

% Zeichne Zustaende
figure(1)
hold on
for state=1:anz_states
  plot(vtime,states(state,:),'ko');
end

% Beschriftung der Zustaende
axis([0 max_time+0.4 0 anz_states-1])
indent = - 0.1*max_time;

for state=1:anz_states
  text(indent, anz_states-state, ['S' int2str(state-1)] );
end


if ~demo  % Zeichnen der Zustandsuebergaenge und Ausgabe der codierten Bit
  index = zeros(anz_states,1);
  for state=1:anz_states
    state1 = anz_states - state;
    state2 = anz_states - trellis.next(state,1) - 1;    % Uebergang fuer info=0
    line(vtime,[state1,state2],'linewidth',1,'color','red');

    out = [int2str(de2bi(trellis.out(state,1),n))];
    if (state>anz_states/2)
      text(1.1,state2-0.15,out,'fontsize',9,'color','blue');
    else
      text(1.1,state2+0.15,out,'fontsize',9,'color','blue');
    end

    state2 = anz_states - trellis.next(state,2) - 1;    % Uebergang fuer info=1
    line(vtime,[state1,state2],'linestyle','--','linewidth',1,'color','red');

    out = [int2str(de2bi(trellis.out(state,2),n))];
    if (state>anz_states/2)
      text(1.1,state2-0.15,out,'fontsize',9,'color','blue');
    else
      text(1.1,state2+0.15,out,'fontsize',9,'color','blue');
    end

  end

else % if ~demo: Darstellung des Decodierablaufs im Trellisdiagramm

  path_state = [path_state [0:anz_states-1]'];

  for state=1:min(2^akt_time,anz_states)

    % Vergangenheit bis Gegenwart-1
    akt_state = state-1;
    if (2^(akt_time-1) >= state)
      for time = akt_time-1:-1:1
        vtime     = time-1:time;
        vstate    = anz_states-[path_state(akt_state+1,time) akt_state]-1;
        akt_state = path_state(akt_state+1,time);
        line(vtime,vstate,'linewidth',1,'color','black');
      end
    end

    % alternative Pfade fuer aktuellen Entscheidungsprozess
    vtime     = akt_time-1:akt_time;
    vstate    = anz_states-[path_state(state,akt_time) state-1]-1;
    line(vtime,vstate,'linewidth',1,'color','black');
    if (akt_time>m)                  % Trellis voll entwickelt  
      %                                --> 2 Alternativen an jedem Zustand
      state2 = anz_states - state;
      [h,u]  = find((trellis.pre(state,:)) ~= path_state(state,akt_time));
      state1 = anz_states - trellis.pre(state,u) - 1;
      line(vtime,[state1,state2],'linewidth',1,'color','black');
    end

    % Plot der Metriken an jedem Zustand
    if (state<=min(2^(akt_time-1),anz_states))
      if (state>anz_states/2)
        state1 = anz_states - trellis.next(state,1) - 1.1;
        state2 = anz_states - trellis.next(state,2) - 1.1;
      else
        state1 = anz_states - trellis.next(state,1) - 0.9;
        state2 = anz_states - trellis.next(state,2) - 0.9;
      end
      text(akt_time+0.3,state1,num2str(metrics.metric0(state),'%4.1f'),...
           'fontsize',8,'color','blue');
      text(akt_time+0.3,state2,num2str(metrics.metric1(state),'%4.1f'),...
           'fontsize',8,'color','blue');
    end

  end  % for state



  % Ausgabe des "Survivors"
  if ((term==1) & (akt_time==max_time))
    color = 'green';
    width = 4;
    u     = 1;
  else % temporal survivor
    color = 'red';
    width = 2;
    [h,u] =  max(metrics.metric_sum);
  end

  akt_state = u-1;
  for time = akt_time:-1:1
    if ((akt_time+1-time>ddepth) & (color(1)~='g')) 
      % Entscheidungstiefe erreicht
      color = 'yellow';
    end
    vtime     = time-1:time;
    vstate    = anz_states-[path_state(akt_state+1,time) akt_state]-1;
    akt_state = path_state(akt_state+1,time);
    line(vtime,vstate,'linewidth',width,'color',color);

    if ((nargin==7) & (color(1)~='r'))  % entschiedene Daten
      text(time-0.5,-0.5,int2str(x_hat(time)),'fontsize',10,'color','blue');
    end
  end
end % if ~demo

% ### EOF ######################################################################
