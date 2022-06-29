import re

source = open("source.txt","r",newline = "\n")
research_paper = open("research_paper.csv","w+")
authorfile = open("author.csv","w+")
citingfile = open("citation.csv","w+")

delim = '\u0005'


author_set = set()
authorMap = {}
citingMap = {}

title = ""
publication_year = 0
venue = ""
abstract = ""
index = 0
citingPapers = set()

t = False
v = False
p = False
a = False
i = False


for line in source:
    line = line[0:-1]
    if line == "":
        if not t:
            title = "not available"
        if not v:
            venue = "not available"
        if not p:
            publication_year = -1
        if not a:
            abstract = "no abstract"
        if not i:
            index = -1
        research_paper.write(str(index)+delim+title+delim+str(publication_year)+delim+venue+delim+abstract+"\n") 
        continue

    code = line[0:2]

    if code == "#*":
        t = True
        title = line[2:]
    elif code == "#@":
        # authorList = re.split("(?<!CORPORATE.*)(\s*[, ] +\s*)"
        #                       + "(?!\s*(Jr\.|Jr|Sr|Sr\.|Esq|Esq\.|II|III|V|VI|VII)\s*[,$])"
        #                       + "|"
        #                       + "(\\s*[,]+\\s*)(?=CORPORATE)")
        authorList = re.split(r"\s*[,]+\s*"
                            #   + "(?!\s*(Jr\.|Jr|Sr|Sr\.|Esq|Esq\.|II|III|V|VI|VII)\s*[,$])"
                              , line[2:])
        for author in authorList:
            author_set.add(author)
    elif code == "#t":
        p = True
        publication_year = int(line[2:])
    elif code == "#i":
        i = True
        index = int(line[6:])
    elif code == "#c":
        v = True
        venue = line[2:]
        if venue == "":
            venue = "Not available"
    elif code == "#!":
        a = True
        abstract = line[2:]
        

# author_set.remove("")
# author_set.add("Anonymous")

i = 1
for author in author_set:
    authorMap[author] = i
    i+=1
for key in authorMap:
    x = re.split(r"\s+",str(key),maxsplit=1)
    y = []
    if len(x)==1:
        y.append(x[0])
        y.append("")
    elif len(x) == 2:
        y = x
    if key == "":
        y[0] = "Anonymous"
        y[1] = ""
    authorfile.write(str(authorMap[key])+delim+str(y[0])+delim+str(y[1])+"\n")

authoringfile = open("authoring.csv","w+") 

from ordered_set import OrderedSet
authorList = OrderedSet()

source.seek(0,0)
for line in source:
    line = line[0:-1]
    if line == "":
        
        i = 1
        for author in authorList:
            authoringfile.write(str(index)+delim+str(i)+delim+str(authorMap[author])+"\n")
            i+=1

        if index >= 0:
            citingArray = []
            for cited in citingPapers:
                if index != cited:
                    citingArray.append(cited)
            citingMap[index] = citingArray
        citingPapers.clear()

        continue
    
    code = line[0:2]
    if code == "#@":
        # authorList = re.split("(?<!CORPORATE.*)(\s*[, ] +\s*)"
        #                       + "(?!\s*(Jr\.|Jr|Sr|Sr\.|Esq|Esq\.|II|III|V|VI|VII)\s*[,$])"
        #                       + "|"
        #                       + "(\\s*[,]+\\s*)(?=CORPORATE)")
        authorList = OrderedSet(re.split(r"\s*[,]+\s*"
                                #   + "(?!\s*(Jr\.|Jr|Sr|Sr\.|Esq|Esq\.|II|III|V|VI|VII)\s*[,$])"
                                  , line[2:]))
    elif code == "#i":
        index = int(line[6:])
    elif code == "#%":
        citingPapers.add(int(line[2:]))


for key in citingMap:
    for elem in citingMap[key]:
        citingfile.write(str(key)+delim+str(elem)+"\n")   







    

