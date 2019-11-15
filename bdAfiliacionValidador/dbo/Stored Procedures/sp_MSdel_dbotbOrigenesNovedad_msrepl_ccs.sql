create procedure [sp_MSdel_dbotbOrigenesNovedad_msrepl_ccs] 
  @pkc1 int
as 
begin 
delete [dbo].[tbOrigenesNovedad]
where [cnsctvo_cdgo_orgn] = @pkc1
end 

