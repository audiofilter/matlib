function newpath=reorder_path(keyword)

P=strread(path,'%s','delimiter',':');
match=[];
for k=1:length(P)
	if	~isempty(findstr(P{k},keyword))
		match=[match, k];
	end;
end;
newpath={};
for k=match
	newpath=[newpath, {[P{k} ':']}];
end;
for k=setdiff(1:length(P),match)
	newpath=[newpath, {[P{k} ':']}];
end;
newpath=strcat(newpath{:});
newpath=newpath(1:end-1);
