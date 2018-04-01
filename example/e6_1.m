clc,clear,close all;
f = [119 123 168 119; 123 119 168 168];
f= [f; 119 119 107 119; 107 107 119 119];
p = hist(f(:), 8);
p = p / sum(p)
h = ntrop(f)