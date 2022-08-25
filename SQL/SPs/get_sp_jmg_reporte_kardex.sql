--DECLARE	@id_empresa					INT = 2
--DECLARE	@id_distribuidor			INT	= NULL
--DECLARE	@id_fabrica					INT = 40
--DECLARE	@fecha_inicial				VARCHAR(10) = '20200101'
--DECLARE	@fecha_final				VARCHAR(10) = '20221231'
--DECLARE	@texto_referencia			VARCHAR(100) = NULL 

------------DECLARE @pedido		VARCHAR(20) = '12652012'
------------DECLARE @factura	VARCHAR(20) = '190971156'
--------------DECLARE @pedido		VARCHAR(20) = '51212011'
--------------DECLARE @factura	VARCHAR(20) = '190969331'

------------SELECT * FROM [dbo].[jmg_pedido_mis_enc] WHERE [correlativo_pedido] = @pedido
------------SELECT * FROM [dbo].[jmg_factura_mis_enc] WHERE [numero_factura] = @factura

--------------SELECT * FROM [dbo].[jmg_pedido_mis_enc] WHERE [correlativo_pedido] = @pedido
--------------SELECT * FROM [dbo].[jmg_factura_mis_enc] WHERE [numero_factura] = @factura AND id_item_mis IN (SELECT id_item FROM [dbo].[jmg_pedido_mis_enc] WHERE [correlativo_pedido] = @pedido)


--USE [MISNET_TEST]
--GO


IF ( OBJECT_ID('dbo.get_sp_jmg_reporte_kardex') IS NOT NULL )  
BEGIN
    DROP PROCEDURE dbo.get_sp_jmg_reporte_kardex  
END
GO

