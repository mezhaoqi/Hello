--�û��ֻ�����Ϊ18800000000���Ƽ����û�
select uu.CellphoneNumber from Roleusers rr left join Users uu on rr.User_Id=uu.Id 
where rr.Referee=(select r.Code from Users u left join Roleusers r on u.Id=r.User_Id where u.CellphoneNumber='18800000000')  

--�û��ֻ�����Ϊ18800000000���Ƽ���ҽ��
select dd.CellphoneNumber from Roleusers rr left join Doctors dd on rr.Doctor_Id=dd.Id 
where rr.Referee=(select r.Code from Users u left join Roleusers r on u.Id=r.User_Id where u.CellphoneNumber='18800000000') 


--ҽ���ֻ�����Ϊ18800000000���Ƽ����û�
select uu.CellphoneNumber from Roleusers rr left join Users uu on rr.User_Id=uu.Id 
where Referee=(select r.Code from Doctors d left join Roleusers r on d.Id=r.Doctor_Id where CellphoneNumber='18800000000')

--ҽ���ֻ�����Ϊ18800000000���Ƽ���ҽ��
select dd.CellphoneNumber from Roleusers rr left join Doctors dd on rr.Doctor_Id=dd.Id 
where Referee=(select r.Code from Doctors d left join Roleusers r on d.Id=r.Doctor_Id where CellphoneNumber='18800000000')


select * from Points where Action_Remark='��������' order by CreateTime desc

select * from Points  order by CreateTime desc

select * from Roleusers where Doctor_Id is not null