USE [MiVet]
GO
/****** Object:  StoredProcedure [dbo].[Appointments_Select_ByVetProfileId_ByUpcomingDay]    Script Date: 10/23/2022 7:24:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Min Kim 
-- Create date: Oct 18, 2022
-- Description: Get appointment info by Id. Only returns Active status/ StatusId 1
-- Code Reviewer:

-- MODIFIED BY: 
-- MODIFIED DATE: 
-- Code Reviewer: 
-- Note: 
-- =============================================
ALTER PROC [dbo].[Appointments_Select_ByVetProfileId_ByUpcomingDay]
				@Id int
				,@PageIndex int
				,@PageSize int
				,@Day int
AS

/*
-------- TEST CODE ----------
DECLARE @Id int = 4
		,@PageIndex int = 0
		,@PageSize int = 10
		,@Day int = 7
EXECUTE [dbo].[Appointments_Select_ByVetProfileId_ByUpcomingDay]
			@Id
			,@PageIndex
			,@PageSize
			,@Day

*/

BEGIN

	DECLARE @Offset int = @PageIndex * @PageSize;

	SELECT 
			a.[Id]
			,a.[Notes]
			,a.[IsConfirmed]
			,a.[AppointmentStart]
			,a.[AppointmentEnd]
			,a.[DateCreated]
			,a.[DateModified]
			,StatusType = (SELECT
								st.[Id]
								,st.[Name]
							FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)

			,AppointmentType = (SELECT 
										apt.[Id]
										,apt.[Name]
								FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
			,ModifiedBy = (SELECT 
								u.[Id]
								,u.[FirstName]
								,u.[LastName]
								,u.[Email]
							FROM dbo.Users as u
							WHERE a.ModifiedBy = u.Id
							FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)

			,Location = (SELECT 
								l.[Id]
								,l.[LineOne]
								,l.[LineTwo]
								,l.[City]
								,l.[Zip]
								,l.[Longitude]
								,l.[Latitude]
								,LocationType = JSON_QUERY((SELECT 
																	lt.[Id]
																	,lt.[Name]
															FOR JSON PATH, WITHOUT_ARRAY_WRAPPER))

								,State = JSON_QUERY((SELECT 
															s.[Id]
															,s.[Name]
													FOR JSON PATH, WITHOUT_ARRAY_WRAPPER))

						FROM dbo.Locations as l
						INNER JOIN dbo.States as s
						ON l.StateId = s.Id
						INNER JOIN dbo.LocationTypes as lt
						ON l.LocationTypeId = lt.Id
						WHERE l.Id = a.LocationId
						FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)

			,Client = (SELECT 
								u.[Id]
								,u.[FirstName]
								,u.[LastName]
								,u.[Email]
						FROM dbo.Users AS u
						WHERE u.Id = a.ClientId
						FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER)

			,CreatedBy = (SELECT 
								u.[Id]
								,u.[FirstName]
								,u.[LastName]
							FROM dbo.Users AS u
							WHERE u.Id = a.CreatedBy
							FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER)
			,Vet = (SELECT 
							vp.[Id]
							,vp.[Bio]
							,vp.[BusinessEmail]
							,vp.[EmergencyLine]
							,CreatedBy = JSON_QUERY((SELECT 
															[FirstName]
															,[LastName]
															,[Id]
															,[AvatarUrl] as UserImage
													FROM dbo.Users
													WHERE Id = vp.CreatedBy
										FOR JSON PATH, WITHOUT_ARRAY_WRAPPER))
					FROM dbo.VetProfiles AS vp
					WHERE a.VetProfileId = vp.Id
					FOR JSON AUTO, WITHOUT_ARRAY_WRAPPER)

			,TotalCount = COUNT(1) OVER()

	FROM dbo.Appointments AS a
	INNER JOIN dbo.StatusTypes AS st
	ON a.StatusTypeId = st.Id
	INNER JOIN dbo.AppointmentTypes AS apt
	ON a.AppointmentTypeId = apt.Id
	WHERE (a.VetProfileId = @Id AND a.StatusTypeId = 1) AND 
		(a.AppointmentStart >= CONVERT(DATE, GETDATE()) AND 
		(a.AppointmentStart <= CONVERT(date, DATEADD(DAY,@Day,GETDATE()))))
	ORDER BY a.AppointmentStart 

	OFFSET @Offset ROWS
	FETCH NEXT @PageSize ROWS ONLY

END


