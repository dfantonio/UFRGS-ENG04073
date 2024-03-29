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

%% Carregamento o modelo e defini��es b�sicas
clear all;close all;clc; %limpa as vari�veis, fecha gr�ficos e limpa a command window
load('modelo_5h.mat') %Carrega os par�metros do modelo

%% Simula��o do modelo 
Tsim=0.1; %[s] tempo total de simula��o

D0=0.3; %Valor do ciclo de trabalho D no ponto de opera��o
% dD=0.01; %Amplitude do salto em deltaD
dD=0.0; %Amplitude do salto em deltaD
tdD=Tsim/3; %Tempo em que � aplicadoo salto em deltaD

Vin0=15.5; %[V] Valor de Vin no ponto de opera��o
dVin=2; %[V] Amplitude do salto em deltaVin
tdVin=2*Tsim/3; %Tempo em que � aplicadoo salto em deltaVin

%% C�lculo das fun��es de transfer�ncia
% Calcula G(s)
t_0=0.0333;
t_pico=0.0343;
y_max=89.97;

y_0=88.2;
y_inf=89.46;

u_0=0.3;
u_inf=0.31;

[tf_G_num,tf_G_den]=calcula_func_transf(t_0,t_pico,y_max,y_0,y_inf,u_0,u_inf);

% Calcula Gq
t_0=0.06667;
t_pico=0.06764;
y_max=104;

y_0=88.2;
y_inf=99.58;

u_0=15.5;
u_inf=17.5;

[tf_Gq_num,tf_Gq_den] = calcula_func_transf(t_0,t_pico,y_max,y_0,y_inf,u_0,u_inf);

%% Roda a simula��o

sim('MA_simula_dsrac',Tsim); %roda a simula��o



%% Plot dos sinais
close all
% subplot(1,1,1)
% plot(simT,simVo,'LineWidth',2,'Color','red')
% grid;xlabel('t [s]');ylabel('Vo [V]');axis([0 Tsim 0.99*min(simVo) 1.01*max(simVo)])
% 
% hold on
% 
% plot(simT,simVoCalculado,'LineWidth',2)
% 
% hold off
% legend('Refer�ncia','Modelo')

figure

subplot(1,2,1)
plot(simT,simVo,'LineWidth',2,'Color','red')
grid;xlabel('t [s]');ylabel('Vo [V]');axis([0.09 Tsim 0.99*min(simVo) 1.01*max(simVo)])

% subplot(1,2,2)
% plot(simT,simD,'LineWidth',2)
% grid;xlabel('t [s]');ylabel('D');axis([0.0 Tsim 0.99*min(simD) 1.01*max(simD)])

subplot(1,2,2)
plot(simT,simVin,'LineWidth',2)
grid;xlabel('t [s]');ylabel('Vin [V]');axis([0.09 Tsim 0.99*min(simVin) 1.01*max(simVin)])

% Cria nova janela
% figure

% subplot(2,1,1)
% plot(simT,erro_abs,'LineWidth',2,'Color','red')
% grid;xlabel('t [s]');ylabel('Erro absoluto');axis([0 Tsim 0.99*min(erro_abs) 1.01*max(erro_abs)])
% 
% subplot(2,1,2)
% plot(simT,erro_quad,'LineWidth',2,'Color','red')
% grid;xlabel('t [s]');ylabel('Erro quadr�tico');axis([0 Tsim 0.99*min(erro_quad) 1.01*max(erro_quad)])


