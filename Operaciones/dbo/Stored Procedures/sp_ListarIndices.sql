CREATE PROC sp_ListarIndices
AS
  DECLARE  @tabla varchar(255)

  Create Table #tblConexiones
  (
    Index_name varchar(200),			
    Index_description varchar(400),
    index_key varchar(400),
    tabla varchar(200)
   )


  DECLARE tablas_cursor CURSOR FOR 
  select Distinct tabla  from vwIndices

  OPEN tablas_cursor

  FETCH NEXT FROM tablas_cursor INTO @tabla

             
   WHILE @@FETCH_STATUS = 0
   BEGIN
      Insert Into  #tblConexiones (Index_name, Index_description,index_key)
      exec sp_helpindex  @tabla

      Update #tblConexiones
      Set Tabla=@Tabla
      Where Tabla Is Null
     
      FETCH NEXT FROM tablas_cursor INTO @tabla
   END

   CLOSE tablas_cursor
   DEALLOCATE tablas_cursor
  
   Select v.Tabla, t.index_name Indice,t.index_Description Descripcion,t.Index_Key ClavesIndices, v.IndId, v.Tipoindice,v.OrigFillFactor as FillFactors, v.keycnt ContadorClaves, v.dpages PaginasDatos, v.reserved PagReservadas, v.used Pagusadas, v.rowcnt ContadorFilas, v.maxirow MaxTamFilaNoHoja, v.rowmodctr NumFilasModificadas  From  #tblConexiones  t inner join vwIndices v on t.Index_name=v.indice AND t.Tabla=v.Tabla

   --Select *  From  #tblConexiones  t inner join vwIndices v on t.Index_name=v.indice AND t.Tabla=v.Tabla

   drop table #tblConexiones
