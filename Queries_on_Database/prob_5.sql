with author_fullname(author_id,author_name) as 
	(select author_id,concat(first_name,' ',last_name) as author_name
	from author)
select P.author_name as author1,Q.author_name as author_2
from (select author1,author2,count(*) as times
		from (select A.author_id as author1,B.author_id author2
			from authoring A left outer join authoring B on A.index = B.index
			where A.author_id < B.author_id) as double_author
		group by double_author.author1,double_author.author2
		having count(*) > 1) as total_author_id_pair 
	   left outer join author_fullname P on total_author_id_pair.author1 = P.author_id
	   left outer join author_fullname Q on total_author_id_pair.author2 = Q.author_id
	

