USE [MiVet]
GO
/****** Object:  StoredProcedure [dbo].[Practices_Update]    Script Date: 10/23/2022 7:26:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: <Min Su Kim>
-- Create date: <09/21/2022>
-- Description: <Practices update proc>
-- Code Reviewer:

-- MODIFIED BY: author
-- MODIFIED DATE:09/29/2022
-- Code Reviewer:
-- Note:
-- =============================================

CREATE proc [dbo].[Practices_Update]
				@Id int 
				,@Name nvarchar(200) 
				,@Description nvarchar(max)
				,@PrimaryImageId int
				,@LineOne nvarchar(200)
				,@LineTwo nvarchar(200)
				,@City nvarchar(200)
				,@Zip nvarchar(50)
				,@StateId int
				,@Latitude float
				,@Longitude float
				,@LocationTypeId int
				,@Phone varchar(50)
				,@Fax varchar(50)
				,@BusinessEmail nvarchar(255)
				,@SiteUrl nvarchar(200)
				,@ScheduleId int
				,@UserId int
				
				
				
as
/*
ssssssfgg
select *
from dbo.Practices
where Id = 5
		Declare @Id int = 22
				,@Name nvarchar(200)  = 'Name updated'
				,@Description nvarchar(max) ='description updated'
				,@PrimaryImageId int = 300
				,@LineOne nvarchar(200) ='updated Line ONe'
				,@LineTwo nvarchar(200) = 'updated Line Two'
				,@City nvarchar(200) = 'updated City'
				,@Zip nvarchar(50) = 'updated Zip'
				,@StateId int = 5
				,@Latitude float = 77.77
				,@Longitude float = 77.77
				,@LocationTypeId int = 3
				,@Phone varchar(50) = '714-000-0000'
				,@Fax varchar(50) = '714-000-0000'
				,@BusinessEmail nvarchar(255) = 'updated@example.com'
				,@SiteUrl nvarchar(200) ='https://updated.url.com'
				,@ScheduleId int = 10
				,@UserId int= 40
Select *
from dbo.Practices
where Id = @Id

	Execute dbo.Practices_Update
				@Id 
				,@Name 
				,@Description 
				,@PrimaryImageId
				,@LineOne 
				,@LineTwo 
				,@City 
				,@Zip
				,@StateId 
				,@Latitude 
				,@Longitude 
				,@LocationTypeId 
				,@Phone 
				,@Fax 
				,@BusinessEmail 
				,@SiteUrl 
				,@ScheduleId 
				,@UserId 

	select *
	From dbo.Practices As P
	where P.Id = @Id
*/
begin

Declare @DateNow datetime2 = GetUTCDATE();

Declare @LocationId	int


	
	
	


	update dbo.Locations
	set LocationTypeId = @LocationTypeId
		,LineOne = @LineOne
		,LineTwo =@LineTwo
		,City = @City
		,Zip = @Zip
		,StateId = @StateId
		,Latitude = @Latitude
		,Longitude =@Longitude
		,ModifiedBy = @UserId
		where Id =(Select LocationId from dbo.Practices where Id =@Id)


	Update dbo.Practices
	set Name=@Name
		,Description = @Description
		,Phone = @Phone
		,Fax = @Fax
		,BusinessEmail = @BusinessEmail
		,SiteUrl = @SiteUrl
		,ScheduleId = @ScheduleId
		,DateModified = @DateNow
		,ModifiedBy = @UserId
		,PrimaryImageId = @PrimaryImageId
	where Id = @Id
	

end
GO
