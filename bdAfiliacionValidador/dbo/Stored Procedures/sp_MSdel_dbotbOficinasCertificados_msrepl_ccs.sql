create procedure [sp_MSdel_dbotbOficinasCertificados_msrepl_ccs] 
  @pkc1 int
as 
begin 
delete [dbo].[tbOficinasCertificados]
where [cnsctvo_cdgo_ofcna] = @pkc1
end 

