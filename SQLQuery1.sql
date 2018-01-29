
select name from Hospitals where FREETEXT(Name,'郑州 建设  周口')

select name from Hospitals where FREETEXT(Name,'中原')


select IdCard_Name from Doctors where contains(IdCard_Name,'"扁鹊" or "刘"')

select IdCard_Name from Doctors where FREETEXT(IdCard_Name,'鼻')
select IdCard_Name from Doctors where contains(IdCard_Name,'华')

select Title,Content from CoteriePosts where Content like '%精心安排%'

select Title,CreateTime from CoteriePosts where freetext(title,'小儿发热') order by CreateTime desc


select COUNT(*) from CoteriePosts --1392640

----查询断字表
SELECT TOP 1000 * FROM sys.dm_fts_index_keywords(db_id('WiseMedical.20170823'), object_id('CoteriePosts')) where display_term like '%小%'

SELECT TOP 1000 * FROM sys.dm_fts_index_keywords(db_id('WiseMedical.20170823'), object_id('Doctors'))

SELECT TOP 1000 * FROM sys.dm_fts_index_keywords(db_id('WiseMedical.20170823'), object_id('DoctorDiseases'))



SELECT * FROM CoteriePosts where id='b5e4b75a-8603-4a29-928e-b2a6fd4dfe3f'
--update CoteriePosts set Title='测试图片裁剪2' where id='B5E4B75A-8603-4A29-928E-B2A6FD4DFE3F'

SELECT * from CoteriePosts where Roleuser_Id is null
select * from CoteriePosts where _Useful='1' and Roleuser_Id is not null

select  P.Id,P.Title,P.Content,P.CreateTime,P.Picture,P.Praise,P.[Read],P.Roleuser_Id,isnull(R.UserRole,0) as UserRole,U.Id as UserId,U.CellphoneNumber AS UserCellphoneNumber,U.IdCard_Name as UserIdCard_Name,U.Avatar as UserAvatar,U.Nick as UserNick,D.Id as DoctorId,D.CellphoneNumber as DoctorCellphoneNumber,D.IdCard_Name as DoctorIdCard_Name,D.Avatar as DoctorAvatar,D.Title as DoctorTitle,C.Picture as CoteriePicture,C.Id as CoterieId
from(SELECT Id, Title, Content, CreateTime, Coterie_Id, Roleuser_Id,Picture,Praise,[Read], row
from(SELECT Id, Title, Content, CreateTime, Coterie_Id, Roleuser_Id, Picture,Praise,[Read],ROW_NUMBER() over(order by createTime desc) as row FROM CoteriePosts where contains(Title,'测试')) as t 
where  row>0 and row<=10 )as P
left join Roleusers R ON R.Id = P.Roleuser_Id left join Users U ON U.Id = R.Id left join Doctors D on D.Id = R.Id left join Coteries C on c.Id=p.Coterie_Id


select distinct Title, Picture ,Coterie_Id from CoteriePosts where contains(Title,'测试') --order by CreateTime desc

select * from Doctors where contains(Licence_Name,'德') order by CreateTime desc

select D.Id,D.Licence_Name as DoctorName,D.Hospital_Id,H.Name as HospitalName,H.Id,DD.Disease
from Doctors D left join Hospitals H on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id
where D.Status=100 and( contains(D.Licence_Name,'德') or contains(H.Name,'德')) and DD.Disease in ('0100002','0100001','0100003')

select D.Id,D.Licence_Name as DoctorName,D.Hospital_Id,H.Name as HospitalName,H.Id, DD.Disease
from Doctors D left join Hospitals H on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id
where D.Status=100 and( contains(D.Licence_Name,'德') or contains(H.Name,'德') or contains(DD.Disease,'0100002'))

select distinct  D.Id,D.Licence_Name as DoctorName,D.Hospital_Id,H.Name as HospitalName,H.Id, DD.Disease
from Doctors D left join Hospitals H on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id
where D.Status=100 and( contains(D.Licence_Name,'德') or contains(H.Name,'德') or DD.Disease='0100001')

select distinct  D.Id,D.Licence_Name as DoctorName,D.Hospital_Id,H.Name as HospitalName,H.Id,DS.Score_Total,DS.Score_Count,
CASE when DS.Score_Count =0 THEN 0 ELSE cast((DS.Score_Total/(DS.Score_Count+0.0))*2 as decimal(9,1)) END AS Average
from Doctors D left join Hospitals H on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id  left join DoctorStatistics DS ON DS.Id=D.Id
where D.Status=100 and( contains(D.Licence_Name,'华') or contains(H.Name,'华') or DD.Disease='0100001') 
--order by CASE WHEN DS.Score_Count =0 THEN 0 ELSE ROUND(DS.Score_Total/DS.Score_Count*2,1) END 

select distinct  D.Id,D.Licence_Name as DoctorName,D.Hospital_Id,H.Name as HospitalName,H.Id,DS.Score_Total,DS.Score_Count,
CASE when DS.Score_Count =0 THEN 0 ELSE cast((DS.Score_Total/(DS.Score_Count+0.0))*2 as decimal(9,1)) END AS Average
from Doctors D left join Hospitals H on D.Hospital_Id=H.Id left join DoctorDiseases DD on D.Id=DD.Doctor_Id  left join DoctorStatistics DS ON DS.Id=D.Id
where D.Status=100 and( contains(D.Licence_Name,'德') or contains(H.Name,'德') or DD.Disease='0100001') 

--65070dda-0d75-43e7-8285-8336fc1cd12f 9.2
print ROUND(1.0*37/8*2,1)

print ROUND(3.45,1)  --3.50
--Console.WriteLine(Math.Round(3.44, 1)); //Returns 3.4.
--Console.WriteLine(Math.Round(3.45, 1)); //Returns 3.4.
--Console.WriteLine(Math.Round(3.46, 1)); //Returns 3.5.
--Console.WriteLine(Math.Round(4.34, 1)); // Returns 4.3
--Console.WriteLine(Math.Round(4.35, 1)); // Returns 4.4
--Console.WriteLine(Math.Round(4.36, 1)); // Returns 4.4
  
print  cast(37/(8+0.0)*2 as decimal(9,1)) 

select * from Doctors where id='C9FAA240-600D-4E45-9267-07C170B1FDC7'
select * from DoctorDiseases where Doctor_Id='E5218334-46D9-48A9-80C6-C5A740D213A6'

SELECT FT_TBL.IdCard_Name, KEY_TBL.RANK  
    FROM Doctors AS FT_TBL   
        INNER JOIN CONTAINSTABLE(Doctors, IdCard_Name,   
        'ISABOUT (德 WEIGHT (.8),   
        华 WEIGHT (.4), 阿凡达 WEIGHT (.2) )' ) AS KEY_TBL  
            ON FT_TBL.Id = KEY_TBL.[KEY]  
ORDER BY KEY_TBL.RANK DESC;  

SELECT *  
    FROM Doctors AS FT_TBL   
        INNER JOIN CONTAINSTABLE(Doctors, Licence_Name,   
        'ISABOUT (德 WEIGHT (.8),   
        华 WEIGHT (.4), 阿凡达 WEIGHT (.2) )' ) AS KEY_TBL  
            ON FT_TBL.Id = KEY_TBL.[KEY]  
ORDER BY KEY_TBL.RANK DESC;  

SELECT * FROM CONTAINSTABLE (Doctors,Licence_Name, '德 or 华') ORDER BY RANK DESC