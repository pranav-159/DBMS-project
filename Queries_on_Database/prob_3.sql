with paper_authorlist(index,authorList) as
	(select authoring.index,string_agg(author_name,',' order by authoring.position) as authorList
	from authoring full outer join 
		(select author_id,concat(first_name,' ',last_name) as author_name from author) as authorarray 
			on authoring.author_id = authorarray.author_id 
	group by authoring.index)
select distinct cited_index,citing_index,title,authorlist,year_of_publication,venue
from ((select c1.citationindex_2 as cited_index,c2.index_1 as citing_index
		from citation c1 join citation c2 on c1.index_1 = c2.citationindex_2) as double_citing 
		left outer join research_paper on double_citing.citing_index = research_paper.index)
		left outer join paper_authorlist on double_citing.citing_index = paper_authorlist.index
order by cited_index
