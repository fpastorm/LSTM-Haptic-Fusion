clear;
clc;
close all;
dbstop if error;

%% Loading all the data
targetFolder = 'New_Dataset'; % 'Bayesian_and_nn'; '5T'; '3T';


Matrix_Kinema = []; Matrix_Haptic = []; Matrix_Percep = []; Solution = []; % Variables initialization

    % #Choose your own path:
    load ( 'LSTMKinesthetic.mat');
    Matrix_Kinema_Now = output;
    load ( 'LSTMtactil.mat');
    Matrix_Haptic_Now = output;
    load ('Perceptron.mat' );
    Matrix_Percep_Now = output;
%     Checking sizes are alright
    if ( size( Matrix_Kinema,1 ) ~= size( Matrix_Haptic,1 ) ) || ...
           ( size( Matrix_Kinema,2 ) ~= size( Matrix_Haptic,2 ) )
        warning('Inputs of different sizes!')
    end
    % Piling all the solutions together
    Matrix_Kinema = [ Matrix_Kinema, Matrix_Kinema_Now ];
    Matrix_Haptic = [ Matrix_Haptic, Matrix_Haptic_Now ];
    Matrix_Percep = [ Matrix_Percep, Matrix_Percep_Now ];
    % Some temporal values
    nClass = size( Matrix_Kinema_Now,1 );
    nExp = size(Matrix_Kinema_Now,2);
    nExpClass = nExp/nClass;
    % Stacking the solutions as well
    Solution = [ Solution, kron( [1:1:nClass]', ones(nExpClass,1) )' ];
    % Clearing the space
    clear Matrix_Kinema_Now Matrix_Haptic_Now output;


% Setting general values
nClass = size( Matrix_Kinema,1 );
nExp = size(Matrix_Kinema,2);
nExpClass = nExp/nClass;


%% Analysis of classification results
% Variable initialization
class_Haptic = nan( nExp,1 );
maxProb_Haptic = nan(nExp, 1);
probSuccess_Haptic = 0;
class_Kinema = nan( nExp,1 );
maxProb_Kinema = nan(nExp, 1);
probSuccess_Kinema = 0;
class_Percep = nan( nExp,1 );
maxProb_Percep = nan(nExp, 1);
probSuccess_Percep = 0;

for iExp = 1:nExp
    % Classification for tactile info
    [maxProb_Haptic(iExp), class_Haptic(iExp) ] = max( Matrix_Haptic(:,iExp) );
    if class_Haptic(iExp) == Solution(iExp), probSuccess_Haptic = probSuccess_Haptic + 1; end
    % Classification for kinematic info
    [maxProb_Kinema(iExp), class_Kinema(iExp) ] = max( Matrix_Kinema(:,iExp) );
    if class_Kinema(iExp) == Solution(iExp), probSuccess_Kinema = probSuccess_Kinema + 1; end
    % Classification for NN Fusion info
    [maxProb_Percep(iExp), class_Percep(iExp) ] = max( Matrix_Percep(:,iExp) );
    if class_Percep(iExp) == Solution(iExp), probSuccess_Percep = probSuccess_Percep + 1; end
end
    
% Success Rate
probSuccess_Haptic = probSuccess_Haptic/nExp
probSuccess_Kinema = probSuccess_Kinema/nExp
probSuccess_Percep = probSuccess_Percep/nExp
% Get confusion matrices
C_Haptic = confusionmat(Solution,class_Haptic);
C_Kinema = confusionmat(Solution,class_Kinema);
C_Percep = confusionmat(Solution,class_Percep);

%% Fusion strategies
% Variable initialization
class_Prob = nan(nExp,1);
Matrix_Prob = nan(nClass,nExp);
probSuccess_Prob = 0;
for iExp = 1:nExp
    Matrix_Prob(:,iExp) = Matrix_Haptic(:,iExp).*Matrix_Kinema(:,iExp)/(1/nClass);
    Matrix_Prob(:,iExp) = Matrix_Prob(:,iExp) /sum(Matrix_Prob(:,iExp) );
    [ ~, class_Prob(iExp,1)] = max( Matrix_Prob(:,iExp) );
    if class_Prob(iExp) == Solution(iExp), probSuccess_Prob = probSuccess_Prob + 1; end
end
% Overall Success Rate
probSuccess_Prob = probSuccess_Prob/nExp
% Confusion matrices for the fusion
C_Prob = confusionmat(Solution,class_Prob);


%% Visualization
set(groot,'defaultFigureColor','w')
set(groot,'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
set(groot,'defaultAxesFontSize',13)

% CM for Tactile-based classification
clims = [ 0, 100 ];
C_Haptic2=C_Haptic/nExpClass*100;
figure; hold on; grid on; box on; axis equal;
imagesc(C_Haptic2, clims)
colormap(flipud(jet));
colormap(jet);
title('\textbf{Tactile}')
% a = makeColorMap(0.95*[1 1 1],rgb('gold'),rgb('green'),30);
 a = makeColorMap(0.95*[1 1 1],[212 175 55]/255,[11 102 35]/255);
colormap(a);
for i = 1:nClass+1
   plot([.5,nClass+0.5],[i-.5,i-.5],':','LineWidth',0.30,'Color',0.5*[1,1,1]);
   plot([i-.5,i-.5],[.5,nClass+0.5],':','LineWidth',0.30,'Color',0.5*[1,1,1]);
end
plot([0.5,0.5],[0.5,nClass+0.5],'k-');
plot([nClass+0.5,nClass+0.5],[0.5,nClass+0.5],'k-');
plot([0.5,nClass+0.5],[0.5,0.5],'k-');
plot([0.5,nClass+0.5],[nClass+0.5,nClass+0.5],'k-');
set(gca,'YDir','reverse')
xlim([0.5,nClass+0.5]); ylim([0.5,nClass+0.5]);
xlabel('Target class')
ylabel('Estimated class')

% CM for Kinesthetic-based classification
clims = [ 0, 100 ];
C_Kinema2=C_Kinema/nExpClass*100;
figure; hold on; grid on; box on; axis equal;
imagesc(C_Kinema2, clims)
colormap(flipud(jet));
colormap(jet);
title('\textbf{Kinesthetic}')
 a = makeColorMap(0.95*[1 1 1],[212 175 55]/255,[11 102 35]/255);
colormap(a);
for i = 1:nClass+1
   plot([.5,nClass+0.5],[i-.5,i-.5],':','LineWidth',0.30,'Color',0.5*[1,1,1]);
   plot([i-.5,i-.5],[.5,nClass+0.5],':','LineWidth',0.30,'Color',0.5*[1,1,1]);
end
plot([0.5,0.5],[0.5,nClass+0.5],'k-');
plot([nClass+0.5,nClass+0.5],[0.5,nClass+0.5],'k-');
plot([0.5,nClass+0.5],[0.5,0.5],'k-');
plot([0.5,nClass+0.5],[nClass+0.5,nClass+0.5],'k-');
set(gca,'YDir','reverse')
xlim([0.5,nClass+0.5]); ylim([0.5,nClass+0.5]);
xlabel('Target class')
set(gca,'YTickLabel',{});

% CM for Tactile-Kine Neural Fusion classification
clims = [ 0, 100 ];
C_Percep2=C_Percep/nExpClass*100;
figure; hold on; grid on; box on; axis equal;
imagesc(C_Percep2, clims)
colormap(flipud(jet));
colormap(jet);
title('\textbf{Neural Inf.}')
 %a = makeColorMap(0.95*[1 1 1],rgb('gold'),rgb('green'),30);
  a = makeColorMap(0.95*[1 1 1],[212 175 55]/255,[11 102 35]/255);
colormap(a);
for i = 1:nClass+1
   plot([.5,nClass+0.5],[i-.5,i-.5],':','LineWidth',0.30,'Color',0.5*[1,1,1]);
   plot([i-.5,i-.5],[.5,nClass+0.5],':','LineWidth',0.30,'Color',0.5*[1,1,1]);
end
plot([0.5,0.5],[0.5,nClass+0.5],'k-');
plot([nClass+0.5,nClass+0.5],[0.5,nClass+0.5],'k-');
plot([0.5,nClass+0.5],[0.5,0.5],'k-');
plot([0.5,nClass+0.5],[nClass+0.5,nClass+0.5],'k-');
set(gca,'YDir','reverse')
xlim([0.5,nClass+0.5]); ylim([0.5,nClass+0.5]);
xlabel('Target class')
set(gca,'YTickLabel',{});

% CM for Tactile-Kine Bayesian Fusion classification
clims = [ 0, 100 ];
C_Prob2=C_Prob/nExpClass*100;
figure; hold on; grid on; box on; axis equal;
imagesc(C_Prob2, clims)
colormap(flipud(jet));
colormap(jet);
title('\textbf{Bayesian Inf.}')
% a = makeColorMap(0.95*[1 1 1],rgb('gold'),rgb('green'),30);
  a = makeColorMap(0.95*[1 1 1],[212 175 55]/255,[11 102 35]/255);
colormap(a);
for i = 1:nClass+1
   plot([.5,nClass+0.5],[i-.5,i-.5],':','LineWidth',0.30,'Color',0.5*[1,1,1]);
   plot([i-.5,i-.5],[.5,nClass+0.5],':','LineWidth',0.30,'Color',0.5*[1,1,1]);
end
plot([0.5,0.5],[0.5,nClass+0.5],'k-');
plot([nClass+0.5,nClass+0.5],[0.5,nClass+0.5],'k-');
plot([0.5,nClass+0.5],[0.5,0.5],'k-');
plot([0.5,nClass+0.5],[nClass+0.5,nClass+0.5],'k-');
set(gca,'YDir','reverse')
xlim([0.5,nClass+0.5]); ylim([0.5,nClass+0.5]);
ccc = colorbar;
ccc.Label.String = 'Recognition rate [%]';
set(ccc,'FontSize',13,'TickLabelInterpreter','latex'); 
xlabel('Target class')
ylabel('Estimated class')


