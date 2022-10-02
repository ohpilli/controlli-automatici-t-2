clear all
s=tf('s');
G=56700/((s+0.7)*(s+10)*(s+90)^2);

%Si realizza un regolatore statico che garantisce l'errore nullo a regime e 
%l'attenuazione di 25 volte del disturbo in bassa frequenza.

G=56700/((s+0.7)*(s+10)*(s+90)^2);
Adb=20*log10(25);
mag=bode(G/s,0.08);
mu_s=10^((Adb-20*log10(mag))/20);
Rs=mu_s/s;
Ge=Rs*G;

%Scenario B: si realizza il regolatore dinamico mediante due reti anticipatrici.

[alpha,tau]=ProgettaRA(Ge,5,45);
Rd1=(1+tau*s)/((1+alpha*tau*s));

Ge1=Ge*Rd1;
[alpha1,tau1]=ProgettaRA(Ge1,7,72);
Rd2=(1+tau1*s)/((1+alpha1*tau1*s));

%Si realizza il regolatore feedback aggiungendo alle due reti ritardatrici
%due poli in 30 affinché il modulo della funzione di sensitività del
%controllo sia circa 0 db a 100 rad/s.

Rfb=Rd1*Rd2*Rs/((1+(1/30)*s)^2);
L=Rfb*G;
Q=Rfb/(1+L);
F=L/(1+L);

%Si aggiunge un'azione in avanti, con cancellazione del polo in 0.7 del
%plant; si aggiungono due prefiltri, uno prima e uno dopo il punto da cui 
%parte il ramo dell'azione in avanti.

Rff=((1+(1/0.7)*s))/(1+(1/45)*s);
Rpf_1=1/(1+(1/18)*s);
Rpf_2=1/(1+(1/6.85)*s);

%Si dicretizzano il regolatore feedback, il regolatore feed-forward e i
%due prefiltri, utilizzando il metodo di discretizzazione della
%trasformata bilineare.

Rfb_dis=c2d(Rfb,0.02,'tustin');
Rpf_1_dis=c2d(Rpf_1,0.02,'tustin');
Rpf_2_dis=c2d(Rpf_2,0.02,'tustin');
Rff_dis=c2d(Rff,0.02,'tustin');