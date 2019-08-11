if object_id('wipe') is not null drop proc wipe;
go 
create proc dbo.wipe
as 
	-- + ----- +
	-- | Leads |
	-- + ----- +
	if object_id('Customer') is not null drop table Customer
	create table Customer (
			[CustomerId]	int 
		,[Name]			nvarchar(256)
		,[Email]		varchar(320)
	)
	with (
		distribution = hash(CustomerId),
		clustered columnstore index
	);

	if object_id('CustomerAccount') is not null drop table CustomerAccount
	create table CustomerAccount (
			[CustomerAccountId]	int 
		,[CustomerId]			int 
		,[AcctNumEnding]		int
	)
	with (
		distribution = hash(CustomerId),
		clustered columnstore index
	);

	if object_id('Lead') is not null drop table Lead
	create table Lead (
			[LeadId]		int 
		,[Name]			nvarchar(256)
		,[Email]		varchar(320)
		,[Address]		nvarchar(256)
		,[Status]		bit 
		,[CreatedBy]	nvarchar(128) 
		,[CreatedOn]	datetime 
		,[ModifiedBy]	nvarchar(128) 
		,[ModifiedOn]	datetime 
	);

	if object_id('Ticket') is not null drop table Ticket
	create table Ticket (
			[TicketId]			int 
		,[CustomerId]		int 
		,[AcctNumEnding]	int	
		,[Status]			bit 
		,[LeadId]			int 
		,[CreatedBy]		nvarchar(128) 
		,[CreatedOn]		datetime 
		,[ModifiedBy]		nvarchar(128) 
		,[ModifiedOn]		datetime
	);

	-- + ------------ +
	-- | Trollhunters |
	-- + ------------ +
	if object_id('Character') is not null drop table Character
	create table [Character] ( 
		CharacterId		int             	not null,
		FullName		varchar(50)			not null,
		Affiliation		varchar(60)			null, 
		Category		varchar(10)			null, 
		Aka				varchar(300)		null, --*
		[Status]		varchar(35)			null,
		Race			varchar(50)			null,
		Age				int					null,
		Home			varchar(50)			null,
		Relatives		varchar(300)		null, --*
		Weapons			varchar(100)		null, --*
		EyeColor		varchar(20)			null,
		HairColor		varchar(50)			null,
		Minions			varchar(100)		null,
		VoicedBy		varchar(50)			null
	) 
	with (
		distribution = hash(CharacterId),
		clustered columnstore index
	);

	if object_id('quotes') is not null drop table quotes
	create table quotes (
		quoteid     int             ,
		character   varchar(128)    not null,
		quote       nvarchar(4000)   not null,
		sentiment   float
	);
go

select * from dbo.Character
select * from dbo.Quotes

select * from dbo.Customer
select * from dbo.CustomerAccount

-- Res: 
-- https://docs.microsoft.com/en-us/azure/data-factory/copy-activity-performance
-- https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-sql-data-warehouse
-- https://docs.microsoft.com/en-us/azure/data-factory/connector-sql-server#append-data

-- https://docs.microsoft.com/en-us/azure/data-factory/control-flow-expression-language-functions

/*
https://www.youtube.com/watch?v=bBi1bll2928
@concat('https://management.azure.com/subscriptions/',pipeline().parameters.SubscriptionID,'/resourceGroups/',pipeline().parameters.ResourceGroup,'/providers/Microsoft.Sql/servers/',pipeline().parameters.Server,'/databases/',pipeline().parameters.DW,'?api-version=2019-08-01')

https://management.azure.com/subscriptions/eaab21d5-8ecd-4ef0-a0c4-92fac2e22875/resourceGroups/dw/providers/Microsoft.Sql/servers/hiramdw/databases/dw?api-version=2019-08-01
https://portal.azure.com/#@fleitasarts.com/resource/subscriptions/eaab21d5-8ecd-4ef0-a0c4-92fac2e22875/resourceGroups/dw/providers/Microsoft.Sql/servers/hiramdw/overview

https://aka.ms/azuremsi
1. create user assigned msi called hiramMI.
2. under IAM add role assignment, rig contributor.
3. under dw server IAM, add role assignment, rig(adf) contributor and hiramMI(msi) contributor.

https://github.com/furmangg/automating-azure-sql-dw
*/