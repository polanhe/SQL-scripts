--USE [MISNET_PROD]
--GO

/****** Object:  View [dbo].[vw_jmg_lista_facturas_mis_det]    Script Date: 05-Sep-22 5:24:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT  *  FROM sys.views  WHERE object_id	=	OBJECT_ID(N'dbo.vw_jmg_lista_facturas_mis_det'))
BEGIN
	DROP VIEW dbo.vw_jmg_lista_facturas_mis_det
END
GO

CREATE VIEW [dbo].[vw_jmg_lista_facturas_mis_det] AS

SELECT
	Fd.id_factura,
	Fd.id_linea,
	Fd.id_linea_pedido,
	Fd.id_parte_interno,
	Pa.id_numero_parte,
	pa.descripcion,
	pa.observaciones,
	ISNULL(Fd.cantidad_acusada,0)		AS	cantidad_acusada,
	ISNULL(Fd.cantidad_facturado,0)		AS	cantidad_facturado,
	ISNULL(Fd.flag_tiene_reclamo,0)		AS	flag_tiene_reclamo,
	ISNULL(Fd.cantidad_acusada,0) - ISNULL(Fd.cantidad_facturado,0)		AS	no_facturado,
	Fd.precio_acusado,
	Fd.precio_facturado,
	Fd.precio_total,
	Fd.id_status,
	Pest.descripcion					AS	descripcion_status
FROM
		dbo.jmg_factura_mis_det Fd
	INNER JOIN
		dbo.jmg_factura_mis_enc F
	ON
		F.id_factura = Fd.id_factura
	INNER JOIN
		dbo.jmg_pedido_mis_enc P
	ON
		F.id_item_mis = P.id_item
	INNER JOIN
		dbo.jmg_pedido_mis_det Pd
	ON
			Pd.id_pais = P.id_pais
		AND Pd.periodo = P.periodo
		AND Pd.id_pedido = P.id_pedido
		AND Pd.id_correlativo = Fd.id_linea_pedido		
	INNER JOIN
		dbo.vw_jmg_catalogo_partes Pa
	ON
			Pa.id_parte_interno = Fd.id_parte_interno
	INNER JOIN
		dbo.tbl_status Pest
	ON
		Pest.id_status = Fd.id_status
GO


