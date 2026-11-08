%% part a
D=1
M=11
S=18
% zero parameters
if D==0
    D=1
end
if M==0
    M=1
end
if S==0
    S=1
end
X=linspace(0,3*pi,100)
X=X'
Y=(D/5)*cos(0.5*X)+(M/10)*sin(2*X)-(S/100)*X.^2+(S/20)*randn(size(X))
A_poly=X.^[0:5]
[Q,R]=qr(A_poly,0)
w_poly=R\(Q'*Y)
disp('polynomial weights')
disp(w_poly)

%% part b
A_sin=[ones(size(X)),sin(X),sin(2*X),sin(3*X),sin(4*X),sin(5*X)]
[q,r]=qr(A_sin,0)
w_sin=r\(q'*Y)
disp('sinusoidal weights')
disp(w_sin)

%% part c
Y_poly_fit=A_poly*w_poly;
Y_sin_fit=A_sin*w_sin;
figure
scatter(X,Y,25,'filled')
hold on
plot(X,Y_poly_fit,'r-','LineWidth',1.5)
plot(X,Y_sin_fit,'b-','LineWidth',1.5)
hold off
title('Noisy Data and Model Fits')
xlabel('X')
ylabel('Y')
legend('Noisy data','Polynomial fit','Sine fit','Location','best')
grid on
