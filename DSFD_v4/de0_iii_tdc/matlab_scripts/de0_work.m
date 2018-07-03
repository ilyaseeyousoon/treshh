% рабочая версия скрипта

clear all; 
close all; 
%% 
buf_size=50000;

s1 = serial('COM17','DataBits',8); 
s1.InputBufferSize = buf_size; 
s1.BaudRate = 781250; 
s1.Timeout=6; 
s1.StopBits =2; 
d=0;
h=0;
fopen(s1) 


temp = fread(s1); 
fclose(s1)

for i=1:buf_size
    if(i>40)
    if (temp(i)==123)
    
       h=i; 
       d=i; 
       break;
    end
    end
    
    
end

% z(buf_size)=0;
m=1;
for j=h:4:(buf_size-50-d)
    
 z(m)=temp(j+1)*65536+temp(j+2)*256+temp(j+3);
z(m)=z(m)-15600000;
if(z(m)<0)
    z(m)=0;
end

  m=m+1;
         
end

plot(z);
