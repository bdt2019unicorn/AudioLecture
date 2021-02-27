CREATE TABLE [dbo].[MemberPiePIR] (
    [id]                 INT        IDENTITY (1, 1) NOT NULL,
    [addedDate]          DATETIME   CONSTRAINT [DF_MemberPiePIR_addedDate] DEFAULT (getdate()) NULL,
    [memberiD]           INT        NULL,
    [pieId]              NCHAR (10) NULL,
    [pir]                FLOAT (53) NULL,
    [effectiveStartDate] DATE       NULL,
    [isActive]           BIT        CONSTRAINT [DF_PiePIR_isActive] DEFAULT ((1)) NULL,
    [effectiveEndDate]   DATE       NULL,
    CONSTRAINT [PK_MemberPiePIR] PRIMARY KEY CLUSTERED ([id] ASC)
);

