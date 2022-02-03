classdef WithoutSamplesParser

    properties
        path
        data
    end

    methods
        function obj = WithoutSamplesParser(path2file)
            obj.path = path2file;
            obj.data = load(path2file);

            obj = obj.adjustFrequencyData();
        end

        function plotToAxes(obj, setup, UIAxes, selectedVar)
            idx = find(setup.result.short == selectedVar);
            
            index = setup.result.index(idx);
            description = setup.result.description(idx);
            unit = setup.result.unit(idx);
            type = setup.result.type(idx);

            plot(UIAxes, obj.data.Res.HRV.(type).(index));
            UIAxes.Title.String = selectedVar;
            UIAxes.Subtitle.String = description;
            UIAxes.YLabel.String = unit;
            UIAxes.XLabel.String = 'time in min';
        end

        function obj = adjustFrequencyData(obj)
            % adjust the frequency struct to match plotting scheme
            % warning! this deletes the other measurements if not copied
            % TODO: adjust scheme of every variable
            
            frequencyData = obj.data.Res.HRV.Frequency;
            LFHFpower = double.empty(length(frequencyData), 0);

            for idx = 1:length(frequencyData)
                LFHFpower(idx) = frequencyData(idx).Welch.('LF_HF_power');
            end
            obj.data.Res.HRV.Frequency = struct('LF_HF_power', LFHFpower);
        end
    end
end