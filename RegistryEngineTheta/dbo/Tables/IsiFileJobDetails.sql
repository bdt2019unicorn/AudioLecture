CREATE TABLE [dbo].[IsiFileJobDetails] (
    [detailsId]        INT           IDENTITY (1, 1) NOT NULL,
    [isiFileJobId]     INT           NOT NULL,
    [investorId]       INT           NOT NULL,
    [investorName]     VARCHAR (100) NOT NULL,
    [isiFilePath]      VARCHAR (255) NULL,
    [isiFileName]      VARCHAR (100) NULL,
    [isiFileFundCount] INT           CONSTRAINT [DF_IsiFileJobDetails_isiFileFundCount] DEFAULT ((0)) NOT NULL,
    [folderName]       VARCHAR (50)  NULL,
    [dateAdded]        DATETIME      NULL,
    CONSTRAINT [PK_IsiFileJobDetails] PRIMARY KEY CLUSTERED ([detailsId] ASC),
    CONSTRAINT [FK_IsiFileJobDetails_IsiFileJob] FOREIGN KEY ([isiFileJobId]) REFERENCES [dbo].[IsiFileJob] ([isiFileJobId])
);

