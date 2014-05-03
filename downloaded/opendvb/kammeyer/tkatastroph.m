% ##############################################################################
% ##  tkatastroph.m: m-file zum Testen von katastrophalen Faltungscodes       ##
% ##############################################################################
%
% Syntax:  [ind,cycle] = tkatastroph(g,rek,p)
%  benoetigt: make_trellis.m
%
% Eingabeparameter:
%          g:   Generatormatrix in binaerer Form
%               Bsp. g = [ 1 1 1
%                          1 0 1 ];
%          rek: rek=0 zeigt NSC-Code an,
%               rek>0 RSC-Code mit g(rek,:) als rekursives Polynom
%          p:   Punktierungsmatrix in binaerer Form
%               Bsp. p = [ 1 1 1 0
%                          1 0 1 1]; punktiert auf Rate 2/3
%
% Ausgabeparameter:
%          ind: Indikator, ind = 1, Faltungscode ist katastrophal
%                          ind = 0, Faltungscode ist nichtkatastrophal
%          cycle: Falls ind==1, gibt cycle Zustandsfolge vom Gewicht Null an
%

function [ind, cycle] = tkatastroph(g,rek,p)

[n,K]     = size(g);
m         = K - 1;
max_state = 2^m;

if rek>0                                              % RSC-Code
  vrek = g(rek,:);
  g(rek,:) = [1 zeros(1,m)];
end

ind  = 0;
%--------------------------------------------------------------------------
% Konstruktion des Trellisdiagramms
%--------------------------------------------------------------------------
trellis = make_trellis(g,0);

trellis.next = trellis.next + 1;

%--------------------------------------------------------------------------
% Pruefe Code auf Katastrophalitaet
%--------------------------------------------------------------------------
[n_p,L_p] = size(p);

for state=2:max_state       % Schleife ueber alle Startzustaende
  %                             (ohne Nullzustand)

  for prun1 = 1:L_p         % Schleife ueber alle moeglichen Startzeitpunkte
    %                           der Punktierung

    prun2      = prun1;     % (Faltungscode mit Punktierung ist zeitvariant)
    metrik     = 0;
    data       = 0;         % Speicherung der Infobit fuer Zustandsfolge 'cycle'
    d          = 0;         % Starte mit Infobit d=0
    ende       = 0;         % keine Nullschleife fuer Anfangszustand
    %                         state gefunden
    l          = 1;
    cycle      = state;     % Speicherung der Zustandsfolge mit Gewicht Null
    akt_state  = state;
    weiter     = 1;

    while (weiter & ~ende)
      metrik = de2bi(trellis.out(akt_state,d+1),n)*p(:,prun2);
      if (metrik==0)   % Uebergang mit Gewicht 0 --> gehe Weg weiter
        data(l)    = d;
        l          = l + 1;
        akt_state  = trellis.next(akt_state,d+1);
        cycle(l)   = akt_state;
        d          = 0;
        prun2      = rem(prun2,L_p) + 1;
      else             % Uebergang mit Gewicht ~=0 --> Suche anderen Weg
        if d==0       % Uebergang mit Infobit d=1
          d = 1;
        else
          l     = l - 1;
          prun2 = prun2 - 1;
          if prun2 == 0
            prun2 = L_p;
          end
          while ( (l>0) & (data(l)==1) )   % d=1 schon probiert, gehe zurueck
            %                                  bis neuer Weg fuer d=1
            l = l - 1;
            prun2 = prun2 - 1;
            if prun2 == 0
              prun2 = L_p;
            end
          end
          if (l==0)  % alle Moeglichkeiten ohne Erfolg probiert
            ende = 1;
          else
            d         = 1;
            akt_state = cycle(l);
          end
        end
      end
      weiter = ~ismember(akt_state,cycle(1:l-1));
    end  % while
    if (ismember(akt_state,cycle(1:l)) & (metrik==0))
      ind      = 1;
      cycle(l) = akt_state;
      cycle    = cycle(1:l) - 1;

      return
    end
  end  % for prun1
end  % for state

% ### EOF ######################################################################
