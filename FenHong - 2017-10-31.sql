
IF EXISTS (SELECT * FROM sysobjects where name='FenHong')
 drop procedure FenHong
GO
CREATE PROCEDURE FenHong

AS
declare @userSettlement int

declare @businessbonus decimal(18,2)  --��ʷ������
declare @oldbonus decimal(18,2)   --��ʷ����
declare @oldfenhong decimal(18, 2)  --��ʷ�ֺ���
declare @oldfenhongkou decimal(18,2)  --�ֺ�۳�

declare @kou decimal(18,2) 
declare @reshop decimal(18,2)

declare @today decimal(18,2)  --�ս���
declare @todayFD decimal(18,2)   --�շⶥ

declare @fhuserid int

declare @bsxf decimal(18, 2)  --��˰�ٷֱ�
declare @breshop decimal(18,2) --�������ٷֱ�

declare @fh decimal(18, 2)  --�ֺ� ��˰��

declare @fenhong decimal(18, 2)   --�ֺ�

declare @Balance decimal(18, 2)  --���
declare @Fenhongye decimal(18,2) --�˻��ֺ����
declare @usertype int

declare @yestarday datetime

declare @OneSingleMoney decimal(18, 2)
declare @fenhong_ye decimal(18, 2)  --�ֺ����

--2017-10-24�޸����
declare @stateTime datetime  --���ʱ��
declare @time1 datetime --2017-11-1
declare @time2 datetime  --2018-4-1  
declare @now datetime  --����ʱ��
declare @tui int  --�Ƽ�����

BEGIN TRY
BEGIN TRANSACTION

SELECT @bsxf=Tax/100 ,@OneSingleMoney=OneSingleMoney,@breshop=ReShop/100 FROM BonusConfigs;
set @yestarday=convert(varchar(10),getdate(),120)+' 00:00:00' --��ǰ�������

set @time1='2017-11-1 00:00:00'
set @time2='2018-4-1 00:00:00'
set @now=getdate()

select * into #Moneys from Moneys where 1=0
select * into #BonusLogs  from BonusLogs where 1=0
CREATE TABLE #MoneyLogs(
	[Id] [uniqueidentifier] ,
	[Expenses] [decimal](18, 2) ,
	[Income] [decimal](18, 2) ,
	[Balance] [decimal](18, 2) ,
	[UserId] [int] ,
	[LogTypeId] [int] ,
	[MoneyTypeId] [int] ,
	[PubTime] [datetime]
)

declare cur  CURSOR FOR

SELECT	u.Id,
		u.UserTypeId,
		u.StateTime,
		isnull(k.tui, 0)as tui,
		u.Settlement,		
		isnull(today_money, 0) AS today,
		CASE WHEN u.UserTypeId = 1 THEN	5000 ELSE 10000	END AS todayFD,
		t.FenHong AS fenhong,
		m.Fenhong,
		m.BusinessBonusTotal, 
		m.BonusTotal, 
		m.FenhongTotal, 
		m.FenhongKouTotal
FROM
	UserInfoes u
LEFT JOIN (	SELECT
				UserId,
				SUM ([Money]) AS today_money
			FROM
				BonusLogs
			WHERE
				PubTime >convert(varchar(10),getdate(),120)+' 00:00:00'
			GROUP BY
				UserId
		) b ON u.id = b.userid
LEFT JOIN UserTypes t ON u.UserTypeId = t.id
INNER JOIN Moneys m ON m.UserId=u.id
left join (select rec.id, count(rec.Id)as tui FROM UserInfoes AS rec INNER JOIN UserInfoes as n ON rec.Id=n.Recommend
WHERE n.usertypeid<=rec.usertypeid and n.state=1 group by rec.id) as k on u.id=k.id
WHERE
NOT EXISTS(SELECT 1 FROM BonusLogs WHERE UserId=u.id and fenhong>0 and PubTime>convert(varchar(10),getdate(),120)+' 00:00:00')
AND	t.fenhong > 0
AND u.State = 1
AND u.Lock = 0
AND u.FHLock = 0

   
OPEN cur
FETCH NEXT FROM cur INTO @fhuserid,@usertype,@stateTime,@tui,@userSettlement,@today,@todayFD,@fenhong,@Fenhongye,@businessbonus,@oldbonus,@oldfenhong,@oldfenhongkou

