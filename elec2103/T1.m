syms k t
f = 2;
K = 10;
x = 4/pi * symsum(sin(2*pi*f*t*(2*k-1))/(2*k-1), k, 1, K);

figure
fplot(x, [0 1], 'b-', 'LineWidth', 1.5)
hold on
fplot(sign(sin(2*pi*f*t)), [0 1], 'k--')
hold off
title('Square wave by Fourier series (f = 2 Hz, 10 terms)')
xlabel('t (s)')
ylabel('x_{sqr}(t)')
legend('Fourier series, 10 terms', 'Ideal square wave', 'Location', 'best')
grid on

disp('x at t = 0.125:'); disp(double(subs(x, t, 0.125)))
