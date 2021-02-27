CREATE TABLE [dbo].[IsiFileJobEmail] (
    [isiFileJobEmailId]         INT           IDENTITY (1, 1) NOT NULL,
    [isiFileJobDetailsId]       INT           NOT NULL,
    [receiveIsiFileContactId]   INT           NOT NULL,
    [receiveIsiFileContactName] VARCHAR (100) NOT NULL,
    [relationshipType]          VARCHAR (50)  NOT NULL,
    [emailAddressTo]            VARCHAR (100) NOT NULL,
    [emailSent]                 BIT           NOT NULL,
    [dateEmailSent]             DATETIME      NULL,
    CONSTRAINT [PK_IsiFileJobEmail] PRIMARY KEY CLUSTERED ([isiFileJobEmailId] ASC),
    CONSTRAINT [FK_IsiFileJobEmail_IsiFileJobDetails] FOREIGN KEY ([isiFileJobDetailsId]) REFERENCES [dbo].[IsiFileJobDetails] ([detailsId])
);

