classdef WithoutSamplesParser

    properties
        path
        data
        datetime
    end

    methods
        function obj = WithoutSamplesParser(path2file)
            obj.path = path2file;
            obj.data = load(path2file);

            datetimeStr = [obj.data.Res.CNT.CntGen.date ' ' obj.data.Res.CNT.CntGen.time];
            obj.datetime = datetime(datetimeStr,'InputFormat','dd.MM.yy HH.mm.ss');
        end

        function plotToAxes(obj, setup, UIAxes, selectedVar)
            idx = find(setup.result.short == selectedVar);
            
            index = setup.result.index(idx);
            description = setup.result.description(idx);
            unit = setup.result.unit(idx);
            
            % create array of timestamps to match y-values
            % TODO: 60 seconds are hard coded, check if this works for
            % everything :)
            timeArray = obj.datetime:seconds(60):obj.datetime ...
                + minutes(length(obj.data.Res.HRV.TimeVar.(index)));

            plot(UIAxes, timeArray(2:end), obj.data.Res.HRV.TimeVar.(index));
            UIAxes.Title.String = selectedVar;
            UIAxes.Subtitle.String = description;
            UIAxes.YLabel.String = unit;
            UIAxes.XLabel.String = '';
            
            % configure x-Axis to start at y-Axis and tick every 3 minutes
            UIAxes.XLim = [timeArray(2) timeArray(end)];
            UIAxes.XTick = timeArray(2):minutes(3):timeArray(end);
        end
    end
end