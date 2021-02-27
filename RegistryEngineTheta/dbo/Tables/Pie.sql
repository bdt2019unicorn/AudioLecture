CREATE TABLE [dbo].[Pie] (
    [pieid]             INT          NOT NULL,
    [pieName]           VARCHAR (50) NULL,
    [irdNumber]         INT          NULL,
    [pieFullName]       VARCHAR (50) NULL,
    [registryVersionId] INT          NULL,
    [isActive]          BIT          CONSTRAINT [DF_Pie_isActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_pie] PRIMARY KEY CLUSTERED ([pieid] ASC),
    CONSTRAINT [FK_Pie_RegistryVersion] FOREIGN KEY ([registryVersionId]) REFERENCES [dbo].[RegistryVersion] ([id])
);

