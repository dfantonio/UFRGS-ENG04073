%Compara o desempenho do sistema em malha fechada com o controlador padr�o.
%O arquivo minha_sim.mat deve ser gerado como mostrado no arquivo MF_roda_sim_disc.m.

clear all;close all;clc; %limpa as vari�veis, fecha gr�ficos e limpa a command window

load('sim_padrao.mat'); %Arquivo de simula��o com os sinais do controlador padr�o

nome='minha_sim.mat'; %Nome do arquivo com a simula��o a ser comparada
load(nome);

%Calcula os �ndices de desempenho
[Je,Ju,M] = calculaJ(nome)

%Plota as simula��es com os dados fornecidos e os dados do controlador
%padr�o
Tsim=max(simTDisc);
subplot(4,1,1)
hold on
stairs(simTDisc,simRDisc,'k-.','LineWidth',2)
stairs(simTDisc,simVoDisc,'LineWidth',2)
stairs(T0,Vo0,'r--','LineWidth',2)
hold off
grid;legend('r[k]','Vo[k]','Vo[k] padrao');xlabel('t [s]');ylabel('Sinais [V]');axis([0 Tsim 0.99*min(simVoDisc) 1.01*max(simVoDisc)])
subplot(4,1,2)
hold on
stairs(simTDisc,simDDisc,'LineWidth',2)
stairs(T0,D0,'r--','LineWidth',2)
hold off
grid;xlabel('t [s]');legend('D[k]','D[k] padrao');ylabel('Controle D');axis([0 Tsim 0.99*min(simDDisc) 1.01*max(simDDisc)])
subplot(4,1,3)
hold on
stairs(simTDisc,simEDisc,'LineWidth',2)
stairs(T0,E0,'r--','LineWidth',2)
hold off
grid;xlabel('t [s]');legend('e[k]','e[k] padrao');ylabel('Erro [V]');axis([0 Tsim 0.99*min(simEDisc) 1.01*max(simEDisc)])
subplot(4,1,4)
stairs(T0,Vi0,'LineWidth',2)
grid;xlabel('t [s]');ylabel('Vin [V]');axis([0 Tsim 0.99*min(Vi0) 1.01*max(Vi0)])