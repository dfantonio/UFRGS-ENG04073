% Simulação do conversor DSRAC
% Jeferson Vieira Flores
% 28/05/2022
% 
% Modelo de pequenos sinais do conversor DSRAC apresenado no em [1]. O
% modelo foi obtido com 5 harmônicas, fs=50kHz e ponto de operação
% Vin=15.5V e D=0.3. 
%
% Por ser um modelo de pequenos sinais, a entrada do
% modelo deve ser sempre D=0.3+deltaD. O sinal de controle é saturado entre 
% 0 e 1 na entrada da planta.
% 
% Na simulação é aplicado um salto de distúrbio em Vin de amplitude 2V no
% instante de tempo (2/3)*Tsim, onde Tsim é o tempo total de simulação
% definido abaixo.
% 
% Passo de simulação do conversor de "tempo contínuo" foi fixado em de
% 1e-7s. Valores maiores podem causar instabildade numérica
% 
% Ao rodar o simulink, o modelo salva automaticamente os sinais D, Vin e Vo de "tempo contínuo" 
% nas variáveis simD, simVin e simVo, respectivamente.
% 
% Parâmetros do circuito do conversor:
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
% duplo série-ressonante com grampeamento ativo. 
% 2021. Dissertação de mestrado. PPGEE-UFRGS

%% Carregamento do modelo e definições básicas
close all; %limpa as variáveis, fecha gráficos e limpa a command window
load('modelo_5h.mat') %Carrega os parâmetros do modelo


Tsim=0.3; %[s] tempo total de simulação
fa=100e3; %[Hz] frequência de amostragem 2*fs
Ta=1/fa; %[s] tempo de amostragem 

D0=0.3; %Valor do ciclo de trabalho D no ponto de operação

Vin0=15.5; %[V] Valor de Vin no ponto de operação
dVin=2; %[V] Amplitude do salto em deltaVin
tdVin=2*Tsim/3; %Tempo em que é aplicadoo salto em deltaVin

dD=0.01; %Amplitude do salto em deltaD
tdD=Tsim/3; %Tempo em que é aplicadoo salto em deltaD

ref=90; %[V] sinal de refência
dref=10; %[V] salto no sinal de referência
tref=Tsim/3;% [s] instante de tempo em que é dado o salto de referência

[Kp,Ki,Kd,Tf] = piddata(C_cont);

kp=Kp
ti=Kp/Ki
P=-C_cont.p{1,1}(2)
%P=-C_cont.den{1,1}(2);
td=Kd/(Kp*P*Tf)

% ti = 0.000248327759;
% td = 0.00105071549;
% kp = 0.00225335952;
% P = 16100;

Cps = tf([kp],[1]);
Cis = tf([kp/ti],[1 0]);
Cds = tf([kp*ti*P 0],[1 P]);
Csum = Cps + Cds + Cis;

Cdp = c2d(Cps,Ta,'tustin');
Cdi = c2d(Cis,Ta,'tustin');
Cdd = c2d(Cds,Ta,'tustin');

[np,dp] = tfdata(Cdp,'v');
[ni,di] = tfdata(Cdi,'v');
[nd,dd] = tfdata(Cdd,'v');


%nc=[1 1170 3.947e6]*0.049114; %coeficientes do numerador do controlador em tempo contínuo
%dc=[1 1.6e4 0]; %coeficientes do denominador do controlador em tempo contínuo

%Cc=tf(nc,dc); %função de transferência do controlador em tempo contínuo

CD = c2d(C_cont,Ta,'matched'); %discretização do controlador

[Kp,Ki,Kd,Tf] = piddata(CD);
%Kd=Kd/Tf;

[n_disc,d_disc]=tfdata(CD,'v'); %cálculo dos coeficientes dos numerador e denominador do controlador em tempo discreto

%% Simulação do sistema em malha fechada

sim('MF_simula_disc',Tsim); %roda a simulação

save('minha_sim.mat','simTDisc','simDDisc','simRDisc','simEDisc','simVoDisc') %Salva o dados para utilizaçao no arquivo compara_MF

%% Compara com a referência
compara_MF

%% Plot dos sinais
% close all;
% 
% subplot(1,1,1)
% hold on
% stairs(simTDisc,simRDisc,'k-.','LineWidth',2)
% stairs(simTDisc,simVoDisc,'LineWidth',2)
% plot(simT,simVo,'LineWidth',2,'Color','red','LineStyle','--')
% hold off
% grid;legend('r[k]','Vo[k]','Vo(t)');xlabel('t [s]');ylabel('Sinais [V]');axis([0 Tsim 0.99*min(simVoDisc) 1.01*max(simVoDisc)])
% 
% figure
% 
% subplot(4,1,1)
% hold on
% stairs(simTDisc,simRDisc,'k-.','LineWidth',2)
% stairs(simTDisc,simVoDisc,'LineWidth',2)
% plot(simT,simVo,'LineWidth',2,'Color','red','LineStyle','--')
% hold off
% grid;legend('r[k]','Vo[k]','Vo(t)');xlabel('t [s]');ylabel('Sinais [V]');axis([0 Tsim 0.99*min(simVoDisc) 1.01*max(simVoDisc)])
% 
% subplot(4,1,2)
% hold on
% stairs(simTDisc,simDDisc,'LineWidth',2)
% plot(simT,simDCont,'LineWidth',2,'Color','red','LineStyle','--')
% hold off
% grid;legend('D[k]','D(t)');xlabel('t [s]');ylabel('Controle D');axis([0 Tsim 0.99*min(simDDisc) 1.01*max(simDDisc)])
% 
% subplot(4,1,3)
% hold on
% stairs(simTDisc,simEDisc,'LineWidth',2)
% plot(simT,simECont,'LineWidth',2,'Color','red','LineStyle','--')
% hold off
% grid;legend('e[k]','e(t)');xlabel('t [s]');ylabel('Erro [V]');axis([0 Tsim 0.99*min(simEDisc) 1.01*max(simEDisc)])
% 
% subplot(4,1,4)
% stairs(simTDisc,simSat,'LineWidth',2)
% grid;xlabel('t [s]');ylabel('Vin [V]');axis([0 Tsim 0.99*min(simVinDisc) 1.01*max(simVinDisc)])

