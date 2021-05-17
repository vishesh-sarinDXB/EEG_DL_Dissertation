function pred_label = OPTICAL_plus(train_data,class_train,test_data,class_test,Fs,WindowSize,r)
% Fs - sampling frequency
% train_data - channels x sample_points x n_samples
% test_data - channels x sample_points x m_samples

%*************************************************************************
%**************************************************************************

order = 8;
[AA,BB] = butter(order/2,[8 30]/(Fs/2)); % [7 30]
% r = 3;

%**************************************************************************

Train_data = train_data;
Target_Train = class_train;
Test_data = test_data;
Target_Test = class_test;

Gbest = get_optimized_par(10, 3, 35,0, Train_data, Target_Train); 
[AA,BB] = butter(round(Gbest(3)),[Gbest(1) Gbest(2)]/(Fs/2));


for i=1:length(Target_Train)
	Train_data(:,:,i) = filter(AA,BB,Train_data(:,:,i)')';
end

for i=1:size(Test_data,3)
	Test_data(:,:,i) = filter(AA,BB,Test_data(:,:,i)')';
end

Target_Train = Target_Train(sum(sum(isnan(Train_data)))==0);

Train_data = Train_data(:,:,sum(sum(isnan(Train_data)))==0);
	
WS = 128;
OL = 24;
Nwpt = (WindowSize-WS)/OL;
for i = 1:length(Target_Train)
	for j = 1:Nwpt
		Train_data1(:,:,(i-1)*Nwpt+j) = Train_data(:,(j-1)*OL+1:(j-1)*OL+WS,i);
		Target_Train1((i-1)*Nwpt+j) = Target_Train(i);
	end
end

for i = 1:size(Test_data,3)
	for j = 1:Nwpt
		Test_data1(:,:,(i-1)*Nwpt+j) = Test_data(:,(j-1)*OL+1:(j-1)*OL+WS,i);
		Target_Test1((i-1)*Nwpt+j) = Target_Test(i);
	end
end

[Z, Wcsp] = CSP(Train_data1,Target_Train1',r);
Wcsp_1 = Wcsp;
[Z1, Wcsp1] = CSP(Train_data,Target_Train',r);
Wcsp_2 = Wcsp1;

for i = 1:1:size(Z,3)
	var1 = var(Z(:,:,i)');
	F(i,:) = log(var1);%./log(sum(var1));
end

for i = 1:1:size(Z1,3)
	var1 = var(Z1(:,:,i)');
	F1(i,:) = log(var1./sum(var1));
end

for i = 1:1:size(Target_Test1,2)
	Z_Test(:,:,i) = Wcsp*Test_data1(:,:,i); % Z - csp transformed data
	var1 = var(Z_Test(:,:,i)');
	F_Test(i,:) = log(var1);   
end
F_Test_1 = F_Test;

for i = 1:1:size(Test_data,3)
	Z1_Test(:,:,i) = Wcsp1*real(Test_data(:,:,i)); % Z - csp transformed data
	var1 = var(Z1_Test(:,:,i)');
	F1_Test(i,:) = log(var1./sum(var1));
end
F_Test_2 = F1_Test;

F(isnan(F)) = 1E-3;
F1(isnan(F1)) = 1E-3;

[y2, Wlda2] = LDA(F1,Target_Train',2);
y2_1 = y2;
y2_Test = Wlda2'*F1_Test';
y2_Test_1 = y2_Test;

for i = 1:length(Target_Train)
	FF_Train{i,1} = F((i-1)*Nwpt+1:i*Nwpt,:)';
end

for i = 1:size(Test_data,3)
	FF_Test{i,1} = F_Test((i-1)*Nwpt+1:i*Nwpt,:)';
end

inputSize = size(F,2);
numHiddenUnits = 100;
maxEpochs = 100;
miniBatchSize = 18;

options = trainingOptions('sgdm', ...
'ExecutionEnvironment','cpu', ...
'MaxEpochs',maxEpochs, ...
'MiniBatchSize',miniBatchSize, ...
'GradientThreshold',1, ...
'Verbose',0);


numResponses = 1;
layers = [ ...
sequenceInputLayer(inputSize)
lstmLayer(numHiddenUnits,'OutputMode','sequence')
lstmLayer(18,'OutputMode','last')
fullyConnectedLayer(numResponses)
regressionLayer];

net = trainNetwork(FF_Train,Target_Train',layers,options);

p1 = predict(net,FF_Train,'MiniBatchSize',miniBatchSize);
MODEL=fitcsvm([p1 y2],Target_Train','Solver','L1QP');
p2 = predict(net,FF_Test,'MiniBatchSize',1);
pred_label = predict(MODEL,[p2 y2_Test']);
