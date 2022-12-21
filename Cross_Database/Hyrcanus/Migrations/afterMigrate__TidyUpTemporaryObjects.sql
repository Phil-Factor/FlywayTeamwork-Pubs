USE Antigonus;
DROP TABLE IF EXISTS #DeleteList;
CREATE TABLE #DeleteList
  (TheOrder INT IDENTITY,
   TheName sysname,
   TheType NVARCHAR(20));
INSERT INTO #DeleteList (TheName, TheType)
  SELECT Object_Schema_Name (major_id) + '.' + Object_Name (major_id) AS TheName,
         CASE ObjectPropertyEx (major_id, 'BaseType') WHEN 'U' THEN ' TABLE'
           WHEN 'V' THEN ' VIEW' ELSE 'UNSUPPORTED' END AS type
    FROM sys.extended_properties comment
    WHERE name = 'DeleteMe';
DECLARE @ToBeDeleted NVARCHAR(4000) = N'';
SELECT @ToBeDeleted =
  @ToBeDeleted + N'DROP' + TheType + N' ' + TheName + N';   '
  FROM #DeleteList
  WHERE TheType <> 'UNSUPPORTED';
EXECUTE (@ToBeDeleted);
SELECT @ToBeDeleted AS "Actions executed to Temporary Objects on Antigonus";
DROP TABLE IF EXISTS #DeleteList;
GO
USE Hyrcanus;
DROP TABLE IF EXISTS #DeleteList;
CREATE TABLE #DeleteList
  (TheOrder INT IDENTITY,
   TheName sysname,
   TheType NVARCHAR(20));
INSERT INTO #DeleteList (TheName, TheType)
  SELECT Object_Schema_Name (major_id) + '.' + Object_Name (major_id) AS TheName,
         CASE ObjectPropertyEx (major_id, 'BaseType') WHEN 'U' THEN ' TABLE'
           WHEN 'V' THEN ' VIEW' ELSE 'UNSUPPORTED' END AS type
    FROM sys.extended_properties comment
    WHERE name = 'DeleteMe';
DECLARE @ToBeDeleted NVARCHAR(4000) = N'';
SELECT @ToBeDeleted =
  @ToBeDeleted + N'DROP' + TheType + N' ' + TheName + N';   '
  FROM #DeleteList
  WHERE TheType <> 'UNSUPPORTED';
EXECUTE (@ToBeDeleted);
SELECT @ToBeDeleted AS "Actions executed to Temporary Objects on Hyrcanus";
DROP TABLE IF EXISTS #DeleteList;