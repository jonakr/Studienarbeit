% this is a helper script to create the setup struct via excel tables

% load tables
timeDomain = table2struct(readtable('timeDomainVariables.xlsx', 'Sheet',1));
frequencyDomain = table2struct(readtable('timeDomainVariables.xlsx', 'Sheet',2));
nonlinear = table2struct(readtable('timeDomainVariables.xlsx', 'Sheet',3));
% create struct
variablesStruct = struct('timeDomain', timeDomain, 'frequencyDomain', frequencyDomain, 'nonlinear', nonlinear);
% save as setup
save('setup.mat', 'variablesStruct');