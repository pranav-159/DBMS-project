CREATE TABLE research_paper
(
  index INT NOT NULL,
  Title text NOT NULL,
  year_of_publication INT NOT NULL,
  venue text NOT NULL,
  Abstract text NOT NULL,
  PRIMARY KEY (index)
);

CREATE TABLE author
(
  author_id INT NOT NULL,
  first_name varchar(500),
  last_name varchar(500),
  PRIMARY KEY (author_id)
  UNIQUE (first_name,last_name)
);

CREATE TABLE authoring
(
  index INT NOT NULL,
  position INT NOT NULL,
  author_id INT NOT NULL,
  PRIMARY KEY (index, position),
  FOREIGN KEY (index) REFERENCES research_paper(index),
  FOREIGN KEY (author_id) REFERENCES author(author_id)
);

CREATE TABLE citation
(
  index_1 INT NOT NULL,
  citationindex_2 INT NOT NULL,
  PRIMARY KEY (index_1, citationindex_2),
  FOREIGN KEY (index_1) REFERENCES research_paper(index),
  FOREIGN KEY (citationindex_2) REFERENCES research_paper(index),
  check(index_1 != citationindex_2)
);