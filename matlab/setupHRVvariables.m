% this file contains HRV variables mapping
% it matches a given measurement variable with a description, measuring
% unit, etc.

function setup = setupHRVvariables()
    if ~isfile('setup.mat')
        
        result = struct( ...
            'index', ["PNSindex", "SNSindex", "mean_RR", "mean_HR"], ...
            'short', ["PNS index", "SNS index", "Mean RR", "Mean HR"], ...
            'description', ["Parasympathetic nervous system tone index", ...
                "Sympathetic nervous system tone index", ...
                "Mean of RR intervals", "Mean heart rate"], ...
            'unit', ["index", "index", "ms", "ms"] ...
        );
        
        save('setup.mat','result');

        disp('setup file created')
    end

    setup = load('setup.mat');
    disp('setup file loaded')
end