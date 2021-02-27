CREATE TABLE [dbo].[Fund] (
    [fundId]      INT            NOT NULL,
    [foldername]  NVARCHAR (100) NOT NULL,
    [fundCode]    VARCHAR (50)   NULL,
    [fundName]    NVARCHAR (400) NOT NULL,
    [pieId]       INT            NOT NULL,
    [isActive]    BIT            CONSTRAINT [DF_Fund_isActive] DEFAULT ((1)) NOT NULL,
    [gmiClientId] INT            NULL,
    CONSTRAINT [PK_axys_portfolio] PRIMARY KEY CLUSTERED ([fundId] ASC),
    CONSTRAINT [FK_Fund_Pie] FOREIGN KEY ([pieId]) REFERENCES [dbo].[Pie] ([pieid]),
    CONSTRAINT [FK_Fund_Pie1] FOREIGN KEY ([pieId]) REFERENCES [dbo].[Pie] ([pieid])
);

