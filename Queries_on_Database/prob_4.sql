select citationindex_2 as cited_index,count(*)
from citation
group by citation.citationindex_2
order by count(*) desc limit 20