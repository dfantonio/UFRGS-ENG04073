% Simula��o do conversor DSRAC
% Jeferson Vieira Flores
% 28/05/2022
% 
% Modelo de pequenos sinais do conversor DSRAC apresenado no em [1]. O
% modelo foi obtido com 5 harm�nicas, fs=50kHz e ponto de opera��o
% Vin=15.5V e D=0.3. 
%
% Por ser um modelo de pequenos sinais, a entrada do
% modelo deve ser sempre D=0.3+deltaD. O sinal de controle � saturado entre 
% 0 e 1 na entrada da planta.
% 
% Na simula��o � aplicado um salto de dist�rbio em Vin de amplitude 2V no
% instante de tempo (2/3)*Tsim, onde Tsim � o tempo total de simula��o
% definido abaixo.
% 
% Passo de simula��o do conversor de "tempo cont�nuo" foi fixado em de
% 1e-7s. Valores maiores podem causar instabildade num�rica
% 
% Ao rodar o simulink, o modelo salva automaticamente os sinais D, Vin e Vo de "tempo cont�nuo" 
% nas vari�veis simD, simVin e simVo, respectivamente.
% 
% Par�metros do circuito do conversor:
% R = 250 Ohm;
% n = 4;
% Ron = 0.0075 Ohm; 
% Lm = 15e-6 H;  
% Ls = 1e-6 H;
% Cc = 150e-6 F; 
% Cr = 1e-6 F; 
% Co = 150e-6 F;
% 
% [1]Guilherme Salati. Modelagem e controle de um conversor CC-CC 
% duplo s�rie-ressonante com grampeamento ativo. 
% 2021. Disserta��o de mestrado. PPGEE-UFRGS

%% Carregamento do modelo e defini��es b�sicas
clear all;close all;clc; %limpa as vari�veis, fecha gr�ficos e limpa a command window
load('modelo_5h.mat') %Carrega os par�metros do modelo

%% Simula��o do sistema em malha fechada

Tsim=0.3; %[s] tempo total de simula��o
fa=100e3; %[Hz] frequ�ncia de amostragem 2*fs
Ta=1/fa; %[s] tempo de amostragem 

D0=0.3; %Valor do ciclo de trabalho D no ponto de opera��o

Vin0=15.5; %[V] Valor de Vin no ponto de opera��o
dVin=2; %[V] Amplitude do salto em deltaVin
tdVin=2*Tsim/3; %Tempo em que � aplicadoo salto em deltaVin

ref=90; %[V] sinal de ref�ncia
dref=10; %[V] salto no sinal de refer�ncia
tref=Tsim/3;% [s] instante de tempo em que � dado o salto de refer�ncia


nc=[0.000087830589033 3.757361353061334]; %coeficientes do numerador do controlador em tempo cont�nuo
dc=[1 0]; %coeficientes do denominador do controlador em tempo cont�nuo

Cc=tf(nc,dc); %fun��o de transfer�ncia do controlador em tempo cont�nuo

CD = c2d(Cc,Ta,'matched'); %discretiza��o do controlador

[nd,dd]=tfdata(CD,'v'); %c�lculo dos coeficientes dos numerador e denominador do controlador em tempo discreto

sim('MF_simula_disc',Tsim); %roda a simula��o

save('minha_sim.mat','simTDisc','simDDisc','simRDisc','simEDisc','simVoDisc') %Salva o dados para utiliza�ao no arquivo compara_MF

%% Plot dos sinais
subplot(4,1,1)
hold on
stairs(simTDisc,simRDisc,'k-.','LineWidth',2)
stairs(simTDisc,simVoDisc,'LineWidth',2)
hold off
grid;legend('r[k]','Vo[k]');xlabel('t [s]');ylabel('Sinais [V]');axis([0 Tsim 0.99*min(simVoDisc) 1.01*max(simVoDisc)])
subplot(4,1,2)
stairs(simTDisc,simDDisc,'LineWidth',2)
grid;xlabel('t [s]');ylabel('Controle D');axis([0 Tsim 0.99*min(simDDisc) 1.01*max(simDDisc)])
subplot(4,1,3)
stairs(simTDisc,simEDisc,'LineWidth',2)
grid;xlabel('t [s]');ylabel('Erro [V]');axis([0 Tsim 0.99*min(simEDisc) 1.01*max(simEDisc)])
subplot(4,1,4)
stairs(simTDisc,simVinDisc,'LineWidth',2)
grid;xlabel('t [s]');ylabel('Vin [V]');axis([0 Tsim 0.99*min(simVinDisc) 1.01*max(simVinDisc)])