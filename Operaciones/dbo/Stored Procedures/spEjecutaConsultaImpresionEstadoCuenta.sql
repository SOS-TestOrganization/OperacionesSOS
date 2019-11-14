/*---------------------------------------------------------------------------------
* Metodo o PRG   : spEjecutaConsultaImpresionEstadoCuenta
* Desarrollado por  : <\A Ing. Rolando simbaqueva Lasso         A\>
* Descripcion   : <\D Este procedimiento arma y ejecuta la cadena donde se tiene los criterios para seleccionar los promotores y sus sucursales  D\>
* Observaciones   : <\O               O\>
* Parametros   : <\P             P\>
* Variables   : <\V               V\>
* Fecha Creacion  : <\FC 2003/02/10           FC\>
*
*---------------------------------------------------------------------------------
* DATOS DE MODIFICACION
*---------------------------------------------------------------------------------
* Modificado Por   : <\AM  AM\>
* Descripcion   : <\DM  DM\>
* Nuevos Parametros  : <\PM  PM\>
* Nuevas Variables  : <\VM  VM\>
* Fecha Modificacion  : <\FM  FM\>
*---------------------------------------------------------------------------------*/
CREATE   PROCEDURE spEjecutaConsultaImpresionEstadoCuenta

As

Declare
@tbla   varchar(128),
@cdgo_cmpo   varchar(128),
@oprdr   varchar(2),
@vlr    varchar(250),
@cmpo_rlcn   varchar(128),
@cmpo_rlcn_prmtro  varchar(128),
@cnsctvo  Numeric(4),
@IcInstruccion  Nvarchar(4000),
@IcInstruccion1  Nvarchar(4000),
@IcInstruccion2  Nvarchar(4000),
@IcInstruccion3  Nvarchar(4000),
@lcAlias  char(2),
@lnContador  Int

Set Nocount On






-- Contador de condiciones
Select @lnContador = 1

SELECT a.nmro_estdo_cnta,  f.cdgo_tpo_idntfccn,    d.nmro_idntfccn,   i.dscrpcn_clse_aprtnte,
  b.nmbre_scrsl,   space(200)  rzn_scl,  a.ttl_fctrdo,    a.usro_crcn,  
  a.cnsctvo_cdgo_lqdcn,  'NO SELECCIONADO'    accn,
  a.cnsctvo_estdo_cnta,   a.fcha_gnrcn,    a.nmro_unco_idntfccn_empldr,   a.cnsctvo_scrsl,  
  a.cnsctvo_cdgo_clse_aprtnte,      b.sde_crtra_pc     cnsctvo_cdgo_sde,    a.vlr_iva, 
  a.sldo_fvr,    a.ttl_pgr,    a.Cts_Cnclr,     a.Cts_sn_Cnclr,   
  c.cdgo_cdd,    c.dscrpcn_cdd,    e.dscrpcn_prdo,    e.cdgo_prdo,                
    f.dscrpcn_tpo_idntfccn,   b.drccn,     b.tlfno,      
  h.cnsctvo_cdgo_prdo_lqdcn,  h.fcha_incl_prdo_lqdcn   fcha_incl_fctrcn  ,   h.fcha_fnl_prdo_lqdcn fcha_fnl_fctrcn, 
               h.fcha_pgo,   a.sldo_antrr,   
  d.cnsctvo_cdgo_tpo_idntfccn,
  s.dscrpcn_sde,
  convert(int,nmro_estdo_cnta) nmro_Aux , s.cdgo_sde
into  #TmpImpresionEstadosCuenta_aux
FROM  tbEstadosCuenta a,   bdAfiliacion.dbo.tbCiudades c  , bdAfiliacion.dbo.tbSucursalesAportante b   ,
  bdAfiliacion.dbo.tbPeriodos e  , 
  bdAfiliacion.dbo.tbVinculados d  ,
  bdAfiliacion.dbo.tbTiposIdentificacion f ,
  tbliquidaciones g    , 
  tbPeriodosliquidacion_Vigencias h  ,
              bdAfiliacion.dbo.tbClasesAportantes i  ,
  bdAfiliacion.dbo.Tbsedes  s  