while (@@fetch_status=0)
BEGIN
			--2017-2-10  ��̬�ر� ֹͣ�ֺ�
			if(@oldbonus-@oldfenhong+@businessbonus>=@userSettlement*@OneSingleMoney)
			begin
				goto lable_end
			end
			else
			begin	
				if(@fenhong+@oldbonus+@businessbonus>=@userSettlement*@OneSingleMoney)
				begin
					set @fenhong=@userSettlement*@OneSingleMoney-@oldbonus-@businessbonus
				end
				if(@fenhong<=0)
				begin
					goto lable_end
				end	

				--2017-10-24�޸� 
				--��2017��11.1�����¼��˵ľ�����ÿ�쾲̬�ֺ�10.5/������ÿ�쾲̬�ֺ�21�����Ƽ�һ���ˣ������Ƽ�ͬ������߸�һ������ģ���ڶ���ֺ���21����42����
				--11.1����ǰ���˵ķֺ첻�䣬�������ʱ�䣬������Ժ���ͳһ����

				if(@now>@time1) --2017.11.1��ʼ
				begin
					if(@stateTime<@time1) --�ϻ�Ա
					begin
						if(@now>@time2) --5���º���ͳһ����
						begin
							if(@tui=0)
							set @fenhong=@fenhong/2
						end
					end
					else if(@stateTime>@time1)  --�»�Աû�Ƽ� �ֺ����
					begin
						if(@tui=0)
						set @fenhong=@fenhong/2
					end
				end

				if(@fenhong+@oldfenhong>=@userSettlement*@OneSingleMoney)
				begin
					set @fenhong=@userSettlement*@OneSingleMoney-@oldfenhong
				end

				set @kou = 0;
                set @reshop = 0;

				if(@fenhong>0)
				begin
					set @kou=@fenhong*@bsxf
					set @reshop=@fenhong*@breshop

					set @fh=@fenhong-@kou-@reshop
								
	
					if(@fh+@today>=@todayFD)
					begin	
						set @fh=@todayFD-@today
					end
						
					if(@fh<=0)
					begin
						goto lable_end
					end
		
--					print @fhuserid; --6-15����
--					print getdate();

					insert into #Moneys (UserId,FenHong,ReShop,FenhongKouTotal,BonusTotal, FenhongTotal,Consumption,ElectronicMoney,StockMoney,BusinessBonusTotal,shop) 
						  values (@fhuserid,@fh,@reshop,@kou+@reshop,@fenhong,@fenhong,0,0,0,0,0)

					insert into #BonusLogs (Id,[Money],Buckle,ReShop,ReShopBonus,Recommend,FenHong,LayClash,Clash,Leadership,PubTime,UserId,FromUserId,Lock)
						  values(newid(),@fh,@kou,@reshop,0,0,@fenhong,0,0,0,GETDATE(),@fhuserid,@fhuserid,'false')

					set @fenhong_ye=@Fenhongye+@fh

					insert into #MoneyLogs (Id,Balance,Expenses,Income,MoneyTypeId,UserId,LogTypeId,PubTime)
					      values(newid(),@fenhong_ye,0,@fh,4,@fhuserid,1,GETDATE());

				end

			end 
lable_end:
		 FETCH NEXT FROM cur INTO @fhuserid,@usertype,@stateTime,@tui,@userSettlement,@today,@todayFD,@fenhong,@Fenhongye,@businessbonus,@oldbonus,@oldfenhong,@oldfenhongkou

END 

insert into BonusLogs ([Id]
      ,[Money]
      ,[Buckle]
      ,[ReShop]
      ,[ReShopBonus]
      ,[Recommend]
      ,[FenHong]
      ,[LayClash]
      ,[Clash]
      ,[Leadership]
      ,[PubTime]
      ,[UserId]
      ,[FromUserId]
      ,[Lock])
select [Id]
      ,[Money]
      ,[Buckle]
      ,[ReShop]
      ,[ReShopBonus]
      ,[Recommend]
      ,[FenHong]
      ,[LayClash]
      ,[Clash]
      ,[Leadership]
      ,[PubTime]
      ,[UserId]
      ,[FromUserId]
      ,[Lock]
 from #BonusLogs 
insert into MoneyLogs ([Id]
      ,[Expenses]
      ,[Income]
      ,[Balance]
      ,[UserId]
      ,[LogTypeId]
      ,[MoneyTypeId]
      ,[PubTime])
select [Id]
      ,[Expenses]
      ,[Income]
      ,[Balance]
      ,[UserId]
      ,[LogTypeId]
      ,[MoneyTypeId]
      ,[PubTime] from #MoneyLogs 
update a set a.FenHong=b.FenHong+a.fenhong,a.ReShop=b.ReShop+a.reshop,a.FenhongKouTotal=b.FenhongKouTotal+a.FenhongKouTotal,a.BonusTotal=b.BonusTotal+a.BonusTotal,a.FenhongTotal=b.FenhongTotal+a.FenhongTotal from Moneys a, #Moneys b where a.userid=b.userid 

COMMIT TRANSACTION
drop table #Moneys
drop table #MoneyLogs
drop table #BonusLogs

CLOSE cur
DEALLOCATE cur

END TRY
BEGIN CATCH

print 'error'

CLOSE cur
DEALLOCATE cur
drop table #Moneys
drop table #MoneyLogs
drop table #BonusLogs
ROLLBACK TRANSACTION
END CATCH

--exec fenhong2

