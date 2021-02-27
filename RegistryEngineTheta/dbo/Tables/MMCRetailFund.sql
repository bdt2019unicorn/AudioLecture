CREATE TABLE [dbo].[MMCRetailFund] (
    [memberId]            INT          NOT NULL,
    [portfolioName]       VARCHAR (50) NOT NULL,
    [mmcFundCode]         VARCHAR (10) NOT NULL,
    [genevaPortfolio]     VARCHAR (50) NOT NULL,
    [asbAccountReference] VARCHAR (50) NOT NULL,
    [retailFundId]        INT          NULL,
    CONSTRAINT [PK_MMCRetailFund] PRIMARY KEY CLUSTERED ([memberId] ASC)
);

