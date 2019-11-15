create procedure [sp_MSins_dbotbOficinasCertificados_msrepl_ccs] 
  @c1 int,@c2 datetime,@c3 char(30),@c4 char(1),@c5 binary(8)
as 
begin 
if exists ( select * from [dbo].[tbOficinasCertificados]
where [cnsctvo_cdgo_ofcna] = @c1
)
begin
update [dbo].[tbOficinasCertificados] set 
 [fcha_ultma_mdfccn] = @c2
,[usro_ultma_mdfccn] = @c3
,[estdo] = @c4
,[time_stmp] = @c5
where [cnsctvo_cdgo_ofcna] = @c1
end
else
begin
insert into [dbo].[tbOficinasCertificados]( 
 [cnsctvo_cdgo_ofcna]
,[fcha_ultma_mdfccn]
,[usro_ultma_mdfccn]
,[estdo]
,[time_stmp]
 )
values ( 
 @c1
,@c2
,@c3
,@c4
,@c5
 ) 
end
end

