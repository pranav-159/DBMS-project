with author_graph(author1,author2,edge_count) as
	(
	(select A.author_id as author1,B.author_id as author2,count(*) as edge_count
	from (citation left outer join authoring A on citation.index_1 = A.index)
			left outer join authoring B on citation.citationindex_2 = B.index
	where A.author_id < B.author_id and A.author_id != 1 and B.author_id != 1
	group by author1,author2
	except 
	select B.author_id as author1,A.author_id as author2,count(*) as edge_count
	from (citation left outer join authoring A on citation.index_1 = A.index)
			left outer join authoring B on citation.citationindex_2 = B.index
	where A.author_id > B.author_id and A.author_id != 1 and B.author_id != 1
	group by author1,author2)
	union
	(
	select B.author_id as author1,A.author_id as author2,count(*) as edge_count
	from (citation left outer join authoring A on citation.index_1 = A.index)
			left outer join authoring B on citation.citationindex_2 = B.index
	where A.author_id > B.author_id and A.author_id != 1 and B.author_id != 1
	group by author1,author2
	except
	select A.author_id as author1,B.author_id as author2,count(*) as edge_count
	from (citation left outer join authoring A on citation.index_1 = A.index)
			left outer join authoring B on citation.citationindex_2 = B.index
	where A.author_id < B.author_id and A.author_id != 1 and B.author_id != 1
	group by author1,author2 
	)
	union
	(
	select lauthor1 as author1,lauthor2 as author2,ledge_count+hedge_count as edge_count
	from	
		(select lesser.author1 as lauthor1,lesser.author2 as lauthor2,lesser.edge_count as ledge_count,
					higher.author1 as hauthor1,higher.author2 as hauthor2,higher.edge_count as hedge_count
			from 
				(select A.author_id as author1,B.author_id as author2,count(*) as edge_count
				from (citation left outer join authoring A on citation.index_1 = A.index)
						left outer join authoring B on citation.citationindex_2 = B.index
				 where A.author_id < B.author_id and A.author_id != 1 and B.author_id != 1
				 group by author1,author2) as lesser
				full outer join
				(select B.author_id as author1,A.author_id as author2,count(*) as edge_count
				from (citation left outer join authoring A on citation.index_1 = A.index)
						left outer join authoring B on citation.citationindex_2 = B.index
				where A.author_id > B.author_id and A.author_id != 1 and B.author_id != 1
				group by author1,author2) as higher on lesser.author2 = higher.author2
		where lesser.author1 = higher.author1 and lesser.edge_count is NOT NULL and higher.edge_count is NOT NULL) as lh
	)
	)
select P.author1 as X,Q.author1 as Y,R.author1 as Z,
			Case When P.edge_count < Q.edge_count And P.edge_count < R.edge_count Then P.edge_count
            When Q.edge_count < P.edge_count And Q.edge_count < R.edge_count Then Q.edge_count 
            Else R.edge_count
            End As clique_count
from (author_graph as P inner join author_graph as Q on P.author2 = Q.author1)
	inner join author_graph as R on Q.author2 = P.author1