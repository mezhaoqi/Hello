--用户手机号码为18800000000所推荐的用户
select uu.CellphoneNumber from Roleusers rr left join Users uu on rr.User_Id=uu.Id 
where rr.Referee=(select r.Code from Users u left join Roleusers r on u.Id=r.User_Id where u.CellphoneNumber='18800000000')  

--用户手机号码为18800000000所推荐的医生
select dd.CellphoneNumber from Roleusers rr left join Doctors dd on rr.Doctor_Id=dd.Id 
where rr.Referee=(select r.Code from Users u left join Roleusers r on u.Id=r.User_Id where u.CellphoneNumber='18800000000') 


--医生手机号码为18800000000所推荐的用户
select uu.CellphoneNumber from Roleusers rr left join Users uu on rr.User_Id=uu.Id 
where Referee=(select r.Code from Doctors d left join Roleusers r on d.Id=r.Doctor_Id where CellphoneNumber='18800000000')

--医生手机号码为18800000000所推荐的医生
select dd.CellphoneNumber from Roleusers rr left join Doctors dd on rr.Doctor_Id=dd.Id 
where Referee=(select r.Code from Doctors d left join Roleusers r on d.Id=r.Doctor_Id where CellphoneNumber='18800000000')


select * from Points where Action_Remark='分享收益' order by CreateTime desc

select * from Points  order by CreateTime desc

select * from Roleusers where Doctor_Id is not null