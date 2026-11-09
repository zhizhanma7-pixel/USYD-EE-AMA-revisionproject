function [x,k]=Newton_raphson(f,df,x0,tol,maxIter)
x=x0
k=0
for i=1:maxIter
    d=df(x)
    if abs(d)<eps
        error('derivative is zero')
    end
    dx=f(x)/d
    x=x-dx
    k=i
    if abs(dx)<tol && abs(f(x))<tol
        return
    end
end
disp('did not converge')
end
