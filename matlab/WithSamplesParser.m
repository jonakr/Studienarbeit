classdef WithSamplesParser

    properties
        path
        data
        sampleLength
        minutesArray
    end

    methods
        function obj = WithSamplesParser(path2file)
            obj.path = path2file;
            obj.data = load(path2file);

            obj = obj.adjustFrequencyData();

            % calculate the length of a single sample
            obj.sampleLength = floor((obj.data.Res.CNT.Length / 60) ...
                / obj.data.Res.HRV.Param.Nbr_Segment);

            obj.minutesArray = obj.sampleLength:obj.sampleLength: ...
            obj.data.Res.HRV.Param.Nbr_Segment * obj.sampleLength;
        end

        function plotToAxes(obj, setup, UIAxes, selectedVar)
            idx = find(setup.result.short == selectedVar);
            
            index = setup.result.index(idx);
            description = setup.result.description(idx);
            unit = setup.result.unit(idx);
            type = setup.result.type(idx);

            % plot data and adjust axis
            scatter(UIAxes, obj.minutesArray, obj.data.Res.HRV.(type).(index), ...
                                                'MarkerEdgeColor',[0 .5 .5],...
                                                'MarkerFaceColor',[0 .7 .7],...
                                                'LineWidth',1.5);
            UIAxes.Title.String = selectedVar;
            UIAxes.Subtitle.String = description;
            UIAxes.YLabel.String = unit;
            UIAxes.XLabel.String = 'minutes';

        end

        function obj = adjustFrequencyData(obj)
            % adjust the frequency struct to match plotting scheme
            % warning! this deletes the other measurements if not copied
            % TODO: find better solution
            
            % safe the table contents
            nonlinearData = obj.data.Res.HRV.NonLinear;
            frequencyData = obj.data.Res.HRV.Frequency;
            statisticsData = obj.data.Res.HRV.Statistics;

            % create empty tables for our new, filtered data
            LFHFpower = double.empty(length(frequencyData), 0);
            DFAalpha1 = double.empty(length(nonlinearData), 0);
            RMSSD = double.empty(length(statisticsData), 0);
            StressIndex = double.empty(length(statisticsData), 0);
            
            for idx = 1:length(frequencyData)
                LFHFpower(idx) = frequencyData(idx).Welch.('LF_HF_power');
                DFAalpha1(idx) = nonlinearData(idx).DFA.('alpha1');
                % convert to milliseconds
                RMSSD(idx) = statisticsData(idx).('RMSSD') * 100;
                StressIndex(idx) = statisticsData(idx).('SI');
            end

            obj.data.Res.HRV.Frequency = struct('LF_HF_power', LFHFpower);
            obj.data.Res.HRV.NonLinear = struct('DFA_alpha1', DFAalpha1);
            obj.data.Res.HRV.Statistics = struct('RMSSD', RMSSD, 'SI', StressIndex);

            % add new content to maintain completeness of data
            obj.data.Res.HRV.oldFrequency = frequencyData;
            obj.data.Res.HRV.oldNonLinear = nonlinearData;
            obj.data.Res.HRV.oldStatistics = statisticsData;
        end
    end
end