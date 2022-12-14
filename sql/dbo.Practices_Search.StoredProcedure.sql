USE [MiVet]
GO
/****** Object:  StoredProcedure [dbo].[Practices_Search]    Script Date: 10/23/2022 7:26:20 AM ******/
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

CREATE proc [dbo].[Practices_Search]
					@PageIndex int
					,@PageSize int
					,@Query nvarchar(200)

/*
ssdsdfs
declare @Query nvarchar(200) = 'Practice'
execute dbo.Practices_Search
			0
			,3
			,@Query
				

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
		,Locations = ( select Id,
							LineOne,LineTwo,City,Zip 
							--,State = (Select Id,Name
							--			from dbo.States
							--			where stateId= Id
							--			for json auto)
							,Latitude,Longitude
					from dbo.Locations
					where Id = P.LocationId
					for json auto									
					)
		,p.Phone
		,p.Fax
		,p.BusinessEmail
		,p.SiteUrl
		,[Services] = (select S.Id,[Name],ServiceTypeId, [Description],[Total]
							,[ServiceCode],S.[IsActive]  
							from dbo.[Services] as S
						inner join dbo.VetServices as VS
						on VS.ServiceId = S.Id
						inner join dbo.VetProfiles as VP
						on vs.VetProfileId = vp.Id
						inner join dbo.VetPractices as VPT
						on VPT.PracticeId = P.Id for json auto)
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
	  inner join dbo.Users As U
	  on U.Id = P.CreatedBy
	  inner join dbo.VetPractices AS VP
	  on VP.PracticeId = P.Id
	  inner join dbo.VetProfiles As VPr
	  on VPr.Id = VP.VetProfileId
	  inner join dbo.VetServices as VS
	  on VS.VetProfileId = Vpr.Id
	  inner join dbo.Locations As L
		on l.Id = P.LocationId
		inner join dbo.Files As F
		on p.PrimaryImageId = F.Id
		inner join dbo.FileTypes as FT
		on FT.Id = F.FileTypeId
  WHERE (P.Id LIKE '%' + @Query + '%'
					OR P.[Name] LIKE '%' + @Query + '%'
					OR p.Description LIKE '%' + @Query + '%'
					OR p.PrimaryImageId LIKE '%' + @Query + '%'
					OR L.LineOne LIKE '%' + @Query + '%'
					OR L.LineTwo LIKE '%' + @Query + '%'
					OR p.Phone LIKE '%' + @Query + '%'
					OR p.Fax LIKE '%' + @Query + '%'
					OR p.BusinessEmail LIKE '%' + @Query + '%'
					OR P.SiteUrl LIKE '%' + @Query + '%')
		AND (P.IsActive = 1)
					
  Order by P.Id DESC
  
			OFFSET @offset ROWS
			FETCH NEXT @PageSize ROWS ONLY

  End

GO
