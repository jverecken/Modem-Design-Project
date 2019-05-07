for i=1:100
    input=floor(2*rand(1,100));
    code=viterbicod(input);
    output=viterbidecod(code);
    if sum(output-input) ~=0
        display('error1')
    end
end

for i=1:100
    input=floor(2*rand(1,100));
    code=viterbicod(input);
    code(43,:)=[0 1];
    output=viterbidecod(code);
    if sum(output-input) ~=0
        display('error2')
    end
end

% for i=1:100
%     input=floor(2*rand(1,100));
%     code=viterbicod(input);
%     code(43,:)=[0 1];
%     code(59,:)=[0 1];
%     output=viterbidecod(code);
%     if sum(output-input) ~=0
%         display('error3')
%     end
% end
% 
% for i=1:100
%     input=floor(2*rand(1,100));
%     code=viterbicod(input);
%     code(43,:)=[0 1];
%     code(59,:)=[0 1];
%     code(69,:)=[0 1];
%     output=viterbidecod(code);
%     if sum(output-input) ~=0
%         display('error4')
%     end
% end
% 
% for i=1:100
%     input=floor(2*rand(1,100));
%     code=viterbicod(input);
%     code(43,:)=[0 1];
%     code(59,:)=[0 1];
%     code(69,:)=[0 1];
%     code(5,:)=[0 1];
%     
%     output=viterbidecod(code);
%     if sum(output-input) ~=0
%         display('error5')
%     end
% end