Where   a.ttl_pgr     >= 0 -- que el estado de cuenta tenga un valor a pagar mayor a cero
AND  1=2
--and a.cnsctvo_cdgo_estdo_estdo_cnta = 1  --El estado de cuenta este en estado ingresada



Select  @IcInstruccion =   'Insert into #TmpImpresionEstadosCuenta_aux
    Select   a.nmro_estdo_cnta,  f.cdgo_tpo_idntfccn,   d.nmro_idntfccn,    i.dscrpcn_clse_aprtnte,
     b.nmbre_scrsl,   ' + CHAR(39) + '  ' + CHAR(39) + '  rzn_scl,    a.ttl_fctrdo,  
     a.usro_crcn,  
     a.cnsctvo_cdgo_lqdcn  , '
     + CHAR(39) + 'NO SELECCIONADO' + CHAR (39) +  '  accn ,  
     a.cnsctvo_estdo_cnta,   a.fcha_gnrcn,     a.nmro_unco_idntfccn_empldr,
      a.cnsctvo_scrsl,   a.cnsctvo_cdgo_clse_aprtnte,        b.sde_crtra_pc,   a.vlr_iva, 
     a.sldo_fvr,    a.ttl_pgr,     a.Cts_Cnclr,    a.Cts_sn_Cnclr,
     c.cdgo_cdd,    ltrim(rtrim(c.dscrpcn_cdd)) + '  + CHAR (39)  + ' -  ' +  CHAR (39) +  '  + ltrim(rtrim(dp.dscrpcn_dprtmnto))  dscrpcn_cdd,     e.dscrpcn_prdo,   e.cdgo_prdo, 
                      f.dscrpcn_tpo_idntfccn,   b.drccn,     b.tlfno,     h.cnsctvo_cdgo_prdo_lqdcn,
      h.fcha_incl_prdo_lqdcn     ,   h.fcha_fnl_prdo_lqdcn ,                 h.fcha_pgo,  a.sldo_antrr, 
     f.cnsctvo_cdgo_tpo_idntfccn , s.dscrpcn_sde,   convert(int,nmro_estdo_cnta) nmro_Aux, s.cdgo_sde   ' + char(13)   
Set @IcInstruccion  =  @IcInstruccion + 'From tbEstadosCuenta a,   bdAfiliacion.dbo.tbciudades_vigencias c  , bdAfiliacion.dbo.tbSucursalesAportante b   ,
       bdAfiliacion.dbo.tbPeriodos e  , 
       bdAfiliacion.dbo.tbVinculados d  ,
       bdAfiliacion.dbo.tbTiposIdentificacion f ,
       tbliquidaciones g    , 
       tbPeriodosliquidacion_Vigencias h  ,
       bdAfiliacion.dbo.Tbsedes  s  ,
                   bdAfiliacion.dbo.tbClasesAportantes i  ,  bdAfiliacion.dbo.tbdepartamentos dp ' +char(13)

Set    @IcInstruccion1 = 'Where    a.nmro_unco_idntfccn_empldr  =    b.nmro_unco_idntfccn_empldr ' 



Set    @IcInstruccion2 = + ' AND  a.cnsctvo_scrsl   =  b.cnsctvo_scrsl  '   + char(13)
   + ' AND a.cnsctvo_cdgo_clse_aprtnte   =  b.cnsctvo_cdgo_clse_aprtnte  '  + char(13)
   + 'AND  b.cnsctvo_cdgo_cdd   = c.cnsctvo_cdgo_cdd  '   + char(13)
   + 'AND  c.cnsctvo_cdgo_dprtmnto  = dp.cnsctvo_cdgo_dprtmnto  '  + char(13)
   + ' AND a.cnsctvo_cdgo_prdcdd_prpgo   =  e.cnsctvo_cdgo_prdo '  + char(13)  
   + ' AND a.nmro_unco_idntfccn_empldr   =  d.nmro_unco_idntfccn  '  + char(13)
   + ' AND d.cnsctvo_cdgo_tpo_idntfccn   = f.cnsctvo_cdgo_tpo_idntfccn'  + char(13)
   + ' AND a.cnsctvo_cdgo_lqdcn    =  g.cnsctvo_cdgo_lqdcn  '  + char(13)
   + ' AND g.cnsctvo_cdgo_prdo_lqdcn   = h.cnsctvo_cdgo_prdo_lqdcn '  + char(13)
   + ' AND s.cnsctvo_cdgo_sde    = b.sde_crtra_pc  '   + char(13)
   + ' AND a.ttl_pgr    > 0  '     + char(13)
   + ' AND  b.cnsctvo_cdgo_clse_aprtnte   =  i.cnsctvo_cdgo_clse_aprtnte '  + char(13)
   + ' AND g.cnsctvo_cdgo_estdo_lqdcn   = 3'    + char(13)
