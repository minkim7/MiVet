USE [MiVet]
GO
/****** Object:  StoredProcedure [dbo].[Practices_Select_ByCreatedBy]    Script Date: 10/23/2022 7:26:21 AM ******/
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
-- MODIFIED DATE:09/30/2022
-- Code Reviewer:
-- Note:
-- =============================================
CREATE proc [dbo].[Practices_Select_ByCreatedBy]
					@PageIndex int
					,@PageSize int
					,@UserId int
					

/*

declare @PageIndex int = 0
		,@PageSize int = 3
		,@UserId int = 31
execute dbo.Practices_Select_ByCreatedBy
					@PageIndex 
					,@PageSize 
					,@UserId 

    set @PageIndex  = 1

execute dbo.Practices_Select_ByCreatedBy
					@PageIndex 
					,@PageSize 
					,@UserId 
sdss
*/
as				

begin
DECLARE @offset int = @PageIndex * @PageSize
select p.Id
		,p.Name
		,p.Description
		,PrimaryImage = (select Id,Name,Url,FileTypeId
								--,FileType = (select Id, Name from dbo.FileTypes where Id = FileTypeId for json auto)
						from dbo.Files
						where Id = P.PrimaryImageId
						for json auto
							)
		,l.Id as LocationId
		,lt.Id as LocationTypeId
		,lt.Name as LocationTypeName
		,l.LineOne
		,l.LineTwo
		,l.City
		,l.Zip
		,st.Id as StateId
		,st.Name as StateName
		,l.Latitude
		,l.Longitude
		,l.DateCreated
		,l.DateModified
		,l.CreatedBy
		,l.ModifiedBy
		,p.Phone
		,p.Fax
		,p.BusinessEmail
		,p.SiteUrl
		,[Services] = (select S.Id,[Name],ServiceTypeId, [Description],[Total]
							,[ServiceCode],S.[IsActive]  
							from dbo.[Services] as S
							inner join dbo.VetServices as VS
							on VS.ServiceId = S.Id
							inner join dbo.VetPractices as VPT
							on VPT.VetProfileId = vs.VetProfileId
							where VPT.PracticeId = P.Id 
						for json auto)
		,Schedule = (	select Id,S.Name
								--,vetProfile = (select Id,Bio,Phone,BusinessEmail,EmergencyLine 
								--				from dbo.VetProfiles as VP 
								--				where vp.Id = VetProfileId for json auto)
						from dbo.Schedules as S
						where p.ScheduleId = Id
						for json auto)
		
		,p.DateCreated
		,p.DateModified
		,CreatedBy = (select Id, FirstName, Mi, LastName, Email, AvatarUrl
						from dbo.Users
						where Id = p.CreatedBy
						for json auto)
		,ModifiedBy = (select Id, FirstName, Mi, LastName, Email, AvatarUrl
						from dbo.Users
						where Id = p.ModifiedBy
						for json auto)
		,P.IsActive
	  ,TotalCount = Count(1) Over()
  FROM [dbo].[Practices] As P
	 inner join dbo.Locations as L
	on P.LocationId = l.Id	
	inner join dbo.LocationTypes as lt
	on l.LocationTypeId = lt.Id
	inner join dbo.States as st
	on st.Id = l.StateId
	inner join dbo.Users as U
	on U.Id = P.CreatedBy
  
 where P.CreatedBy = @UserId AND (P.IsActive = 1)
					
  Order by P.Id
  
			OFFSET @offset ROWS
			FETCH NEXT @PageSize ROWS ONLY

  End

GO
