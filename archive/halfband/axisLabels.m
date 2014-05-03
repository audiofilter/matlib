function s = axisLabels(range,incr)
%function s = axisLabels(range,incr)
len=0;
for i=1:incr:length(range)
 s=sprintf('%g',range(i));
 if length(s)>len
    len=length(s);
    end
end
fmt=['%' sprintf('%d',len) 'g'];
blank = ' ';
s = blank(ones(length(range),len));
for i=1:incr:length(range)
 s(i,:) = sprintf(fmt,range(i));
 end