set  @IcInstruccion3= + ' And  datediff(dd,c.inco_vgnca,getdate())>=0  And datediff(dd,getdate(),c.fn_vgnca)>=0'+char(13) --Para evaluar la vigencia de ciudad
   
Update #tbCriteriosTmp
Set   tbla =  'tbEstadosCuenta'
Where  tbla = '#TmpImpresionEstadosCuenta'


 
 
 -- Se recorre el cursor de criterios
 Declare crCriterios Cursor  For
 Select *
 From #tbCriteriosTmp 
 Order by cnsctvo 
 
 Open crCriterios
 
 Fetch crCriterios Into @tbla ,@cdgo_cmpo ,@oprdr ,@vlr ,@cmpo_rlcn ,@cmpo_rlcn_prmtro,  @cnsctvo
 
 While @@fetch_status =  0 
 Begin
  Select @lcAlias = ''
  Select @tbla = Ltrim(Rtrim(@tbla))

  -- se realiza la asignacion del alias
  If  CHARINDEX('tbEstadosCuenta',@tbla,1) != 0
  Begin
   -- si tabla es tbTiposPagoNotas se asigna como alias b
   Select @lcAlias = 'a.'
  End
  Else
  Begin
   If  CHARINDEX('tbCiudades',@tbla,1) != 0
   Begin
    -- si tabla es tbVinculados se asigna como alias c
    Select @lcAlias = 'c.'
   End
   Else  
   Begin
    If  CHARINDEX('tbSucursalesAportante',@tbla,1) != 0
    Begin
     -- si tabla es tbEstadosNotas se asigna como alias d
     Select @lcAlias = 'b.'
    End
    Else  
    Begin
     If  CHARINDEX('tbPeriodos',@tbla,1) != 0
     Begin
 
      -- si tabla es tbTiposIdentificacion se asigna como alias e
      Select @lcAlias = 'e.'
     End
     Else
     Begin
      --select @tbla, CHARINDEX('tbParametrosProgramacion',@tbla,1)
      If  CHARINDEX('tbVinculados',@tbla,1) != 0
      Begin 
       -- si tabla es tbTiposNotas se asigna como alias f
       Select @lcAlias = 'd.'
      End
      Else
      Begin
       If  CHARINDEX('tbTiposIdentificacion',@tbla,1) != 0
       Begin
 
        -- si tabla es tbSedes se asigna como alias g
        Select @lcAlias = 'f.'
       End
       Else
       Begin
        If  CHARINDEX('tbliquidaciones',@tbla,1) != 0
        Begin
  
         -- si tabla es tbPlanillas se asigna como alias h
         Select @lcAlias = 'g.'
        End
        Else
        Begin
 
         If  CHARINDEX('tbPeriodosliquidacion_Vigencias',@tbla,1) != 0   
         Begin
          -- si tabla es tbNotas se asigna como alias a
          Select @lcAlias = 'h.'
         End
         Else

         Begin
 
          If  CHARINDEX('tbClasesAportantes',@tbla,1) != 0   
           Begin
            -- si tabla es tbNotas se asigna como alias a
            Select @lcAlias = 'i.'
           End
          else
          
           Begin
            If  CHARINDEX('tbsedes',@tbla,1) != 0   
             Begin
              -- si tabla es tbNotas se asigna como alias a
              Select @lcAlias = 's.'
             End

 
           end   


         End    



        End 
       End 
      End
     End
    End     
   End 
  End 
  -- se le adicionan adelante y atras comillas simples al valor de la condicion cuando es diferente el campo de nmro_nta
  if CHARINDEX('nmro_estdo_cnta',@cdgo_cmpo,1) = 0 
   Select @vlr = char(39) + rtrim(ltrim(@vlr)) + char(39) 
 
  If CHARINDEX('fcha',@cdgo_cmpo,1) != 0
   Select @cdgo_cmpo = 'Convert(varchar(10),'+ @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))+',111)'

  Else
  Begin
   -- se le pone el alias cuando el campo es diferente de nmro de nota
   IF CHARINDEX('nmro_estdo_cnta',@cdgo_cmpo,1) = 0
    Select @cdgo_cmpo =  @lcAlias +Ltrim(Rtrim(@cdgo_cmpo))
   
  End
  
  If ltrim(rtrim(@oprdr)) ='N'
  Begin
   Select @IcInstruccion1= @IcInstruccion1 + 'And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is null '+char(13)
  End
  Else
  Begin
   If ltrim(rtrim(@oprdr)) ='NN'
    Select @IcInstruccion1= @IcInstruccion1 + 'And ' +  ltrim(rtrim(@cdgo_cmpo))+' Is Not null '+char(13)
   Else
    Select @IcInstruccion1= @IcInstruccion1 + 'And ' +   ltrim(rtrim(@cdgo_cmpo)) + space(1) +  ltrim(rtrim(@oprdr)) + space(1) + ltrim(rtrim(@vlr)) + char(13)
  End
 
  
  Set @lnContador = @lnContador + 1
  Fetch crCriterios Into @tbla ,@cdgo_cmpo ,@oprdr ,@vlr ,@cmpo_rlcn ,@cmpo_rlcn_prmtro,  @cnsctvo
 End
 -- se cierra el cursor
 Close crCriterios
 Deallocate crCriterios
 
 -- se crea el select
 Select @IcInstruccion = @IcInstruccion+char(13)+ @IcInstruccion1+char(13)+@IcInstruccion2+char(13)+@IcInstruccion3
 
 /*SELECT 'cadena1',substring(ltrim(rtrim(@IcInstruccion)),1,250)
 Select substring(ltrim(rtrim(@IcInstruccion)),251,250)
 Select 'cadena2',substring(ltrim(rtrim(@IcInstruccion)),501,250)
 select substring(ltrim(rtrim(@IcInstruccion)),751,250)
 Select 'cadena3',substring(ltrim(rtrim(@IcInstruccion)),1001,250)  
 Select substring(ltrim(rtrim(@IcInstruccion)),1251,250)*/

