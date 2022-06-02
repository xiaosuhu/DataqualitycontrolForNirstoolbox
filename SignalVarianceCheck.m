classdef SignalVarianceCheck < nirs.modules.AbstractModule
    %SIGNALVARIANCECHECK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       
    end
    
    methods
        function obj = Anti_Corr_Check(prevJob)
            obj.name = 'General Signal Variance Check';
            
            if nargin > 0
                obj.prevJob = prevJob;
            end
        end
        
        function Variance = runThis(obj,data)
            for i=1:numel(data)
                types=unique(data(i).probe.link.type);
                if numel(types)==2
                    % HbO signal
                    tI=1;
                    lsthbo=find(ismember(data(i).probe.link.type,types{tI}));
                    
                    % HbR signal
                    tI=2;
                    lsthbr=find(ismember(data(i).probe.link.type,types{tI}));
                    
                    % Correlation Calc
                    if length(lsthbo)==length(lsthbr)
                        for j=1:length(lsthbo)
                            % Varience of HbO signal
                            Variance(i,j,1)=var(data(i).data(:,lsthbo(j)));
                            % Varience of HbR signal
                            Variance(i,j,2)=var(data(i).data(:,lsthbr(j)));
                        end
                    else
                        disp('Data is missing...')
                    end
                else
                    disp('More signals are found than HbO & HbR, cannot proceed with correlation calc...')
                    return
                end
            end
            
            % Plotting part
            figure
            subplot(2,1,1)
            bar(sum(Variance(:,:,1),2));
            for i=1:size(sum(Variance(:,:,1),2),1)
                [~,name,~] = fileparts(data(i).description);
                h=text(i,sum(sum(Variance(:,:,1),2)),name);
                set(h,'Rotation',60)
            end
            
            subplot(2,1,2)
            bar(sum(Variance(:,:,2),2));
            for i=1:size(sum(Variance(:,:,2),2),1)
                [~,name,~] = fileparts(data(i).description);
                h=text(i,sum(sum(Variance(:,:,2),2)),name);
                set(h,'Rotation',60)
            end
            
            
        end
        
    end
end

