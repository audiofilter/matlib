% ##############################################################################
% ##  conv_encoder.m : Faltunscodierer                                        ##
% ##############################################################################
%
%  function [y,last_state,x_tail] = conv_encoder(x,g,r_flag,term)
% ------------------------------------------------------------------------------
% EINGABE:
%        x:      Vektor mit binaeren Informationsbit
%        g:      Generatormatrix in binaerer oder dezimaler Form
%                 Bsp. g = [ 1 1 0 1
%                            1 0 1 1 ];
%                      entspricht g = [11;13];
%           r_flag: binaeres flag
%                       0: nicht-rekursiver Code
%                 >0: rekursiver Code mit g(r_flag,:) als rekursives Polynom
%           term:   binaeres flag
%                      1: terminierter Faltungscode
%                      0: keine Terminierung
%
%  Ausgang:
%        y         :  codierter Datenstrom
%        last_state:  Endzustand des Trellisdiagramms (optional)
%        x_tail    :  verwendete Tailbit (optional)
%
% ------------------------------------------------------------------------------
function [y,last_state,x_tail] = conv_encoder(x,g,r_flag,term)

[n,K]     = size(g);

x = x(:);
N_info = length(x);

if (K == 1)                   % dezimale Darstellung
  K = ceil(log2(max(g)));     % Ermitteln der Einflusslaenge
  g = de2bi(g,K);             % Konvertierung in binaere Darstellung
end
m = K - 1;

if r_flag>0                                          % RSC-Code
  grek        = g(r_flag,:);
  g(r_flag,:) = [];
end


% Initialisiere state-Vektor
state = zeros(1,m);

% Initialisiere Tailbit-Vektor
if (nargout==3)
  x_tail = zeros(m,1);
end

% Initialisiere Ausgangsvektoren
if term>0
  y = zeros((N_info+m)*n,1);
else
  y = zeros(N_info*n,1);
end


% Codierung
for i = 1:N_info

  if (r_flag>0)
    a_k              = grek & [x(i) state];
    a_k              = rem( sum(a_k), 2);
    reg              = [a_k state];
    y((i-1)*n+1)     = x(i);                    % systematisches Infobit
    y((i-1)*n+2:i*n) = rem(g*reg',2);
  else
    reg              = [x(i) state];
    y((i-1)*n+1:i*n) = rem(g*reg',2);
  end
  state = reg(1:m);
end

if term>0                                         % Terminierter Faltungscode
  for i=N_info+1:N_info+m

    reg = [0 state];
    if (r_flag>0)
      feedback     = rem(sum(grek & reg), 2);
      y((i-1)*n+1) = feedback;
      if (nargout==3)
        x_tail(i-N_info) = feedback;
      end
      y((i-1)*n+2:i*n) = rem(g*reg',2);
    else
      y((i-1)*n+1:i*n) = rem(g*reg',2);
    end
    state = reg(1:m);

  end
end

if (nargout>=2)
  last_state = bi2de(state);
end

% ### EOF ######################################################################
