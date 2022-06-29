with paper_authorlist(index,authorList) as
	(select authoring.index,string_agg(author_name,',' order by authoring.position) as authorList
	from authoring full outer join 
		(select author_id,concat(first_name,' ',last_name) as author_name from author) as authorarray 
			on authoring.author_id = authorarray.author_id 
	group by authoring.index)
select citationindex_2 as cited_index,index_1 as citing_index,title,authorlist,year_of_publication,venue
from (citation left outer join research_paper on citation.index_1 = research_paper.index) 
 left outer join paper_authorlist on citation.index_1 = paper_authorlist.index
order by cited_index
