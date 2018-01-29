SELECT [Id],[CellphoneNumber],[CreateTime] ,[Grade],[Introduce] ,[Money],[Contact_Name] ,[PasswordHash],[PasswordHashForPayment],[Picture],[Status],[Contact_Type]
                         ,[Address_ADCode],[Address_Details],[Name],[Type],[Contact_Number],[Geolocation_Latitude],[Geolocation_Longitude],row 
						 from (SELECT [Id],[CellphoneNumber],[CreateTime] ,[Grade],[Introduce] ,[Money],[Contact_Name] ,[PasswordHash],[PasswordHashForPayment],[Picture],[Status],[Contact_Type]
                         ,[Address_ADCode],[Address_Details],[Name],[Type],[Contact_Number],[Geolocation_Latitude],[Geolocation_Longitude],ROW_NUMBER() over( order by  createTime desc) as row FROM HOSPITALS where contains(Content,'ͼƬ')) as t 
						 where  row>" + (0 * 20) + " and row<=" + ((0 + 1) * 20) + "


SELECT Title,Content,CreateTime row 
from (SELECT Title,Content,CreateTime, ROW_NUMBER() over( order by  createTime desc) as row FROM CoteriePosts where contains(Content,'ͼƬ')) as t 
						 where  row>" + (0 * 20) + " and row<=" + ((0 + 1) * 20) + "

SELECT Title,Content,CreateTime row 
from (SELECT Title,Content,CreateTime, ROW_NUMBER() over( order by  createTime desc) as row FROM CoteriePosts where contains(Content,'ͼƬ')) as t 
where  row>0 and row<=20

select * from CoteriePosts