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
    code(43)=0;
    output=viterbidecod(code);
    if sum(output-input) ~=0
        display('error2')
    end
end

for i=1:100
    input=floor(2*rand(1,100));
    code=viterbicod(input);
    code(43)=0;
    code(59)=1;
    output=viterbidecod(code);
    if sum(output-input) ~=0
        display('error3')
    end
end

for i=1:100
    input=floor(2*rand(1,100));
    code=viterbicod(input);
    code(43)=0;
    code(59)=1;
    code(69)=1;
    output=viterbidecod(code);
    if sum(output-input) ~=0
        display('error4')
    end
end

for i=1:100
    input=floor(2*rand(1,100));
    code=viterbicod(input);
    code(43)=0;
    code(59)=1;
    code(69)=1;
    code(5)=0;
    output=viterbidecod(code);
    if sum(output-input) ~=0
        display('error5')
    end
end

for i=1:100
    input=floor(2*rand(1,100));
    code=viterbicod(input);
    code(43)=0;
    code(59)=1;
    code(69)=1;
    code(5)=0;
    code(28)=1;
    output=viterbidecod(code);
    if sum(output-input) ~=0
        display('error6')
    end
end

for i=1:10000
    input=floor(2*rand(1,100));
    code=viterbicod(input);
    code(43)=0;
    code(59)=1;
    code(69)=1;
    code(5)=0;
    code(28)=1;
    code(23)=0;
    output=viterbidecod(code);
    if sum(output-input) ~=0
        display('error7')
    end
end
for i=1:100
    input=floor(2*rand(1,100));
    code=viterbicod(input);
    code(43)=0;
    code(59)=1;
    code(69)=1;
    code(5)=0;
    code(28)=1;
    code(34)=0;
    code(78)=0;
    output=viterbidecod(code);
    if sum(output-input) ~=0
        display('error8')
    end
end
for i=1:100
    input=floor(2*rand(1,100));
    code=viterbicod(input);
    code(43)=0;
    code(59)=1;
    code(69)=1;
    code(5)=0;
    code(28)=1;
    code(34)=0;
    code(78)=0;
    code(44)=1;
    output=viterbidecod(code);
    if sum(output-input) ~=0
        display('error9')
    end
end
for i=1:100
    input=floor(2*rand(1,100));
    code=viterbicod(input);
    code(43)=0;
    code(59)=1;
    code(69)=1;
    code(5)=0;
    code(28)=1;
    code(34)=0;
    code(78)=0;
    code(44)=1;
    code(55)=0;
    output=viterbidecod(code);
    if sum(output-input) ~=0
        display('error10')
    end
end