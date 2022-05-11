% get id of the given variable in the data structure
idx = find(ismember({setuplink(:).index}, selectedVar));

% get all associated informations
short = setuplink(idx).short;
description = setuplink(idx).description;
unit = setuplink(idx).unit;