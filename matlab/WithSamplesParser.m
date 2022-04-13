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

        function plotToAxes(obj, setup, UIAxes, selectedVar, selectedGroup)
            
            if selectedGroup == "Time-Domain"
                setuplink = setup.variablesStruct.timeDomain;
                datalink = obj.data.Res.HRV.Statistics;
            elseif selectedGroup =="Frequency-Domain FFT spectrum"
                setuplink = setup.variablesStruct.frequencyDomain;
                datalink = obj.data.Res.HRV.Frequency.Welch;
            elseif selectedGroup =="Frequency-Domain AR spectrum"
                setuplink = setup.variablesStruct.frequencyDomain;
                datalink = obj.data.Res.HRV.Frequency.AR;
            elseif selectedGroup =="Nonlinear"
               setuplink = setup.variablesStruct.nonlinear;
               datalink = obj.data.Res.HRV.NonLinear;
            end

            idx = find(contains({setuplink(:).index}, selectedVar));
            
            short = setuplink(idx).short;
            description = setuplink(idx).description;
            unit = setuplink(idx).unit;
            type = setuplink(idx).type;

            % plot data and adjust axis
            scatter(UIAxes, obj.minutesArray, datalink.(selectedVar), ...
                                                'MarkerEdgeColor',[0 .5 .5],...
                                                'MarkerFaceColor',[0 .7 .7],...
                                                'LineWidth',1.5);
            UIAxes.Title.String = short;
            UIAxes.Subtitle.String = description;
            UIAxes.YLabel.String = unit;
            UIAxes.XLabel.String = 'minutes';

        end

        function obj = adjustData(obj)
            % adjust the different data structs to match plotting scheme
            % warning! this deletes the other measurements if not copied

            % TODO: fix units e.g. RMSSD needs to be milliseconds
            %       add missing variables e.g. AC DC
       
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
            % get nested MSE data
            tempMatrix = [];
            cleanMSE = struct();
            for idx = 1:length(obj.data.Res.HRV.NonLinear)
                tempMatrix = cat(1, tempMatrix, obj.data.Res.HRV.NonLinear(idx).MSE);
            end
            tempMatrix = tempMatrix';
            for id = 1:size(tempMatrix, 1)
                [cleanMSE.(['MSE' num2str(id)])] = tempMatrix(id,:);
            end
            % concat all structs
            names = [fieldnames(cleanNotNested); fieldnames(cleanDFA); fieldnames(cleanCorDim); fieldnames(cleanRPA); fieldnames(cleanMSE)];
            obj.data.Res.HRV.NonLinear = cell2struct([struct2cell(cleanNotNested); ...
                struct2cell(cleanDFA); struct2cell(cleanCorDim); struct2cell(cleanRPA); struct2cell(cleanMSE)], names, 1);

        end
    end
end