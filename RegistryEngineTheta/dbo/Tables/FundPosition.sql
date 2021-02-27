CREATE TABLE [dbo].[FundPosition] (
    [fundId]         INT             NOT NULL,
    [valuationDate]  DATE            NOT NULL,
    [axysTicker]     NVARCHAR (50)   NOT NULL,
    [addedDate]      DATETIME        CONSTRAINT [DF_AxysPortfolioPosition_addedDate] DEFAULT (getdate()) NULL,
    [securityName]   NVARCHAR (1000) NOT NULL,
    [localQuantity]  FLOAT (53)      CONSTRAINT [DF_AxysPortfolioPosition_localQuantity] DEFAULT ((0)) NULL,
    [localPrice]     FLOAT (53)      CONSTRAINT [DF_AxysPortfolioPosition_localPrice] DEFAULT ((0)) NULL,
    [localDollars]   FLOAT (53)      CONSTRAINT [DF_AxysPortfolioPosition_localDollars] DEFAULT ((0)) NULL,
    [fxRate]         FLOAT (53)      CONSTRAINT [DF_AxysPortfolioPosition_fxRate] DEFAULT ((0)) NULL,
    [nzDollars]      FLOAT (53)      CONSTRAINT [DF_AxysPortfolioPosition_nzDollars] DEFAULT ((0)) NULL,
    [bondCode]       INT             NULL,
    [bondIssuerName] VARCHAR (100)   NULL,
    [themeName]      VARCHAR (100)   NULL,
    [maturityDate]   DATE            NULL,
    [dilutionLevy]   VARCHAR (100)   NULL,
    [pricingSource]  VARCHAR (100)   NULL,
    [ratingName]     VARCHAR (100)   NULL,
    CONSTRAINT [PK_AxysPortfolioPosition] PRIMARY KEY CLUSTERED ([fundId] ASC, [valuationDate] ASC, [axysTicker] ASC),
    CONSTRAINT [FK_FundPosition_Fund] FOREIGN KEY ([fundId]) REFERENCES [dbo].[Fund] ([fundId])
);

