USE [MiVet]
GO
/****** Object:  StoredProcedure [dbo].[Practices_Insert]    Script Date: 10/23/2022 7:26:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: <Min Su Kim>
-- Create date: <09/21/2022>
-- Description: <Practices insert proc>
-- Code Reviewer:

-- MODIFIED BY: author
-- MODIFIED DATE:09/29/2022
-- Code Reviewer:
-- Note:
-- =============================================

CREATE proc [dbo].[Practices_Insert]
				@Name nvarchar(200) 
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
				,@VetProfileIds dbo.VetProfileTable readonly
				,@UserId int
				,@Id int output
				
				
as
/*
ssssssssd
		
	declare		@Name nvarchar(200) = 'Practice sdfsdfs '
				,@Description nvarchar(max) ='descriptionsdfsdf'
				,@PrimaryImageId int = 300
				,@LineOne nvarchar(200)= 'Line One Address 1233'
				,@LineTwo nvarchar(200)= 'Line Two 123123'
				,@City nvarchar(200) = 'city'
				,@Zip nvarchar(50) = 'zip'
				,@StateId int = 5
				,@Latitude float = 55.55
				,@Longitude float = 55.55
				,@LocationTypeId int = 3
				,@Phone varchar(50) = '213-000-0000'
				,@Fax varchar(50) = '213-000-0000'
				,@BusinessEmail nvarchar(255) = 'busEmail@example.com'
				,@SiteUrl nvarchar(200) = 'https://site.com'
				,@ScheduleId int = 10
				,@UserId int = 31
				,@Id int = 0
				,@newVetIds dbo.VetProfileTable

	insert into @newVetIds(VetProfileId)
	values(4)
	insert into @newVetIds(VetProfileId)
	values(7)


execute dbo.Practices_Insert
				
				@Name 
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
				,@newVetIds
				,@UserId 
				,@Id OUtput

execute [dbo].[Practices_Select_ById]
				@Id

				sdesd
				 


*/
begin

Declare @DateNow datetime2 = GetUTCDATE();
declare @LocationId int ;
	
	

	

	insert into dbo.Locations
				(LineOne
				,LineTwo
				,City
				,Zip
				,StateId
				,Latitude
				,Longitude
				,LocationTypeId
				,CreatedBy)
	values		(@LineOne
				,@LineTwo
				,@City
				,@Zip
				,@StateId
				,@Latitude
				,@Longitude
				,@LocationTypeId
				,@UserId)

		set @LocationId = SCOPE_IDENTITY();
	


	

	insert into dbo.Practices	
				(
				Name
				,Description
				,PrimaryImageId
				,LocationId
				,Phone
				,Fax
				,BusinessEmail
				,SiteUrl
				,ScheduleId
				,DateCreated
				,DateModified
				,CreatedBy
				,ModifiedBy
				)

	values
				(@Name
				,@Description
				,@PrimaryImageId
				,@LocationId
				,@Phone
				,@Fax
				,@BusinessEmail
				,@SiteUrl
				,@ScheduleId
				,@DateNow
				,@DateNow
				,@UserId
				,@UserId)
	Set @Id = SCOPE_IDENTITY();

	insert into dbo.VetPractices 
				(PracticeId, VetProfileId)

	select @Id , vets.Id 
			from dbo.VetProfiles as Vets
			where exists (select 1 from @VetProfileIds as VetIds
							where vets.Id = VetIds.VetProfileId)


end
GO
