file = "anymal_b.xml";

text = fileread(file);

%% BODY
bodyStart = strfind(text, "<!-- <COMPOSITE_BODY> -->")

bodyEnd = strfind(text, "<!-- </COMPOSITE_BODY> -->")-1

before = extractBefore(text, bodyStart);
bodyCode = extractBetween(text, bodyStart, bodyEnd);
bodyCode = bodyCode{:};
after = extractAfter(text, bodyEnd);

newbodyFull = [];
countX =  10;
countY = 3;
for i=1:countX
    for j=1:countY
        rbtName = ['r_', num2str(i), '_', num2str(j), '_'];
        newbody = strrep(bodyCode, '$robot$', rbtName);
        newbody = strrep(newbody, '$x$', num2str(i));
        newbody = strrep(newbody, '$y$', num2str(j));
        newbodyFull = [newbodyFull newbody];
    end
end

newcontent = [before newbodyFull after]

%% CONTACT
contactStart = strfind(newcontent, "<!-- COMPOSITE_CONTACT -->")
contactEnd = strfind(newcontent, "<!-- /COMPOSITE_CONTACT -->")-1

before = extractBefore(newcontent, contactStart);
contactCode = extractBetween(newcontent, contactStart, contactEnd);
after = extractAfter(newcontent, contactEnd);

newContactFull = [];
for i=1:countX
    for j=1:countY
        rbtName = ['r_', num2str(i), '_', num2str(j), '_'];
        newcontact = strrep(contactCode, '$robot$', rbtName);
        newContactFull = [newContactFull newcontact];
    end
end
newcontent = [before newContactFull{:} after]

%% ACTUATOR
start = strfind(newcontent, "<!-- COMPOSITE_ACT -->")
last = strfind(newcontent, "<!-- /COMPOSITE_ACT -->")-1

before = extractBefore(newcontent, start);
code = extractBetween(newcontent, start, last);
after = extractAfter(newcontent, last);

newcodefull = [];
for i=1:countX
    for j=1:countY
    rbtName = ['r_', num2str(i), '_', num2str(j), '_'];
    newcode = strrep(code, '$robot$', rbtName);
    newcodefull = [newcodefull newcode];
    end
end
newcontent = [before newcodefull{:} after]

%% OUTPUT

outputFile = "anymal_b_multiplied.xml"

outFileId = fopen(outputFile, 'w');
fprintf(outFileId, "%s", newcontent);
fclose(outFileId)