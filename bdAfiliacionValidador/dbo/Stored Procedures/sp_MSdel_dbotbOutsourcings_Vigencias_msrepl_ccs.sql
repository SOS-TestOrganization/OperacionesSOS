create procedure [sp_MSdel_dbotbOutsourcings_Vigencias_msrepl_ccs] 
  @pkc1 int
as 
begin 
delete [dbo].[tbOutsourcings_Vigencias]
where [cnsctvo_vgnca_otsrcng] = @pkc1
end 

