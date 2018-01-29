--医生搜索
select Id, DoctorName,CellphoneNumber,Title,Department,HospitalName,HospitalId,Score_Total,Score_Count,ConsultCount,Average,row
from
(
select Id, DoctorName,CellphoneNumber,Title,Department, HospitalName,HospitalId,Score_Total,Score_Count,Average,ConsultCount,ROW_NUMBER() over(order by Average desc) as row
from
(
select distinct  D.Id,D.Licence_Name as DoctorName,D.CellphoneNumber,D.Title,D.Department,H.Name as HospitalName,H.Id as HospitalId,DS.Score_Total,DS.Score_Count,DS.ConsultCount,
CASE when DS.Score_Count =0 THEN 0 ELSE cast((DS.Score_Total/(DS.Score_Count+0.0))*2 as decimal(9,1)) END AS Average
from Doctors D left join Hospitals H on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id  left join DoctorStatistics DS ON DS.Id=D.Id
where D.Status=100 and( contains(D.Licence_Name,'德') or contains(H.Name,'德'))
 )
as temp
) as temp2
where  row>0 and row<=100


select count(*) from (
select distinct D.Id 
from Doctors D left join Hospitals H on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id
where D.Status=100 and( contains(D.Licence_Name,'德') or contains(H.Name,'德') or DD.Disease='0100001')
) temp

select count(*) from(select distinct D.Id from Doctors D left join Hospitals H on D.Hospital_Id = H.Id left join DoctorDiseases DD on D.Id = DD.Doctor_Id where 1=1 and D.Status=100 and (contains(D.Licence_Name,'德') or contains(H.Name,'德'))) temp

--医院搜索
select Id,Name,Address_ADCode,Address_Details,Grade,Type,DoctorCount,row
from
(
select Id,Name,Address_ADCode,Address_Details,Grade,Type,DoctorCount,ROW_NUMBER() over(order by Name desc) as row
from
(
select distinct H.Id,H.Name,H.CellphoneNumber,Address_ADCode,Address_Details,Grade,Type,ISNULL( Temp.DoctorCount,0) AS DoctorCount
from Hospitals H left join Doctors D on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id 
left join (select Hos.Id ,count(Doc.Id) as DoctorCount from Doctors Doc inner join Hospitals Hos on Doc.Hospital_Id=Hos.Id where Doc.Status=100 group by Hos.Id) AS Temp ON H.Id=Temp.Id
where H.Status=1 and(CONTAINS(H.Name,'中原')or CONTAINS(D.Licence_Name,'中原'))
 )
as temp
) as temp2
where  row>0 and row<=100

select *  from Doctors where Hospital_Id='BDA27D5F-E858-4875-A598-0278A30B4BA6' and Status=100

select * from
(select * ,ROW_NUMBER() over(order by CreateTime desc) as row from Informations where _Useful=1 and Video is null and Forum=1000 and contains(Title,'皮炎')) as temp
where  row>5 and row<=10





select * from Informations where Video is not null and freetext(Title,'黑') order by CreateTime desc

SELECT TOP 1000 * FROM sys.dm_fts_index_keywords(db_id('WiseMedical.20170823'), object_id('Hospitals')) where display_term='郑州'
 

 select Id,Name from Hospitals where Status=1 and name like '%郑州%'

 
select name from Hospitals where FREETEXT(Name,'*中心*')

select * from Informations where Video is null and Forum=1000 and contains(Title,'科技')

select * from Informations where Video is null and Forum=1000 and freetext(Title,'科技')


select Id,Name,CellphoneNumber,Address_ADCode,Address_Details,Grade,Type,DoctorCount
from
(
select distinct top 5 H.Id,H.Name,H.CellphoneNumber,Address_ADCode,Address_Details,Grade,Type,ISNULL( Temp.DoctorCount,0) AS DoctorCount ,H.CreateTime
from Hospitals H left join Doctors D on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id 
left join (select Hos.Id ,count(Doc.Id) as DoctorCount from Doctors Doc inner join Hospitals Hos on Doc.Hospital_Id=Hos.Id where Doc.Status=100 group by Hos.Id) 
AS Temp ON H.Id=Temp.Id 
where H.Status=1 and (contains(H.Name,'郑州')) 
order by H.CreateTime
) as temp


 select * from Hospitals
  where Status=1 and (contains(Name,'郑州'))
  order by geography::Point(Geolocation_Latitude,Geolocation_Longitude, 4326).STDistance(geography::Point(34.773308,113.731095, 4326))

  select Id,Name,CellphoneNumber,Address_ADCode,Address_Details,Grade,Type,DoctorCount,CreateTime,row
from
(
select Id,Name,CellphoneNumber,Address_ADCode,Address_Details,Grade,Type,DoctorCount,CreateTime,ROW_NUMBER() over(order by CreateTime) as row
from
(
select distinct H.Id,H.Name,H.CellphoneNumber,Address_ADCode,Address_Details,Grade,Type,ISNULL( Temp.DoctorCount,0) AS DoctorCount,H.CreateTime
from Hospitals H left join Doctors D on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id 
left join (select Hos.Id ,count(Doc.Id) as DoctorCount from Doctors Doc inner join Hospitals Hos on Doc.Hospital_Id=Hos.Id where Doc.Status=100 group by Hos.Id) AS Temp ON H.Id=Temp.Id 
where H.Status=1 and (contains(H.Name,'郑州'))
) as temp
) as temp2
where row >0 and row<=2






