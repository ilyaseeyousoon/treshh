% рабочая версия скрипта

clear all; 
close all; 
%% 
buf_size=5000;

s1 = serial('COM17','DataBits',8); 
s1.InputBufferSize = buf_size; 
s1.BaudRate = 1250000; 
s1.Timeout=6; 
s1.StopBits =2; 
d=0;
h=0;
fopen(s1) 


temp = fread(s1); 
fclose(s1)

for i=1:buf_size
    if(i>0)
    if (temp(i)==123)
    
       h=i; 
       d=i; 
       break;
    end
    end
    
    
end

% z(buf_size)=0;
m=1;
for j=h:3:(buf_size-25)
    
 z(m)=temp(j+1)*256+temp(j+2);
 
% z(m)=z(m);
% if(z(m)<0)
%     z(m)=0;
% end

  m=m+1;
         
end

plot(z);
