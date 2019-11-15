create procedure [sp_MSins_dbotbOrigenesNovedad_msrepl_ccs] 
  @c1 int,@c2 char(2),@c3 varchar(150),@c4 char(1),@c5 datetime,@c6 datetime,@c7 datetime,@c8 char(30),@c9 varchar(250),@c10 char(1)
as 
begin 
if exists ( select * from [dbo].[tbOrigenesNovedad]
where [cnsctvo_cdgo_orgn] = @c1
)
begin
update [dbo].[tbOrigenesNovedad] set 
 [cdgo_orgn_nvdd] = @c2
,[dscrpcn_orgn_nvdd] = @c3
,[brrdo] = @c4
,[inco_vgnca] = @c5
,[fn_vgnca] = @c6
,[fcha_crcn] = @c7
,[usro_crcn] = @c8
,[obsrvcns] = @c9
,[vsble_usro] = @c10
where [cnsctvo_cdgo_orgn] = @c1
end
else
begin
insert into [dbo].[tbOrigenesNovedad]( 
 [cnsctvo_cdgo_orgn]
,[cdgo_orgn_nvdd]
,[dscrpcn_orgn_nvdd]
,[brrdo]
,[inco_vgnca]
,[fn_vgnca]
,[fcha_crcn]
,[usro_crcn]
,[obsrvcns]
,[vsble_usro]
 )
values ( 
 @c1
,@c2
,@c3
,@c4
,@c5
,@c6
,@c7
,@c8
,@c9
,@c10
 ) 
end
end