/****** Object:  StoredProcedure [dbo].[get_sp_jmg_reporte_kardex]    Script Date: 07-Aug-18 7:24:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[get_sp_jmg_reporte_kardex]
	@id_empresa					INT,
	@id_distribuidor			INT	= NULL,
	@id_fabrica					INT = NULL,
    @fecha_inicial				VARCHAR(10) = NULL,
    @fecha_final				VARCHAR(10) = NULL,
	@texto_referencia			VARCHAR(100) = NULL 
AS 
BEGIN  
--	SET NOCOUNT ON  

--	DECLARE	@id_empresa					INT = 2
--DECLARE	@id_distribuidor			INT	= NULL
--DECLARE	@id_fabrica					INT = 13
--DECLARE	@fecha_inicial				VARCHAR(10) = '20200101'
--DECLARE	@fecha_final				VARCHAR(10) = '20211031'
--DECLARE	@texto_referencia			VARCHAR(100) = NULL 

		--ISNULL(dped.total_confirmado, 0)	AS	total_pedido,

	SELECT	SOL.id_pais, 
			SOL.periodo,
			MIS.id_pedido,
			CXC.id_factura,
			MIS.id_item,
			SOL.id_solicitud, 
			SOL.id_distribuidor,
			MIS.id_fabrica,
			WT.id_workflow,
			WT.id_workflow_step		as id_ultimo_step_completado,
			WT.id_status_item_step	as id_status_step,
			WT.nombre_step			as ultimo_step_completado,
			CRM.nombre				as nombre_distribuidor,
			FAB.nombre				as nombre_fabrica,
			MON.descripcion_corta	as descripcion_moneda,
			MIS.correlativo_proforma,
			MIS.no_orden_compra_proforma,
			SOL.fecha_creacion					as fecha_solicitud,
			VWP.total_agregado_en_solicitud		as total_proforma,
			MIS.correlativo_pedido,
			WAP.fecha_creacion					as	fecha_pedido,
			MIS.no_orden_compra_pedido,
			IIF(MIS.correlativo_pedido IS NULL, NULL, MIS.valor_total)		as total_pedido,
			CXC.numero_factura,
			CXC.fecha_factura,
			--ISNULL(MIS.valor_total, 0) as total_firme,
			ISNULL(CXC.total_factura, 0) as	total_factura,
			IIF(ISNULL(MIS.valor_total, 0) > 0 AND ISNULL(CXC.total_factura, 0) > 0, IIF(ISNULL(MIS.valor_total, 0) - ISNULL(CXC.total_factura, 0) <0, 0, ISNULL(MIS.valor_total, 0) - ISNULL(CXC.total_factura, 0)), NULL) as no_facturado,
			--IIF(ISNULL(MIS.valor_total, 0) > 0 AND ISNULL(CXC.total_factura, 0) > 0, ISNULL(MIS.valor_total, 0) - ISNULL(CXC.total_factura, 0), NULL) as no_facturado,
			ISNULL(CXC.saldo_documento,0)	as	total_cobrar
	FROM	[dbo].[jmg_pedido_mis_solicitud] as SOL
		LEFT OUTER JOIN [dbo].[jmg_pedido_mis_enc] as MIS
			ON MIS.periodo = SOL.periodo
			AND MIS.id_pais = SOL.id_pais
			AND MIS.id_solicitud = SOL.id_solicitud
		LEFT OUTER JOIN [dbo].[vw_jmg_facturas_cxc] as CXC
			ON MIS.id_item = CXC.id_item_mis
		INNER JOIN	dbo.crm_cliente as CRM
			ON		CRM.id_empresa	=	SOL.id_empresa
				AND CRM.id_cliente	=	SOL.id_distribuidor
		INNER JOIN	dbo.bpm_proveedor as FAB
			ON		FAB.id_empresa =	MIS.id_empresa
				AND FAB.id_proveedor =	MIS.id_fabrica
		LEFT OUTER JOIN	dbo.tbl_moneda as MON
			ON		MON.id_moneda		=	MIS.id_moneda
		LEFT OUTER JOIN dbo.wf_item_step as WAP
			ON		WAP.id_item = MIS.id_item
				AND WAP.id_workflow_step = 4030
		INNER JOIN	[dbo].[vw_jmg_pedidos_enc] as VWP
			ON		MIS.id_empresa = VWP.id_empresa
				AND	MIS.id_pais = VWP.id_pais
				AND	MIS.periodo = VWP.periodo
				AND	MIS.id_pedido = VWP.id_pedido
		OUTER APPLY
			( SELECT TOP 1 Q.* FROM dbo.vw_workflow_item Q WHERE Q.id_item = MIS.id_item 
			  ORDER BY Q.id_workflow_step DESC, Q.fecha_auditoria DESC
			) WT
		--LEFT OUTER JOIN dbo.wf_item_step as FIRME
		--	ON		FIRME.id_item = MIS.id_item
		--		AND FIRME.id_workflow_step = 4030
		--		AND FIRME.id_status = 1503
	WHERE	SOL.id_empresa = @id_empresa
		AND (CONVERT(VARCHAR, SOL.fecha_creacion, 112) BETWEEN @fecha_inicial AND @fecha_final
		OR CONVERT(VARCHAR, CXC.fecha_factura, 112) BETWEEN @fecha_inicial AND @fecha_final)		
		AND ( SOL.id_empresa = @id_empresa  OR   @id_empresa IS NULL  )
		AND ( SOL.id_distribuidor = @id_distribuidor OR @id_distribuidor IS NULL )
		AND ( MIS.id_fabrica = @id_fabrica OR @id_fabrica IS NULL )
		AND (	( CRM.nombre LIKE '%' + @texto_referencia + '%' OR @texto_referencia IS NULL )		
				OR	( FAB.nombre LIKE '%' + @texto_referencia + '%' OR @texto_referencia IS NULL )		
				OR	( MIS.no_orden_compra_pedido LIKE '%' + @texto_referencia + '%' OR @texto_referencia IS NULL )		
				OR	( MIS.no_orden_compra_proforma LIKE '%' + @texto_referencia + '%' OR @texto_referencia IS NULL ))	
		--AND	MIS.correlativo_proforma = 'GP0201122'

	ORDER BY SOL.fecha_creacion DESC 


	SET NOCOUNT OFF  
END  
	 











