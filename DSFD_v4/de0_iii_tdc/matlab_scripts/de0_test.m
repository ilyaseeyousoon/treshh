% error должна равняться 0 если вы раскоментите тестовый модуль uart в
% плисе и опросите после прошивки плис с помощью этого скрипта.

clear all; 
close all; 
%% 
buf_size=2500000;

s1 = serial('COM17','DataBits',8); 
s1.InputBufferSize = buf_size; 
s1.BaudRate = 1250000; 
s1.Timeout=60; 
s1.StopBits =2; 
d=0;
h=0;
error=0;
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

% z(round(buf_size/3))=0;
m=1;
for j=h:3:(buf_size-50-d)
    
 z(m)=+temp(j+1)*256+temp(j+2);

    if(z(m)~=42053)
        error=error+1;
    end
  m=m+1;
         
end

