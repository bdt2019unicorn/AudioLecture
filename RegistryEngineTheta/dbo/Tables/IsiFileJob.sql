CREATE TABLE [dbo].[IsiFileJob] (
    [isiFileJobId]   INT            IDENTITY (1, 1) NOT NULL,
    [valuationDate]  DATETIME       NOT NULL,
    [runBy]          VARCHAR (100)  NOT NULL,
    [runDate]        DATETIME       NOT NULL,
    [isiFileCount]   INT            NULL,
    [priceFilePath]  VARCHAR (255)  NULL,
    [priceFileName]  VARCHAR (100)  NULL,
    [success]        BIT            CONSTRAINT [DF_IsiFileJob_success] DEFAULT ((0)) NOT NULL,
    [resultsMessage] VARCHAR (2000) NULL,
    [errorMessage]   VARCHAR (MAX)  NULL,
    CONSTRAINT [PK_IsiFileJob] PRIMARY KEY CLUSTERED ([isiFileJobId] ASC)
);

