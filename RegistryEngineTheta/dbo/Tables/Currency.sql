CREATE TABLE [dbo].[Currency] (
    [code]      NVARCHAR (100) NOT NULL,
    [acronym]   NVARCHAR (100) NULL,
    [name]      NVARCHAR (100) NULL,
    [listOrder] INT            NULL,
    CONSTRAINT [PK_AxysPortfolioCurrency] PRIMARY KEY CLUSTERED ([code] ASC)
);

