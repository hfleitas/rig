
drop proc if exists wipe;
go
create or alter proc dbo.wipe
as 
	-- + ----- +
	-- | Leads |
	-- + ----- +
    drop table if exists Ticket;
    drop table if exists Lead;
    drop table if exists CustomerAccount;
    drop table if exists Customer;

    create table Customer (
        [CustomerId]	int identity(1,1)
        ,[Name]			nvarchar(256)
        ,[Email]		varchar(320)
        constraint pkCustomer primary key clustered ([CustomerId] asc)
    );

    create table CustomerAccount (
        [CustomerAccountId]	int --identity(1,1)
        ,[CustomerId]			int --foreign key references Customer(CustomerId)
        ,[AcctNumEnding]		int
        constraint pkCustomerAccount primary key clustered ([CustomerAccountId] asc)
    );

    create table Lead (
        [LeadId]		int --identity(1001,1)
        ,[Name]			nvarchar(256)
        ,[Email]		varchar(320)
        ,[Address]		nvarchar(256)
        ,[Status]		bit default(0) -- 0 open / 1 closed
        ,[CreatedBy]	nvarchar(128) default suser_name()
        ,[CreatedOn]	datetime default getdate()
        ,[ModifiedBy]	nvarchar(128) 
        ,[ModifiedOn]	datetime 
        constraint pkLeads primary key clustered ([LeadId] asc)
    );

    create table Ticket (
            [TicketId]			int --identity(2001,1)
        ,[CustomerId]		int 
        ,[AcctNumEnding]	int	
        ,[Status]			bit default(0) -- 0 open / 1 closed
        ,[LeadId]			int foreign key references Lead(LeadId)
        ,[CreatedBy]		nvarchar(128) default suser_name()
        ,[CreatedOn]		datetime default getdate()
        ,[ModifiedBy]		nvarchar(128) default suser_name()
        ,[ModifiedOn]		datetime default getdate()
        constraint pkTicket primary key clustered ([TicketId] asc)
    );


	-- + ------------ +
	-- | Trollhunters |
	-- + ------------ +
    drop table if exists [Character];
    drop table if exists quotes;

    create table [Character] ( 
        CharacterId		int identity(1,1)	not null,
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
        VoicedBy		varchar(50)			null,
        constraint pk_Character primary key clustered (CharacterId asc));

    create table quotes (
        quoteid     int             identity(1,1) primary key clustered,
        character   varchar(128)    not null,
        quote       nvarchar(max)   not null,
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