function [u, nmv] = exp_poly(f,MAT,ss,num,dt,q)
% solution of shifted Helmholtz via p-th order taylor expansion of exp func

u  = zeros(size(f));
uu = zeros(size(f));

% compensation factors
w   = -1j*ss;
wdt = w*dt;
wf = zeros(1,q);
t = 1/w;
for j=1:q
    t = t*wdt/j;
    wf(j) = t; %wdt^j/j!/w
end
wa = 1+w*sum(wf);

for i = 1:num
    k  = u;
    kk = uu;
    for j=1:q
        [k,kk] = sysop(k*(dt/j),kk*(dt/j),f,wf(j),MAT);
        u  = u  + k;
        uu = uu + kk;
    end
    u  =  u/wa;
    uu = uu/wa;
end
nmv = num*q;
end

function [y1,y2] = sysop(x1,x2,f,w,MAT)
% 2x2 system operator
%  / -b     1 \ /x1\   /   0 \
%  \-M\S/a  -b/ \x2/ + \M\f/a/

y1 = x2 - MAT.btmp.*x1;
y2 = (w*f - stiffop(x1,MAT))./MAT.M(:)./MAT.atmp -MAT.btmp.*x2;
end