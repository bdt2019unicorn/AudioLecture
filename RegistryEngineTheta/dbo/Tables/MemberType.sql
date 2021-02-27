CREATE TABLE [dbo].[MemberType] (
    [memberTypeId]      INT           NOT NULL,
    [registryVersionId] INT           NOT NULL,
    [code]              VARCHAR (50)  NULL,
    [name]              VARCHAR (150) NULL,
    [fullAddress]       VARCHAR (150) NULL,
    CONSTRAINT [PK_MemberType] PRIMARY KEY CLUSTERED ([memberTypeId] ASC, [registryVersionId] ASC)
);

