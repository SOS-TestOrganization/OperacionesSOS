/*---------------------------------------------------------------------------------
* Metodo o PRG 		: spTraerPromotoresPacSedes
* Desarrollado por		: <\A Ing. Rolando Simbaqueva Lasso									A\>
* Descripcion			: <\D Retorna los datos de las sedes asociadas a los promotores					 	D\>
* Observaciones			: <\O  													O\>
* Parametros			: <\P consecutivo del promotor que se desea localizar							P\>				 
* Variables			: <\V  													V\>
* Fecha Creacion		: <\FC 2002/10/01											FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*--------------------------------------------------------------------------------- 
* Modificado Por			: <\AM  AM\>
* Descripcion			: <\DM  DM\>
* Nuevos Parametros		: <\PM  PM\>
* Nuevas Variables		: <\VM  VM\>
* Fecha Modificacion		: <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE    PROCEDURE	spTraerPromotoresPacSedes
@lnConsecutivoPromotor 	UdtConsecutivo
As
set nocount on

Select     cnsctvo_cdgo_prmtr,
	 cnsctvo_cdgo_sde,
              ultmo_digto,
              brrdo,
              fcha_crcn,
              usro_crcn,
              fcha_ultma_mdfccn,
              usro_ultma_mdfccn
Into #tmptbpromotoresSedes            
From tbpromotoresSedes
Where  cnsctvo_cdgo_prmtr = @lnConsecutivoPromotor
and    brrdo='N'

select cdgo_sde,dscrpcn_sde,
       max(d0) d0,max(d1) d1, max(d2) d2, max(d3) d3, max(d4) d4, 		
       max(d5) d5,max(d6) d6, max(d7) d7, max(d8) d8, max(d9) d9, cnsctvo_cdgo_sde
into   #tmptbpromotoresSedes1    
from  (Select a.cdgo_sde, a.dscrpcn_sde , a.cnsctvo_cdgo_sde,
	(case ultmo_digto when 0 then  ultmo_digto else '-1' end) d0,
	(case ultmo_digto when 1 then  ultmo_digto else '-1' end) d1,
	(case ultmo_digto when 2 then  ultmo_digto else '-1' end) d2,
	(case ultmo_digto when 3 then  ultmo_digto else '-1' end) d3,
	(case ultmo_digto when 4 then  ultmo_digto else '-1' end) d4,
	(case ultmo_digto when 5 then  ultmo_digto else '-1' end) d5,
	(case ultmo_digto when 6 then  ultmo_digto else '-1' end) d6,
	(case ultmo_digto when 7 then  ultmo_digto else '-1' end) d7,
	(case ultmo_digto when 8 then  ultmo_digto else '-1' end) d8,
	(case ultmo_digto when 9 then  ultmo_digto else '-1' end) d9
	From  bdafiliacion..tbsedes  a left   OUTER JOIN #tmptbpromotoresSedes b on
		( b.cnsctvo_cdgo_sde = a.cnsctvo_cdgo_sde)
	Where        a.vsble_usro='S'  )  tmpPromotoresSedes
Group by cdgo_sde,dscrpcn_sde,cnsctvo_cdgo_sde



select  cdgo_sde,dscrpcn_sde,
(case  when d0>=0 then 'S' else 'N' end) d0,
(case  when d1>=0 then 'S' else 'N' end) d1,
(case  when d2>=0 then 'S' else 'N' end) d2,
(case  when d3>=0 then 'S' else 'N' end) d3,
(case  when d4>=0 then 'S' else 'N' end) d4,
(case  when d5>=0 then 'S' else 'N' end) d5,
(case  when d6>=0 then 'S' else 'N' end) d6,
(case  when d7>=0 then 'S' else 'N' end) d7,
(case  when d8>=0 then 'S' else 'N' end) d8,
(case  when d9>=0 then 'S' else 'N' end) d9,
(case  when d0>=0 or d1>=0 or d2>=0 or d3>=0 or d4>=0 or d5>=0 or d6>=0 or d7>=0 or d8>=0 or d9>=0  then 'SELECCIONADO'  else  'NO SELECCIONADO' end) accn,
cnsctvo_cdgo_sde, 0 cntdd ,0 Cmbo_rgstro
from #tmptbpromotoresSedes1