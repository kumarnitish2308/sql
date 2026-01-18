create table tree
(
 node int,
 parent int 
);

insert into tree(node,parent)
values

(1,2),
(3,2),
(6,8),
(9,8),
(2,5),
(8,5),
(5,null);



select node,
	case
    	when parent is null then 'root'
        when node not in (select distinct parent from tree where parent is not null) then 'leaf'
    else 'Inner' end as type
from tree
order by node
