/*
YouTube:  @SoftwareNuggets

select @@version
drop function dbo.sfn_hash_password;
drop procedure proc_register_user;
drop function dbo.sfn_validate_user;
drop table site_user_m;
*/
use LearnSQL;

CREATE TABLE site_user_m (
    id				INT PRIMARY KEY IDENTITY(1005987,37),
    login_name		NVARCHAR(50) UNIQUE NOT NULL,
    password_salt	UNIQUEIDENTIFIER DEFAULT NEWID(),
    password_hash	VARCHAR(128) NOT NULL,
	create_date		DateTime default getDate()
);

create or alter function dbo.sfn_hash_password
(
    @password		NVARCHAR(128),
    @salt			UNIQUEIDENTIFIER
)
RETURNS VARCHAR(128)
AS
/*
	date		author				note
	---------   ------------------  ---------------------
	12/6/2024	@softwareNuggets	hash password

	How to use
	----------------------------------------------------
	select dbo.sfn_hash_password('mypassword',newid())
	select CONCAT	('mypassword',CONVERT(VARCHAR(36), newId()))
*/
BEGIN
    DECLARE @HashedPassword VARCHAR(128);
    DECLARE @pwd_and_salt  NVARCHAR(128);

	-- Convert salt to string and concatenate with password
	set @pwd_and_salt = CONCAT(@Password, CONVERT(VARCHAR(36), @Salt))
    
    SET @HashedPassword = 
		CONVERT(VARCHAR(128),HASHBYTES('SHA2_512', @pwd_and_salt),2)

    RETURN @HashedPassword
END;



create or alter procedure proc_register_user
    @login_name NVARCHAR(50),
    @password	NVARCHAR(128)
AS
/*
	date		author				note
	---------   ------------------  ---------------------
	12/6/2024	@softwareNuggets	save new user record

	How to use
	----------------------------------------------------
	EXEC proc_register_user 
		@login_name = 'softwareNugget65@gmail.com', 
		@password = 'full-stack-programmer'
	select * from site_user_m
*/
BEGIN
    DECLARE @salt UNIQUEIDENTIFIER = NEWID()
    
    INSERT INTO site_user_m (login_name, password_salt, password_hash)
    VALUES (
        @login_name, 
        @salt,
        dbo.sfn_hash_password(@password, @salt)
    )
END;


CREATE or ALTER FUNCTION dbo.sfn_validate_user
(
    @login_name     NVARCHAR(50),
    @input_password NVARCHAR(128)
)
RETURNS bit
AS
BEGIN
    DECLARE @StoredHash		VARCHAR(128),
            @password_salt	UNIQUEIDENTIFIER,
            @IsValid		bit = 0;
    
	SELECT @StoredHash		= password_hash,
           @password_salt	= password_salt
    FROM site_user_m 
    WHERE login_name = @login_name;

	select @IsValid = 
			CASE WHEN @StoredHash = dbo.sfn_hash_password(@input_password, @password_salt) THEN 1
            ELSE 0 
           END
    
    RETURN @IsValid;
END;


--how to use
EXEC proc_register_user 
    @login_name = 'softwareNugget65@gmail.com', 
    @password = 'full-stack-programmer'



SELECT CASE 
		dbo.sfn_validate_user(
               'softwareNugget65@gmail.com',
               'full-stack-programmer')
       WHEN 1 THEN 'true'
       WHEN 0 THEN 'false'
       END AS user_validation


select * from site_user_m


SELECT CASE 
		dbo.sfn_validate_user(
               'softwareNugget66@gmail.com',
               'fule-stack-programmer')
       WHEN 1 THEN 'true'
       WHEN 0 THEN 'false'
       END AS user_validation