Exec sp_executesql     @IcInstruccion


Update  #TmpImpresionEstadosCuenta_aux
Set  rzn_scl  =  c.rzn_scl
From  #TmpImpresionEstadosCuenta_aux  a ,bdafiliacion..tbempleadores b, bdafiliacion..tbempresas c --, tbclasesempleador d
Where a.nmro_unco_idntfccn_empldr  = b.nmro_unco_idntfccn
And a.cnsctvo_cdgo_clse_aprtnte  = b.cnsctvo_cdgo_clse_aprtnte 
And a.nmro_unco_idntfccn_empldr  = c.nmro_unco_idntfccn
--And a.vldo     = 'S'


Update  #TmpImpresionEstadosCuenta_aux
Set  rzn_scl  =   ltrim(rtrim(isnull(prmr_aplldo,'')))  + ' ' + ltrim(rtrim(isnull(sgndo_aplldo,''))) + ' ' + ltrim(rtrim(isnull(prmr_nmbre,''))) + ' ' + ltrim(rtrim(isnull(sgndo_nmbre,'')))
From  #TmpImpresionEstadosCuenta_aux  a , bdafiliacion..tbempleadores b, bdafiliacion..tbpersonas c
Where a.nmro_unco_idntfccn_empldr  = b.nmro_unco_idntfccn
And a.cnsctvo_cdgo_clse_aprtnte  = b.cnsctvo_cdgo_clse_aprtnte 
And a.nmro_unco_idntfccn_empldr  = c.nmro_unco_idntfccn
And rzn_scl     = ''



execute spAdicionaRegistrosImpresionEstadosCuentaManual

