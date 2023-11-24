%%% Alex Chalard Jan 2019
%%% Return all Subdir path

function [ListF,Folder] = ListFSubDir(Path,Tag)
rawListF = subdir(Path);
c=1;
ListF = {};
Folder = {};
for n = 1 : numel(rawListF)
    if contains(rawListF(n).name,Tag)
        ListF{c}    = rawListF(n).name;
        Folder{c}   = rawListF(n).folder;
        c=c+1;
    end
end
end
