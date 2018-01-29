select Id, DoctorName,Hospital_Id,HospitalName,HospitalId,Score_Total,Score_Count,Average
from 
(select Id, DoctorName,Hospital_Id,HospitalName,HospitalId,Score_Total,Score_Count,Average,row
from
(select Id, DoctorName,Hospital_Id,HospitalName,HospitalId,Score_Total,Score_Count,Average,ROW_NUMBER() over(order by Average desc) as row
from
(select distinct  D.Id,D.Licence_Name as DoctorName,D.Hospital_Id,H.Name as HospitalName,H.Id as HospitalId,DS.Score_Total,DS.Score_Count,
CASE when DS.Score_Count =0 THEN 0 ELSE cast((DS.Score_Total/(DS.Score_Count+0.0))*2 as decimal(9,1)) END AS Average
from Doctors D left join Hospitals H on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id  left join DoctorStatistics DS ON DS.Id=D.Id
where D.Status=100 and( contains(D.Licence_Name,'李') or contains(H.Name,'李') or DD.Disease='0100001') )
as table1) as t
where  row>0 and row<=10) as p


select Id, DoctorName,Title,HospitalName,HospitalId,Score_Total,Score_Count,Average,row
from
(
select Id, DoctorName,Title,HospitalName,HospitalId,Score_Total,Score_Count,Average,ROW_NUMBER() over(order by Average desc) as row
from
(
select distinct  D.Id,D.Licence_Name as DoctorName,D.Title,H.Name as HospitalName,H.Id as HospitalId,DS.Score_Total,DS.Score_Count,
CASE when DS.Score_Count =0 THEN 0 ELSE cast((DS.Score_Total/(DS.Score_Count+0.0))*2 as decimal(9,1)) END AS Average
from Doctors D left join Hospitals H on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id  left join DoctorStatistics DS ON DS.Id=D.Id
where D.Status=100 and( contains(D.Licence_Name,'德') or contains(H.Name,'德'))
 )
as temp
) as temp2
where  row>0 and row<=10

--医院搜索
select Id,Name,Address_ADCode,Address_Details,Grade,Type,row
from
(
select Id,Name,Address_ADCode,Address_Details,Grade,Type,ROW_NUMBER() over(order by Name desc) as row
from
(
select distinct H.Id,H.Name,H.CellphoneNumber,Address_ADCode,Address_Details,Grade,Type
from Hospitals H left join Doctors D on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id 
where H.Status=1 and(FREETEXT(H.Name,'中心*')or FREETEXT(D.Licence_Name,'中心*'))
 )
as temp
) as temp2
where  row>0 and row<=100

select Id,Name,CellphoneNumber,Address_ADCode,Address_Details,Grade,Type,row
from
(
select Id,Name,CellphoneNumber,Address_ADCode,Address_Details,Grade,Type,ROW_NUMBER() over(order by Name desc) as row
from
(
select distinct H.Id,H.Name,H.CellphoneNumber,Address_ADCode,Address_Details,Grade,Type
from Hospitals H left join Doctors D on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id  where H.Status=1 and(contains(H.Name,'华')or contains(D.Licence_Name,'华'))
) as temp )
 as temp2 
where  row>0 and row<=100



select distinct Id,Name
from Hospitals
where Status=1 and(contains(Name,'郑州市'))

select Id,Name from Hospitals where Status=1 and name like '%中心%'

SELECT TOP 1000 * FROM sys.dm_fts_index_keywords(db_id('WiseMedical.20170823'), object_id('Hospitals')) where display_term='上海'


select Id, DoctorName,Hospital_Id,HospitalName,HospitalId,Score_Total,Score_Count,Average,row
from
(
select Id, DoctorName,Hospital_Id,HospitalName,HospitalId,Score_Total,Score_Count,Average,ROW_NUMBER() over(order by Average desc) as row
from
(
select distinct  D.Id,D.Licence_Name as DoctorName,D.Hospital_Id,H.Name as HospitalName,H.Id as HospitalId,DS.Score_Total,DS.Score_Count,
CASE when DS.Score_Count =0 THEN 0 ELSE cast((DS.Score_Total/(DS.Score_Count+0.0))*2 as decimal(9,1)) END AS Average
from Doctors D left join Hospitals H on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id  left join DoctorStatistics DS ON DS.Id=D.Id
where D.Status=100 and( contains(D.Licence_Name,'李') or contains(H.Name,'李') or DD.Disease='0100001')
 )
as temp
) as temp2
where  row>10 and row<=20
