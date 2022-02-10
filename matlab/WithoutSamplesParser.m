classdef WithoutSamplesParser

    properties
        path
        data
    end

    methods
        function obj = WithoutSamplesParser(path2file)
            obj.path = path2file;

            obj.path = path2file;
            obj.data = load(path2file);
        end

        function plotToAxes(obj, setup, UIAxes, selectedVar)
            idx = find(setup.result.short == selectedVar);
            
            index = setup.result.index(idx);
            description = setup.result.description(idx);
            unit = setup.result.unit(idx);

            plot(UIAxes, obj.data.Res.HRV.TimeVar.(index));
            UIAxes.Title.String = selectedVar;
            UIAxes.Subtitle.String = description;
            UIAxes.YLabel.String = unit;
            UIAxes.XLabel.String = 'time in min';
        end
    end
end