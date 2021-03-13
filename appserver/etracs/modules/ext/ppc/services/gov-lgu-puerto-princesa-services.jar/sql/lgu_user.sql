[getUsers]
select * from sys_user where username <> 'admin'

[updatePassword]
update sys_user set pwd=$P{pwd} where objid=$P{objid} 
 