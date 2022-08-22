--USE [MISNET_PROD]
GO

/****** Object:  StoredProcedure [dbo].[get_sp_vw_jmg_lista_facturas_mis_custom]    Script Date: 17-Aug-22 8:32:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

   
-- ===============================================================================================================================   
-- Author:		Luis O. Gonzalez    
-- Create date: Lunes, 28 de febrero de 2011 
-- Description: Procecimiento Almacenado para hacer SELECT en base a la llave primaria a la tabla vw_jmg_lista_acuses_mis 
-- Project:     HPIT Framework (Sephia.net 3.5.2011.18)
-- Organization: HPIT Consulting
--  -------------------------------------
-- Author:		Hugo Polanco   
-- Create date: Miercoles, 17 de agosto de 2022
-- Description: Agregar NO FACTUADO
-- ===============================================================================================================================   
ALTER PROCEDURE [dbo].[get_sp_vw_jmg_lista_facturas_mis_custom]
	@periodo						AS	INT	=	NULL,
	@id_pais						AS	VARCHAR(2) =	NULL,
	@id_pedido						AS	INT	=	NULL,
	@id_factura						AS	INT	=	NULL,
	@numero_serie					AS  VARCHAR(10) = NULL,
	@numero_factura					AS	VARCHAR(50) = NULL,
	@filtrar_por_fecha				AS  BIT = 0,
	@filtrar_fecha_factura			AS	BIT	= 1,
	@fecha_inicial					AS	SMALLDATETIME	=	NULL,
	@fecha_final					AS	SMALLDATETIME	=	NULL,
	@correlativo_pedido				AS	VARCHAR(25)	=	NULL,
	@id_distribuidor				AS	INT =	NULL,
	@id_fabrica						AS	INT	=	NULL
AS 
BEGIN  
	SET NOCOUNT ON  
		
	IF @filtrar_por_fecha = 1
	BEGIN
		SELECT 
			periodo,
			id_pais,
			id_pedido,
			id_factura,
			id_fabrica,
			id_distribuidor,
			correlativo_proforma,
			correlativo_pedido,
			fecha_creacion_solicitud,
			id_item_mis,
			id_ultimo_step_completado,
			id_status_step,
			id_status,
			id_transportista,
			nombre_distribuidor,
			nombre_distribuidor_contacto,
			nombre_fabrica,
			numero_bl,
			numero_serie,
			numero_factura,
			numero_guia,
			fecha_factura,
			fecha_bl,
			codigo_iso_4217,
			simbolo_moneda,
			descripcion_moneda,
			nombre_transportista,
			observaciones,
			descripcion_status,
			total_pedido,
			total_factura,
			no_facturado,
			total_cobrar
		FROM
			dbo.vw_jmg_lista_facturas_mis
		WHERE
				CASE WHEN @periodo IS NULL THEN 1 ELSE periodo END = CASE WHEN @periodo IS NULL THEN 1 ELSE @periodo END
			AND CASE WHEN @id_pais IS NULL THEN 'A' ELSE id_pais END = CASE WHEN @id_pais IS NULL THEN 'A' ELSE @id_pais END
			AND CASE WHEN @id_pedido IS NULL THEN 1 ELSE id_pedido END = CASE WHEN @id_pedido IS NULL THEN 1 ELSE @id_pedido END
			AND CASE WHEN @id_factura IS NULL THEN 1 ELSE id_factura END = CASE WHEN @id_factura IS NULL THEN 1 ELSE @id_factura END
			AND CASE WHEN @id_distribuidor IS NULL THEN 1 ELSE id_distribuidor END = CASE WHEN @id_distribuidor IS NULL THEN 1 ELSE @id_distribuidor END
			AND CASE WHEN @id_fabrica IS NULL THEN 1 ELSE id_fabrica END = CASE WHEN @id_fabrica IS NULL THEN 1 ELSE @id_fabrica END
			AND CASE WHEN @numero_serie IS NULL THEN 'A' ELSE numero_serie END = CASE WHEN @numero_serie IS NULL THEN 'A' ELSE @numero_serie END
			AND CASE WHEN @numero_factura IS NULL THEN 'A' ELSE numero_factura END = CASE WHEN @numero_factura IS NULL THEN 'A' ELSE @numero_factura END
			AND CASE WHEN @correlativo_pedido IS NULL THEN 'A' ELSE correlativo_pedido END = CASE WHEN @correlativo_pedido IS NULL THEN 'A' ELSE @correlativo_pedido END
			AND CASE WHEN @filtrar_fecha_factura = 1 THEN dbo.DateOnly(fecha_factura) ELSE dbo.DateOnly(fecha_bl) END BETWEEN dbo.DateOnly(@fecha_inicial) AND dbo.DateOnly(@fecha_final)		
		ORDER BY
			fecha_factura DESC
	END
	ELSE
	BEGIN
		SELECT 
			periodo,
			id_pais,
			id_pedido,
			id_factura,
			id_fabrica,
			id_distribuidor,
			correlativo_proforma,
			correlativo_pedido,
			fecha_creacion_solicitud,
			id_item_mis,
			id_ultimo_step_completado,
			id_status_step,
			id_status,
			id_transportista,
			nombre_distribuidor,
			nombre_distribuidor_contacto,
			nombre_fabrica,
			numero_bl,
			numero_serie,
			numero_factura,
			numero_guia,
			fecha_factura,
			fecha_bl,
			codigo_iso_4217,
			simbolo_moneda,
			descripcion_moneda,
			nombre_transportista,
			observaciones,
			descripcion_status,
			total_pedido,
			total_factura,
			no_facturado,
			total_cobrar
		FROM
			dbo.vw_jmg_lista_facturas_mis
		WHERE
				CASE WHEN @periodo IS NULL THEN 1 ELSE periodo END = CASE WHEN @periodo IS NULL THEN 1 ELSE @periodo END
			AND CASE WHEN @id_pais IS NULL THEN 'A' ELSE id_pais END = CASE WHEN @id_pais IS NULL THEN 'A' ELSE @id_pais END
			AND CASE WHEN @id_pedido IS NULL THEN 1 ELSE id_pedido END = CASE WHEN @id_pedido IS NULL THEN 1 ELSE @id_pedido END
			AND CASE WHEN @id_factura IS NULL THEN 1 ELSE id_factura END = CASE WHEN @id_factura IS NULL THEN 1 ELSE @id_factura END
			AND CASE WHEN @id_distribuidor IS NULL THEN 1 ELSE id_distribuidor END = CASE WHEN @id_distribuidor IS NULL THEN 1 ELSE @id_distribuidor END
			AND CASE WHEN @id_fabrica IS NULL THEN 1 ELSE id_fabrica END = CASE WHEN @id_fabrica IS NULL THEN 1 ELSE @id_fabrica END
			AND CASE WHEN @numero_serie IS NULL THEN 'A' ELSE numero_serie END = CASE WHEN @numero_serie IS NULL THEN 'A' ELSE @numero_serie END
			AND CASE WHEN @numero_factura IS NULL THEN 'A' ELSE numero_factura END = CASE WHEN @numero_factura IS NULL THEN 'A' ELSE @numero_factura END
			AND CASE WHEN @correlativo_pedido IS NULL THEN 'A' ELSE correlativo_pedido END = CASE WHEN @correlativo_pedido IS NULL THEN 'A' ELSE @correlativo_pedido END
		ORDER BY
			fecha_factura DESC
	END
		
	SET NOCOUNT OFF  
END  

GO


