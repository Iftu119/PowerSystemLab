clc
clear all
close all

% Data Collection
n = input('Enter the number of nodes: ')
p = zeros(n)
% we have just created nxn matrix with all values zero (i.e. zero matrix).
% lets put n=3

for i=1:1:n % row
    for j=1:1:n % column

        if(i==j) % for self admittance 10,20,30
            p(i,j)=input(strcat('enter admittance Y', int2str(i), int2str(0),' : '))

        elseif(i~=j && p(j,i)==0) % for mutual admittance 12,13,23
            p(i,j)=input(strcat('enter admittance Y', int2str(i), int2str(j),' : '))

        else
            p(i,j)=p(j,i); % because Y12=Y21; similar for 13=31, 23=32
        end
    end
end
 
%% Determine Y_bus

%{
Now what does P contain ? 
Just the admittance values.  
It hasn't been made to adjust Y11=Y10+Y12+Y13 ; 
also the minus sign needsto be inserted to match the formuale. 
LET'S JUMP IN. Burrr.....
%}

q=p; % All admittances put into q matrix
r=0; % Counter introduced. Why? Let's see.

for i=1:1:n % row
    for j=1:1:n % column
        if(i==j) % selecting the cells with self admittance i.e. 11,22,33
            for k=1:1:n 
                % lets say our input had been 1,2,3,4,5,6 at initial stage
                %{
                  p =

                    1     2     3
                    2     4     5
                    3     5     6  
                %}
                
                r=r+q(i,k) % r=0 > r=0+1 > r=1+2 > r=3+3=6
            end
            p(i,j)= r; % insert the values back into p
            r=0;% reset the counter AKA adder parameter
        else
            p(i,j)= -q(i,j) %Adjusting the minus sign with formula
        end
    end
end

Y=p

%% Data from Question
V1=1.05+0i;
P2=-4;
Q2=-2.5i;
P3=2;

% Taking Initial Approximations
V2=1+0i;
V3=1.04+0i;

%% Iterations
for j=1:1:50

% Bus 2
V2=(1/Y(2,2))*((P2-Q2)/conj(V2)-Y(2,1)*V1-Y(2,3)*V3);

% Bus 3
Q3=-imag(conj(V3)*(Y(3,1)*V1+Y(3,2)*V2+Y(3,3)*V3));
V3=(1/Y(3,3))*((P3-(Q3)*i)/conj(V3)-Y(3,1)*V1-Y(3,2)*V2);
n=sqrt(1.04*1.04-imag(V3)*imag(V3));
V3=n+imag(V3)*i;
end
 
% Result
disp('-----Bus1-----')
S1=conj(V1)*(Y(1,1)*V1+Y(1,2)*V2+Y(1,3)*V3);
S1=conj(S1)
disp('-----Bus2-----')
V2
Angle2=angle(V2)*180/pi
disp('-----Bus3-----')
V3
Angle3=angle(V3)*180/pi
Mag_V3=abs(V3)
Q3
