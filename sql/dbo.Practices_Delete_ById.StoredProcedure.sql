USE [MiVet]
GO
/****** Object:  StoredProcedure [dbo].[Practices_Delete_ById]    Script Date: 10/23/2022 7:26:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: <Min Su Kim>
-- Create date: <09/21/2022>
-- Description: <Delete proc for Practices by Id by change the isActive column to 0>
-- Code Reviewer:

-- MODIFIED BY: author
-- MODIFIED DATE:09/30/2022
-- Code Reviewer:
-- Note:
-- =============================================


CREATE proc [dbo].[Practices_Delete_ById]
				@Id int
as
/*
ssssdfsdf

Declare @Id int = 3
select IsActive
from dbo.Practices
where Id = @Id



Execute [dbo].[Practices_Delete_ById]
						@Id
select IsActive
from dbo.Practices
where Id = @Id
				



*/

begin

Update dbo.Practices
Set 
	IsActive = 0
where Id = @Id

end
GO
