
% calcula_func_transf(0.0333,0.0343,89.97,88.2,89.46,0.3,0.31) para obter
% G(s)
function [num,den] = calcula_func_transf(t_0,t_pico,y_max,y_0,y_inf,u_0,u_inf)
    % Cálculos
    k_barra= (y_inf-y_0)/(u_inf-u_0);
    M_p=((y_max-y_0)-(y_inf-y_0))/(y_inf-y_0) * 100;
    n=log(M_p/100);
    psi=sqrt(n^2/(pi^2+n^2));
    omega_n=(pi/((t_pico-t_0)*sqrt(1-psi^2)));

    % Retorna os arrays de numerador e denominador
    num=k_barra*omega_n^2;
    den=[1,2*psi*omega_n,omega_n^2];
end