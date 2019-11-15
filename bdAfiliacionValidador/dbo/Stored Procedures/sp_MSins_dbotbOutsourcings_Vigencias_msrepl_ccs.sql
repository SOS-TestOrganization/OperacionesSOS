create procedure [sp_MSins_dbotbOutsourcings_Vigencias_msrepl_ccs] 
  @c1 int,@c2 int,@c3 char(2),@c4 varchar(150),@c5 datetime,@c6 datetime,@c7 datetime,@c8 char(30),@c9 varchar(250),@c10 char(1),@c11 varchar(150),@c12 char(1)
as 
begin 
if exists ( select * from [dbo].[tbOutsourcings_Vigencias]
where [cnsctvo_vgnca_otsrcng] = @c1
)
begin
update [dbo].[tbOutsourcings_Vigencias] set 
 [cnsctvo_cdgo_otsrcng] = @c2
,[cdgo_otsrcng] = @c3
,[dscrpcn_otsrcng] = @c4
,[inco_vgnca] = @c5
,[fn_vgnca] = @c6
,[fcha_crcn] = @c7
,[usro_crcn] = @c8
,[obsrvcns] = @c9
,[vsble_usro] = @c10
,[rta_cps] = @c11
,[asgnr_frmlrs] = @c12
where [cnsctvo_vgnca_otsrcng] = @c1
end
else
begin
insert into [dbo].[tbOutsourcings_Vigencias]( 
 [cnsctvo_vgnca_otsrcng]
,[cnsctvo_cdgo_otsrcng]
,[cdgo_otsrcng]
,[dscrpcn_otsrcng]
,[inco_vgnca]
,[fn_vgnca]
,[fcha_crcn]
,[usro_crcn]
,[obsrvcns]
,[vsble_usro]
,[rta_cps]
,[asgnr_frmlrs]
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
,@c11
,@c12
 ) 
end
end

