
NSseries = cell2series(NScellseries,FN);
VZseries = cell2series(VZcellseries,FN);
VLATseries = cell2series(VLATcellseries,FN);
VLONseries = cell2series(VLONcellseries,FN);
%DOYseries = cell2series(DOYcellseries,FN);
monthseries = cell2series(monthcellseries,FN);
%F107series = cell2series(F107cellseries,FN);
save('NSseries.mat', 'NSseries','-v7.3');
save('VZseries.mat', 'VZseries','-v7.3');
save('VLATseries.mat', 'VLATseries','-v7.3');
save('VLONseries.mat', 'VLONseries','-v7.3');
%save('DOYseries.mat', 'DOYseries','-v7.3');
save('monthseries.mat', 'monthseries','-v7.3');
%save('F107series.mat', 'F107series','-v7.3');