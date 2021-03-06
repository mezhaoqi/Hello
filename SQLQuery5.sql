select  P.Id,
P.Title,P.Content,P.CreateTime,P.Picture,P.Praise,P.[Read],P.Roleuser_Id,isnull(R.UserRole,0) as UserRole,U.Id as UserId,
U.CellphoneNumber AS UserCellphoneNumber,U.IdCard_Name as UserIdCard_Name,U.Avatar as UserAvatar,U.Nick as UserNick,D.Id as DoctorId,
D.CellphoneNumber as DoctorCellphoneNumber,D.IdCard_Name as DoctorIdCard_Name,D.Avatar as DoctorAvatar,D.Title as DoctorTitle,
C.Picture as CoteriePicture,
C.Id as CoterieId
from(SELECT Id, Title, Content, CreateTime, Coterie_Id, Roleuser_Id,Picture,Praise,[Read], row
from(SELECT Id, Title, Content, CreateTime, Coterie_Id, Roleuser_Id, Picture,Praise,[Read],ROW_NUMBER() over(order by createTime desc) as row FROM CoteriePosts where contains(Title,'测试')) as t 
where  row>0 and row<=10 )as P
left join Roleusers R ON R.Id = P.Roleuser_Id left join Users U ON U.Id = R.Id left join Doctors D on D.Id = R.Id left join Coteries C on c.Id=p.Coterie_Id


select distinct  Doc.Id,Doc.Licence_Name,Doc.Hospital_Id,H.Name,Doc.Title,Doc.Status,DS.Score_Total,DS.Score_Count
from(select  Id,Licence_Name,Hospital_Id,Title,Status,row
from(select  Id,Licence_Name,Hospital_Id,Title,Status,ROW_NUMBER() over (order by createtime desc) as row from Doctors) as D
where row>0 and row<=10 )as Doc
left join Hospitals H on Doc.Hospital_Id=H.Id left join DoctorDiseases DD on Doc.Id=DD.Doctor_Id  left join DoctorStatistics DS ON DS.Id=Doc.Id
where Doc.Status=100 and ( contains(Doc.Licence_Name,'德') or contains(H.Name,'德') or DD.Disease='0100001') 



select distinct  D.Id,D.Licence_Name as DoctorName,D.Hospital_Id,H.Name as HospitalName,H.Id,DS.Score_Total,DS.Score_Count,
CASE when DS.Score_Count =0 THEN 0 ELSE cast((DS.Score_Total/(DS.Score_Count+0.0))*2 as decimal(9,1)) END AS Average
from Doctors D left join Hospitals H on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id  left join DoctorStatistics DS ON DS.Id=D.Id
where D.Status=100 and( contains(D.Licence_Name,'德') or contains(H.Name,'德') or DD.Disease='0100001') 


select distinct D.Id,D.Licence_Name,H.Name from Doctors D
left join Hospitals as H on H.Id=D.Hospital_Id 
left join DoctorDiseases as DD on DD.Doctor_Id=D.Id
where  D.Status=100 and( contains(H.Name,'德') or contains(D.Licence_Name,'德'))

select distinct D.Id,D.Licence_Name,H.Name from DoctorDiseases as DD
left join Doctors as D on DD.Doctor_Id=D.Id
left join Hospitals as H on H.Id=D.Hospital_Id
where D.Status=100 and( contains(H.Name,'德') or contains(D.Licence_Name,'德'))

select  Id, DoctorName,Hospital_Id,HospitalName,HospitalId,Score_Total,Score_Count,Average 
from(select distinct  D.Id,D.Licence_Name as DoctorName,D.Hospital_Id,H.Name as HospitalName,H.Id as HospitalId,DS.Score_Total,DS.Score_Count,
CASE when DS.Score_Count =0 THEN 0 ELSE cast((DS.Score_Total/(DS.Score_Count+0.0))*2 as decimal(9,1)) END AS Average
from Doctors D left join Hospitals H on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id  left join DoctorStatistics DS ON DS.Id=D.Id
where D.Status=100 and( contains(D.Licence_Name,'李') or contains(H.Name,'李') or DD.Disease='0100001') ) as temp
order by temp.Average desc

--select Id, DoctorName,Hospital_Id,HospitalName,HospitalId,Score_Total,Score_Count,Average
--from (select Id, DoctorName,Hospital_Id,HospitalName,HospitalId,Score_Total,Score_Count,Average,row
--from(select Id, DoctorName,Hospital_Id,HospitalName,HospitalId,Score_Total,Score_Count,Average,ROW_NUMBER() order(order by Average desc) as row
--from
--(select Id, DoctorName,Hospital_Id,HospitalName,HospitalId,Score_Total,Score_Count,Average 
--from(select distinct  D.Id,D.Licence_Name as DoctorName,D.Hospital_Id,H.Name as HospitalName,H.Id as HospitalId,DS.Score_Total,DS.Score_Count,
--CASE when DS.Score_Count =0 THEN 0 ELSE cast((DS.Score_Total/(DS.Score_Count+0.0))*2 as decimal(9,1)) END AS Average
--from Doctors D left join Hospitals H on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id  left join DoctorStatistics DS ON DS.Id=D.Id
--where D.Status=100 and( contains(D.Licence_Name,'李') or contains(H.Name,'李') or DD.Disease='0100001') ) as temp
--order by temp.Average desc)
--as Dtable

--where row>0 and row<=10 )as p





select Id,DoctorName,r from
(
SELECT D.Id,D.Licence_Name as DoctorName, KEY_D.RANK as r
FROM Doctors AS D   
        INNER JOIN CONTAINSTABLE(Doctors, IdCard_Name,
        'ISABOUT (德 WEIGHT (.8)
         )' ) AS KEY_D
            ON D.Id = KEY_D.[KEY]
ORDER BY KEY_D.RANK DESC ) as Doctor


select Name,Status from Hospitals
