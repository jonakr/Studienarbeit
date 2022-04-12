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

            obj = obj.adjustData();

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

        function obj = adjustData(obj)
            % adjust the different data structs to match plotting scheme
            % warning! this deletes the other measurements if not copied
       
            % adjust statistics data
            obj.data.Res.HRV.Statistics = tableConverter(obj.data.Res.HRV.Statistics);

            % adjust frequency data
            obj.data.Res.HRV.Frequency = struct( ...
                'Welch', nestedTableConverter(obj.data.Res.HRV.Frequency, 'Welch', {'F', 'PSD'}), ...
                'AR', nestedTableConverter(obj.data.Res.HRV.Frequency, 'AR', {'F', 'PSD', 'PSD_comp', 'PSD_comp_pow'}));            
            
            %adjust nonlinear data
            % clean data that isnt nested
            notNested = rmfield(obj.data.Res.HRV.NonLinear, {'MSE', 'DFA', 'CorDim', 'RPA', 'EnoughData'});
            cleanNotNested = tableConverter(notNested);
            % get nested DFA data
            cleanDFA = nestedTableConverter(obj.data.Res.HRV.NonLinear, 'DFA', {'N1', 'N2', 'xdata', 'ydata', 'th'});
            % get nested CorDim data
            cleanCorDim = nestedTableConverter(obj.data.Res.HRV.NonLinear, 'CorDim', {'log_r', 'log_C', 'th'}); 
            % get nested RPA data
            cleanRPA = nestedTableConverter(obj.data.Res.HRV.NonLinear, 'RPA', {'RP', 'Lhist'});
            names = [fieldnames(cleanNotNested); fieldnames(cleanDFA); fieldnames(cleanCorDim); fieldnames(cleanRPA)];
            obj.data.Res.HRV.NonLinear = cell2struct([struct2cell(cleanNotNested); ...
                struct2cell(cleanDFA); struct2cell(cleanCorDim); struct2cell(cleanRPA)], names, 1);

        end
    end
end