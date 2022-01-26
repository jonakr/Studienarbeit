classdef WithoutSamplesParser

    properties
        path
        data
    end

    methods
        function obj = WithoutSamplesParser(path2file)
            obj.path = path2file;

            

            obj.data = load(path2file);
        end
    end
end