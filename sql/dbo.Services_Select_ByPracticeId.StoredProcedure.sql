USE [MiVet]
GO
/****** Object:  StoredProcedure [dbo].[Services_Select_ByPracticeId]    Script Date: 10/23/2022 7:26:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: <Min Su Kim>
-- Create date: <10/13/2022>
-- Description: <A proc to select a record by PracticeId from dbo.Services table>
-- Code Reviewer:

-- MODIFIED BY: Author
-- MODIFIED DATE:
-- Code Reviewer: 
-- Note: .
-- =============================================
CREATE PROC [dbo].[Services_Select_ByPracticeId] 
								@PageSize int
								,@PageIndex int
								,@PracticeId int
as

/* ----- Test Code -----

Declare @PageSize int = 5
	   ,@PageIndex int = 0
	   ,@PracticeId int = 65

EXECUTE [dbo].[Services_Select_ByPracticeId] @PageSize
										   ,@PageIndex
										   ,@PracticeId

*/

BEGIN

	DECLARE @Offset int = @PageSize * @PageIndex

	SELECT DISTINCT s.[Id]
		  ,st.[Name] as ServiceType
		  ,s.[Name]
		  ,s.[Description]
		  ,s.[Total]
		  ,s.[ServiceCode]
		  ,s.[IsActive]
		  ,s.[DateCreated]
		  ,s.[DateModified]
		  ,u.[Id] as UserId 
		  ,s.[ModifiedBy]
		  ,TotalCount = COUNT(1)OVER()

	FROM [dbo].[Services] as s 
		inner join [dbo].[ServiceTypes] as st
		on [s].[ServiceTypeId] = [st].[Id]
		inner join [dbo].[Users] as u
		on s.CreatedBy = u.Id
		inner join dbo.VetServices as VS
		on s.Id = VS.ServiceId
		inner join dbo.VetPractices as VP
		on VP.VetProfileId = VS.VetProfileId
	where VP.PracticeId = @PracticeId
	ORDER BY UserId

	OFFSET @Offset ROWS 
	FETCH NEXT @PageSize ROWS ONLY

END
GO
