# DBMS-project
- In this assignment, we convert the ER diagram of the last assignment into relational
schema and populate the database tables from the data given in source.txt file.
Files in the assignment include:
    - Modified ERD
    - Relational schema
    - Parser code file (parser.py)
    - Loader file (loader.sql)
    - Database dump file ()
- **ER Diagram:**
    - This consists of three entities: research_paper, author and citation and they are related
following the instructions mentioned.
- **Relational Schema:**
    - This relational schema diagram is generated in the erdplus website using a modified
ER diagram. This schema consists of 4 tables, author,citation,authoring and research
paper.
- **Parser file:**
    - This code is written in python. In this, we cleaned the data given in source.txt file and
populated the data in the form of .csv files corresponding to each table in relational
schema. The files generated are author.csv, research_paper.csv, citation.csv and
authoring.csv.
    - Here author List is not just an simple list concatenating authors using a unique
delimiter,They contain CORPORATE’s where we should neglect comma’s(our default
delimiter afterwards until a particular comma(In this data,in most of the cases this
comma is followed by CORPORATE keyword.And some author names contain comma
in itself which are usually followed by their initial or seniority (Jr.,Sr.,I,II,III,V,VI,VII) or
titles(Esq.).We tried to do this by using a regular expression(as it allows us to have
different delimiters according to the situation.
    - Strings produced after parsing do contain quotation marks like “ .They will become
troublesome in later COPY command injection of data into database.So we replaced “
with “” in the CSV files related to research_paper.csv and author.csv.We did this by using
Sed.
    - After generating author.csv,research_paper.csv,citation.csv and authoring.csv files.We
generate another two files dd_author.csv,dd_research_paper.csv by running
commands
sed 's/"/""/g' author.csv > dd_author.csv
sed ‘s/”/””/g’ research_paper.csv > dd_research_paper.csv
Which contains data with closed quotations(it achieves it by replacing every “ with
“”).
- **Loader File:**
    - We loaded the data in csv files into pg database by using the COPY from csv
command.We used dd_research_paper.csv,dd_author.csv,citation.csv,authoring.csv
respectively to generate research_paper,author,citation,authoring tables.We have to
make sure to first populate author,research_paper tables before populating
citation,authoring tables as they depend on research_paper and
(research_paper,author) tables respectively.We then mentioned encoding as utf-8
inorder to support multilingual characters

