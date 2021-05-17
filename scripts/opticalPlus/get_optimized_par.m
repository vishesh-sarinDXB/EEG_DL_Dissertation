function [Gbest,Gbest_value] = get_optimized_par(Np, D, IterMax, fitnessCondition, TrainData, TargetTrain)
% tic
% input contains --> Np, D, IterMax, fitnessCondition, TrainData, TargetTrain

% Np - population size
% D - # of parameters to tune
% IterMax - maximun number of iterations
% fitnessCondition - desired fitness value
% TrainData - n x m (n - number of trials, m - number of sample points) 
% TargetTrain - n x 1

%% Problem Definition

% Np = input{1};
% D = input{2};
% IterMax = input{3};
% fitnessCondition = input{4};
% TrainData = input{5};
% TargetTrain = input{6};

% CostFunction=@(x) fitnessFunction(x);     % Cost Function

nVar = D;             % Number of Decision Variables

VarSize=[1 nVar];   % Decision Variables Matrix Size

VarMin = [0.5, 18, 1];         % Lower Bound of Variables
VarMax= [16.0, 40, 8];        % Upper Bound of Variables


%% GA Parameters

MaxIt = IterMax;        % Maximum Number of Iterations

nPop = Np;              % Population Size

pc=0.7;                 % Crossover Percentage
nc=2*round(pc*nPop/2);  % Number of Offsprings (also Parents)
gamma=0.4;              % Extra Range Factor for Crossover

pm=0.3;                 % Mutation Percentage
nm=round(pm*nPop);      % Number of Mutants
mu=0.1;                 % Mutation Rate

TournamentSize=3;   % Tournament Size

pause(0.01); % Due to a bug in older versions of MATLAB

%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];

pop=repmat(empty_individual,nPop,1);
% disp('Start')
parfor i=1:nPop
%     disp(i)
    % Initialize Position
    if i == 1
        pop(i).Position=[7, 30, 4];
    else
        pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    end
    
    
%     pop(i).Position
    % Evaluation
    pop(i).Cost = fitnessFunctionLSTM_par(pop(i).Position, TrainData, TargetTrain); 
end
% disp('Working')

% Sort Population
Costs=[pop.Cost];
[Costs, SortOrder]=sort(Costs);
pop=pop(SortOrder);

% Store Best Solution
BestSol=pop(1);

% Array to Hold Best Cost Values
BestCost=zeros(MaxIt,1);

% Store Cost
WorstCost=pop(end).Cost;

% initialization_time = toc
%% Main Loop
it = 1;

while it <= MaxIt

%     tic
    %     it
    % Calculate Selection Probabilities
%     if UseRouletteWheelSelection
%         P=exp(-beta*Costs/WorstCost);
%         P=P/sum(P);
%     end
    
    % Crossover
    popc=repmat(empty_individual,nc/2,2);
    for k=1:nc/2
        
        % Select Parents Indices
%         if UseRouletteWheelSelection
%             i1=RouletteWheelSelection(P);
%             i2=RouletteWheelSelection(P);
%         end
%         if UseTournamentSelection
            i1=TournamentSelection(pop,TournamentSize);
            i2=TournamentSelection(pop,TournamentSize);
%         end
%         if UseRandomSelection
%             i1=randi([1 nPop]);
%             i2=randi([1 nPop]);
%         end

        % Select Parents
        p1=pop(i1);
        p2=pop(i2);
        
        % Apply Crossover
%         p1.Position
%         p2.Position
%         popc(k,1).Position
%         popc(k,2).Position
        
        x1 = p1.Position;
        x2 = p2.Position;
        
        alpha=unifrnd(-gamma,1+gamma,size(x1));
    
        y1=alpha.*x1+(1-alpha).*x2;
        y2=alpha.*x2+(1-alpha).*x1;

        y1=max(y1,VarMin);
        y1=min(y1,VarMax);
        
        y2=max(y2,VarMin);
        y2=min(y2,VarMax);
    
        popc(k,1).Position = y1;
        popc(k,2).Position = y2;
%         Crossover(p1.Position,p2.Position,gamma,VarMin,VarMax)
%         [popc(k,1).Position, popc(k,2).Position]=Crossover(p1.Position,p2.Position,gamma,VarMin,VarMax);
%         popc(k,1).Position
%         popc(k,2).Position
        % Evaluate Offsprings
        
        parfor nm1 = 1:2
            popc(k,nm1).Cost= fitnessFunctionLSTM_par(popc(k,nm1).Position, TrainData, TargetTrain); 
        end
%         popc(k,1).Cost= fitnessFunction4(popc(k,1).Position, TrainData, TargetTrain); 
%         popc(k,2).Cost= fitnessFunction4(popc(k,2).Position, TrainData, TargetTrain); 
    end
    popc=popc(:);
    
    
    % Mutation
    popm=repmat(empty_individual,nm,1);
    parfor k=1:nm
        
        % Select Parent
        i=randi([1 nPop]);
        p=pop(i);
        
        % Apply Mutation
%         popm(k).Position=Mutate(p.Position,mu,VarMin,VarMax);
        
        x = p.Position;
        
        nVar=numel(x);
    
        nmu=ceil(mu*nVar);

        j=randsample(nVar,nmu);

        sigma=0.1*(VarMax-VarMin);

        y=x;
        y(j)=x(j)+sigma(j)*randn(size(j));

        y=max(y,VarMin);
        popm(k).Position=min(y,VarMax);
        
        % Evaluate Mutant
        popm(k).Cost= fitnessFunctionLSTM_par(popm(k).Position, TrainData, TargetTrain); 
        
    end
    
    % Create Merged Population
    pop=[pop
         popc
         popm]; %#ok
     
    % Sort Population
    Costs=[pop.Cost];
    [Costs, SortOrder]=sort(Costs);
    pop=pop(SortOrder);
    
    % Update Worst Cost
    WorstCost=max(WorstCost,pop(end).Cost);
    
    % Truncation
    pop=pop(1:nPop);
    Costs=Costs(1:nPop);
    
    % Store Best Solution Ever Found
    BestSol=pop(1);
    
    % Store Best Cost Ever Found
    BestCost(it)=BestSol.Cost;
    
%     time(it) = toc   
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
%     if BestSol.Cost < fitnessCondition
%         it = MaxIt;
%     end
    
    if BestSol.Cost < fitnessCondition 
        break; %it = MaxIt;
    end
	
	if it > 3 
        if abs(BestCost(it-3)-BestCost(it))<0.5
            break;
        end
    end
        
    it = it + 1;
end

Gbest = BestSol.Position;
Gbest_value = BestSol.Cost;

%% 


