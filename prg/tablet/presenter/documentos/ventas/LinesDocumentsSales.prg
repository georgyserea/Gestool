#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS LinesDocumentsSales FROM Editable

   DATA oSender

   DATA cOldCodigoArticulo                                  INIT ""

   DATA hAtipicaClienteValues

   DATA oViewEditDetail

   METHOD New( oSender )

   METHOD getSender()                                       INLINE ( ::oSender )
   METHOD getView()                                         INLINE ( ::getSender():nView )

   METHOD hSetMaster( cField, uValue )                      INLINE ( hSet( ::oSender:hDictionaryMaster, cField, uValue ) )
   METHOD hGetMaster( cField )                              INLINE ( hGet( ::oSender:hDictionaryMaster, cField ) )

   METHOD hSetDetail( cField, uValue )                      INLINE ( hSet( ::oSender:oDocumentLineTemporal:hDictionary, cField, uValue ) )
   METHOD hGetDetail( cField )                              INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, cField ) )

   METHOD lSeekArticulo()
   METHOD lSeekAlmacen()
   METHOD lArticuloObsoleto()

   METHOD setCodigo( cCodigo )                              INLINE ( ::hSetDetail( "Articulo", cCodigo ) )
   METHOD setDetalle( cDetalle )                            INLINE ( ::hSetDetail( "DescripcionArticulo", cDetalle ) )
   METHOD setDescripcionAmpliada( cDescripcion )            INLINE ( ::hSetDetail( "DescripcionAmpliada", cDescripcion ) )
   METHOD setCodigoProveedor( cCodigo )                     INLINE ( ::hSetDetail( "Proveedor", cCodigo ) )
   METHOD setNombreProveedor( cNombreProveedor )            INLINE ( ::hSetDetail( "NombreProveedor", cNombreProveedor ) )
   METHOD setReferenciaProveedor( cRefProveedor )           INLINE ( ::hSetDetail( "ReferenciaProveedor", cRefProveedor ) )
   
   METHOD setAlmacen( cCodigoAlmacen )                      INLINE ( ::oViewEditDetail:oGetAlmacen:cText( cCodigoAlmacen ), ::cargaAlmacen() )
   METHOD setNombreAlmacen( cNombreAlmacen )                INLINE ( ::oViewEditDetail:oGetNombreAlmacen:cText( cNombreAlmacen ) )

   METHOD setLogicoLote( lLote )                            INLINE ( ::hSetDetail( "LogicoLote", lLote ) )
   METHOD setLote( cLote )                                  INLINE ( ::hSetDetail( "Lote", cLote ) )
   METHOD setTipoVenta( lTipoVenta )                        INLINE ( ::hSetDetail( "AvisarSinStock", lTipoVenta ) )
   METHOD setNoPermitirVentaSinStock( lVentaSinStock )      INLINE ( ::hSetDetail( "NoPermitirSinStock", lVentaSinStock ) )
   METHOD setFamilia( cCodigoFamilia )                      INLINE ( ::hSetDetail( "Familia", cCodigoFamilia ) )
   METHOD setGrupoFamilia( cGrupoFamilia )                  INLINE ( ::hSetDetail( "GrupoFamilia", cGrupoFamilia ) )
   METHOD setPeso( nPeso )                                  INLINE ( ::hSetDetail( "Peso", nPeso ) )
   METHOD setUnidadMedicionPeso( cUnidadMedicion )          INLINE ( ::hSetDetail( "UnidadMedicionPeso", cUnidadMedicion ) )
   METHOD setVolumen( nVolumen )                            INLINE ( ::hSetDetail( "Volumen", nVolumen ) )
   METHOD setUnidadMedicionVolumen( cVolumen )              INLINE ( ::hSetDetail( "UnidadMedicionVolumen", cVolumen ) )
   METHOD setUnidadMedicion( cUnidadMedicion )              INLINE ( ::hSetDetail( "UnidadMedicion", cUnidadMedicion ) )
   METHOD setTipoArticulo( cTipoArticulo )                  INLINE ( ::hSetDetail( "TipoArticulo", cTipoArticulo ) )
   METHOD setCajas( nCajas )                                INLINE ( ::hSetDetail( "Cajas", if( empty( nCajas ), 1, nCajas ) ) )
   METHOD setUnidades( nUnidades )                          INLINE ( ::hSetDetail( "Unidades", if( empty( nUnidades ), 1, nUnidades ) ) )
   METHOD setImpuestoEspecial( cCodigoImpuesto )            INLINE ( ::hSetDetail( "ImpuestoEspecial", cCodigoImpuesto ) )
   METHOD setImporteImpuestoEspecial( nImporte )            INLINE ( ::hSetDetail( "ImporteImpuestoEspecial", nImporte ) )
   METHOD setVolumenImpuestosEspeciales( lImpuesto )        INLINE ( ::hSetDetail( "VolumenImpuestosEspeciales", lImpuesto ) )
   METHOD setPorcentajeImpuesto( nPorcentaje )              INLINE ( ::hSetDetail( "PorcentajeImpuesto", nPorcentaje ) )
   METHOD setRecargoEquivalencia( nPorcentaje )             INLINE ( ::hSetDetail( "RecargoEquivalencia", nPorcentaje ) )
   METHOD setFactorConversion( nFactor )                    INLINE ( ::hSetDetail( "FactorConversion", nFactor ) )
   METHOD setImagen( cImagen )                              INLINE ( ::hSetDetail( "Imagen", cImagen ) )
   METHOD setControlStock( nControlStock )                  INLINE ( ::hSetDetail( "TipoStock", nControlStock ) )
   METHOD setPrecioRecomendado( nPrecio )                   INLINE ( ::hSetDetail( "PrecioVentaRecomendado", nPrecio ) )
   METHOD setPuntoVerde( nPuntoVerde )                      INLINE ( ::hSetDetail( "PuntoVerde", nPuntoVerde ) )
   METHOD setUnidadMedicion( cUnidad )                      INLINE ( ::hSetDetail( "UnidadMedicion", cUnidad ) )

   METHOD setTarifa()                                       INLINE ( ::hSetDetail( "NumeroTarifa", ::hGetMaster( "NumeroTarifa" ) ) ) 
   METHOD setPrecioCosto( nCosto )                          INLINE ( ::hSetDetail( "PrecioCosto", nCosto ) )
      METHOD setPrecioCostoMedio()                          VIRTUAL         
   METHOD setPrecioVenta( nPrecioVenta )                    INLINE ( ::hSetDetail( "PrecioVenta", nPrecioVenta ) )

   METHOD setOldCodigoArticulo()                            INLINE ( ::cOldCodigoArticulo := ::hGetDetail( "Articulo" ) )
   METHOD resetOldCodigoArticulo()                          INLINE ( ::cOldCodigoArticulo := "" )

   METHOD getValorImpuestoEspecial();
      INLINE ( D():ImpuestosEspeciales( ::getView() ):nValImp( ( D():Articulos( ::getView() ) )->cCodImp, ::hGetMaster( "ImpuestosIncluidos" ), ::hGetMaster( "TipoImpuesto" ) ) )

   METHOD setPrecioTarifaCliente()                          VIRTUAL      
   
   METHOD setAtipicasCliente()    
      METHOD buildAtipicaClienteValues()                  

      METHOD setPrecioOfertaArticulo()                      VIRTUAL      

   METHOD setComisionFromMaster()                           INLINE ( ::hSetDetail( "ComisionAgente", ::hGetMaster( "ComisionAgente" ) ) )

      METHOD setComisionTarifaCliente()                     VIRTUAL   
      METHOD setComisionAtipicaCliente()                    VIRTUAL

   METHOD setDescuentoPorcentual( nDescuentoPorcentual )    INLINE ( ::hSetDetail( "DescuentoPorcentual", nDescuentoPorcentual ) )
   METHOD setDescuentoPorcentualFromCliente()               INLINE ( ::setDescuentoPorcentual( nDescuentoArticulo( ::hGetDetail( "Articulo" ), ::hGetMaster( "Cliente" ), ::getView() ) ) )

      METHOD setDescuentoPorcentualTarifaCliente()          VIRTUAL
      METHOD setDescuentoPorcentualAtipicaCliente()         VIRTUAL
      METHOD setDescuentoPorcentualOfertaArticulo()         VIRTUAL

   METHOD setDescuentoPromocional()
      METHOD setDescuentoPromocionalTarifaCliente()         VIRTUAL
      METHOD setDescuentoPromocionalAtipicaCliente()        VIRTUAL

   METHOD setDescuentoLineal( nDescuentoLineal )            INLINE ( ::hSetDetail( "DescuentoLineal", nDescuentoLineal ) )
   METHOD resetDescuentoLineal()                            INLINE ( ::setDescuentoLineal( 0 ) )
      METHOD setDescuentoLinealTarifaCliente()              VIRTUAL       
      METHOD setDescuentoLinealAtipicaCliente()             VIRTUAL
      METHOD setDescuentoLinealOfertaArticulo()             VIRTUAL

   METHOD runGridProduct()
   METHOD runGridStore()

   METHOD cargaArticulo()
   METHOD cargaAlmacen()

   METHOD setLineFromArticulo() 

   METHOD lShowLote()                                       INLINE ( ::hGetDetail( "LogicoLote" ) )

   METHOD resourceDetail( nMode )
      METHOD startResourceDetail()

   METHOD recalcularTotal()

   METHOD onPreSaveAppendDetail()                           INLINE ( .t. )

   METHOD lValidResourceDetail()

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS LinesDocumentsSales

   ::oSender      := oSender

Return ( self )

//---------------------------------------------------------------------------//

METHOD lSeekArticulo() CLASS LinesDocumentsSales

   local cCodigoArticulo     := ::oViewEditDetail:oGetArticulo:varGet()   //::hGetDetail( "Articulo" )

   if empty( cCodigoArticulo )
      Return .f.
   end if

   cCodigoArticulo           := cSeekCodebarView( cCodigoArticulo, ::getView() )

Return ( dbSeekArticuloUpperLower( cCodigoArticulo, ::getView() ) )

//---------------------------------------------------------------------------//

METHOD lSeekAlmacen() CLASS LinesDocumentsSales

   local cCodigoAlmacen     := ::oViewEditDetail:oGetAlmacen:varGet()   //::hGetDetail( "Articulo" )

   if empty( cCodigoAlmacen )
      Return .f.
   end if

Return ( cSeekStoreView( cCodigoAlmacen, ::getView() ) )

//---------------------------------------------------------------------------//

METHOD lArticuloObsoleto() CLASS LinesDocumentsSales

   if !( D():Articulos( ::getView() ) )->lObs
      Return .f.
   end if

   ApoloMsgStop( "Art�culo catalogado como obsoleto" )

   ::oViewEditDetail:oGetArticulo:SetFocus()

Return .t.

//---------------------------------------------------------------------------//   

METHOD setAtipicasCliente() CLASS LinesDocumentsSales

   local hAtipica    := hAtipica( ::buildAtipicaClienteValues() )

   if empty( hAtipica )
      Return ( self )
   end if 

   if hhaskey( hAtipica, "nImporte" ) .and. hget( hAtipica, "nImporte" ) != 0
      ::setPrecioVenta( hget( hAtipica, "nImporte" ) )
   end if

   if hhaskey( hAtipica, "nDescuentoPorcentual" ) .and. hget( hAtipica, "nDescuentoPorcentual" ) != 0 // .and. ::hGetDetail( "DescuentoPorcentual" ) == 0
      ::setDescuentoPorcentual( hget( hAtipica, "nDescuentoPorcentual" ) )   
   end if

   if hhaskey( hAtipica, "nDescuentoLineal" ) .and. hget( hAtipica, "nDescuentoLineal" ) != 0 // .and. ::hGetDetail( "DescuentoLineal" ) == 0
      ::setDescuentoLineal( hget( hAtipica, "nDescuentoLineal" ) )   
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD buildAtipicaClienteValues() CLASS LinesDocumentsSales

   local hAtipicaClienteValues                  := {=>}
   
   hAtipicaClienteValues[ "nView"             ] := ::getView()

   hAtipicaClienteValues[ "cCodigoArticulo"   ] := ::hGetDetail( "Articulo" )
   hAtipicaClienteValues[ "cCodigoPropiedad1" ] := ::hGetDetail( "CodigoPropiedad1" )
   hAtipicaClienteValues[ "cCodigoPropiedad2" ] := ::hGetDetail( "CodigoPropiedad2" )
   hAtipicaClienteValues[ "cValorPropiedad1"  ] := ::hGetDetail( "ValorPropiedad1" )
   hAtipicaClienteValues[ "cValorPropiedad2"  ] := ::hGetDetail( "ValorPropiedad2" )
   hAtipicaClienteValues[ "cCodigoFamilia"    ] := ::hGetDetail( "Familia" )
   hAtipicaClienteValues[ "nTarifaPrecio"     ] := ::hGetDetail( "NumeroTarifa" )
   hAtipicaClienteValues[ "nCajas"            ] := ::hGetDetail( "Cajas" )
   hAtipicaClienteValues[ "nUnidades"         ] := ::hGetDetail( "Unidades" )

   hAtipicaClienteValues[ "cCodigoCliente"    ] := ::hGetMaster( "Cliente" )   
   hAtipicaClienteValues[ "cCodigoGrupo"      ] := ::hGetMaster( "GrupoCliente" )   
   hAtipicaClienteValues[ "lIvaIncluido"      ] := ::hGetMaster( "ImpuestosIncluidos" )   
   hAtipicaClienteValues[ "dFecha"            ] := ::hGetMaster( "Fecha" )   
   hAtipicaClienteValues[ "nDescuentoTarifa"  ] := ::hGetMaster( "DescuentoTarifa" )   

Return ( hAtipicaClienteValues )

//---------------------------------------------------------------------------//

METHOD setDescuentoPromocional() CLASS LinesDocumentsSales

   ::setDescuentoPromocionalTarifaCliente()     //M�todo Virtual no creado
   ::setDescuentoPromocionalAtipicaCliente()    //M�todo Virtual no creado

Return ( self )

//---------------------------------------------------------------------------//

METHOD setLineFromArticulo() CLASS LinesDocumentsSales

   ::setCodigo( ( D():Articulos( ::getView() ) )->Codigo )
   
   ::setDetalle( ( D():Articulos( ::getView() ) )->Nombre )
   ::setDescripcionAmpliada( ( D():Articulos( ::getView() ) )->Descrip )
   
   ::setCodigoProveedor( ( D():Articulos( ::getView() ) )->cPrvHab )
   ::setNombreProveedor( retFld( ( D():Articulos( ::getView() ) )->cPrvHab, D():Proveedores( ::getView() ) ) )
   ::setReferenciaProveedor( padr( cRefPrvArt( ( D():Articulos( ::getView() ) )->Codigo, ( D():Articulos( ::getView() ) )->cPrvHab , D():ProveedorArticulo( ::getView() ) ), 18 ) )
   
   ::setTipoVenta( ( D():Articulos( ::getView() ) )->lMsgVta )
   
   ::setNoPermitirVentaSinStock( ( D():Articulos( ::getView() ) )->lNotVta )

   ::setFamilia( ( D():Articulos( ::getView() ) )->Familia )
   ::setGrupoFamilia( cGruFam( ( D():Articulos( ::getView() ) )->Familia, D():Familias( ::getView() ) ) )

   ::setPeso( ( D():Articulos( ::getView() ) )->nPesoKg )
   ::setUnidadMedicionPeso( ( D():Articulos( ::getView() ) )->cUndDim ) 

   ::setVolumen( ( D():Articulos( ::getView() ) )->nVolumen )
   ::setUnidadMedicionVolumen( ( D():Articulos( ::getView() ) )->cVolumen ) 
   ::setUnidadMedicion( ( D():Articulos( ::getView() ) )->cUnidad ) 

   ::setTipoArticulo( ( D():Articulos( ::getView() ) )->cCodTip ) 

   ::setCajas( ( D():Articulos( ::getView() ) )->nCajEnt )
   ::setUnidades( ( D():Articulos( ::getView() ) )->nUniCaja )

   ::setImpuestoEspecial( ( D():Articulos( ::getView() ) )->cCodImp )

   ::setImporteImpuestoEspecial( ::getValorImpuestoEspecial() )

   // ::setVolumenImpuestosEspeciales( retFld( ( D():Articulos( ::getView() ) )->cCodImp, D():ImpuestosEspeciales( ::getView() ):Select(), "lIvaVol" ) )

   if ::hGetMaster( "TipoImpuesto" ) <= 1
      ::setPorcentajeImpuesto( nIva( D():TiposIva( ::getView() ), ( D():Articulos( ::getView() ) )->TipoIva ) )
      ::setRecargoEquivalencia( nReq( D():TiposIva( ::getView() ), ( D():Articulos( ::getView() ) )->TipoIva ) )
   end if 

   if ( D():Articulos( ::getView() ) )->lFacCnv
      ::setFactorConversion( ( D():Articulos( ::getView() ) )->nFacCnv )
   end if

   ::setImagen( ( D():Articulos( ::getView() ) )->cImagen ) 

   ::setControlStock( ( D():Articulos( ::getView() ) )->nCtlStock ) 

   ::setPrecioRecomendado( ( D():Articulos( ::getView() ) )->PvpRec ) 

   ::setPuntoVerde( ( D():Articulos( ::getView() ) )->nPntVer1 ) 

   ::setUnidadMedicion( ( D():Articulos( ::getView() ) )->cUnidad ) 

   ::setTarifa()

   ::setPrecioVenta( nRetPreArt( ::hGetDetail( "NumeroTarifa" ), ::hGetMaster( "Divisa" ), ::hGetMaster( "ImpuestosIncluidos" ), D():Articulos( ::getView() ), D():Divisas( ::getView() ), D():Kit( ::getView() ), D():TiposIva( ::getView() ) ) )

   ::setPrecioCosto( ( D():Articulos( ::getView() ) )->pCosto ) 

   if ( D():Articulos( ::getView() ) )->lLote
      
      ::setLogicoLote( ( D():Articulos( ::getView() ) )->lLote )
      
      if accessCode():lAddLote
         ::setLote( ( D():Articulos( ::getView() ) )->cLote )
      end if
      
      ::oViewEditDetail:ShowLote()

   else

      ::oViewEditDetail:HideLote()

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD CargaArticulo() CLASS LinesDocumentsSales

   local cCodArt  := hGet( ::oSender:oDocumentLineTemporal:hDictionary, "Articulo" )

   if Empty( cCodArt )
      Return .f.
   end if

   if ( cCodArt == ::cOldCodigoArticulo )
      Return .t.
   end if

   if !::lSeekArticulo()
      apoloMsgStop( "Art�culo no encontrado" )
      Return .f.
   end if

   if ::lArticuloObsoleto()
      return .f.
   end if

   ::oViewEditDetail:disableDialog()

   ::resetDescuentoLineal()

   ::setLineFromArticulo()

   ::setComisionFromMaster()

   ::setDescuentoPorcentualFromCliente()

   ::setAtipicasCliente()

   ::setOldCodigoArticulo()

   ::oViewEditDetail:enableDialog()

   ::oViewEditDetail:RefreshDialog()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD CargaAlmacen() CLASS LinesDocumentsSales

   if !::lSeekAlmacen()
      apoloMsgStop( "Almac�n no encontrado" )
      Return .f.
   end if

   ::setNombreAlmacen( ( D():Almacen( ::getView() ) )->cNomAlm )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD ResourceDetail( nMode ) CLASS LinesDocumentsSales

   local lResult        := .f.

   ::oViewEditDetail    := ViewDetail():New( self )

   if !Empty( ::oViewEditDetail )

      ::oViewEditDetail:setTitleDocumento( lblTitle( ::oSender:nModeDetail ) + ::oSender:getTextTitle() )

      lResult           := ::oViewEditDetail:Resource( nMode )

   end if

Return ( lResult )   

//---------------------------------------------------------------------------//

METHOD StartResourceDetail() CLASS LinesDocumentsSales

   ::cargaArticulo()

   ::cargaAlmacen()

   ::recalcularTotal()

Return ( self )

//---------------------------------------------------------------------------//

METHOD recalcularTotal() CLASS LinesDocumentsSales

   if !empty( ::oViewEditDetail:oTotalLinea )
      ::oViewEditDetail:oTotalLinea:cText( ::oSender:oDocumentLineTemporal:getBruto() )
   end if

RETURN ( .t. )

//---------------------------------------------------------------------------//

METHOD runGridProduct() CLASS LinesDocumentsSales

   if empty( ::oSender:oProduct:oGridProduct )
      Return ( Self )
   end if

   ::oViewEditDetail:oGetArticulo:Disable()

   ::oSender:oProduct:oGridProduct:showView()

   if ::oSender:oProduct:oGridProduct:isEndOk()
      ::oViewEditDetail:SetGetValue( ( D():Articulos( ::oSender:nView ) )->Codigo, "Articulo" )
   end if

   ::cargaArticulo()

   ::recalcularTotal()

   ::oViewEditDetail:oGetArticulo:Enable()
   ::oViewEditDetail:oGetArticulo:setFocus()

Return ( self )

//---------------------------------------------------------------------------//

METHOD runGridStore() CLASS LinesDocumentsSales

   if empty( ::oSender:oStore:oGrid )
      Return ( Self )
   end if 

   ::oViewEditDetail:oGetAlmacen:Disable()

   ::oSender:oStore:oGrid:showView()

   if ::oSender:oStore:oGrid:isEndOk()
      ::setAlmacen( ( D():Almacen( ::oSender:nView ) )->cCodAlm )
   end if

   ::cargaAlmacen()

   ::oViewEditDetail:oGetAlmacen:Enable()
   ::oViewEditDetail:oGetAlmacen:setFocus()

Return ( self )

//---------------------------------------------------------------------------//

METHOD lValidResourceDetail() CLASS LinesDocumentsSales

   local lReturn  := .t.

   ::oViewEditDetail:oGetLote:lValid()

   if ::hGetDetail( "LogicoLote" ) .and. Empty( ::hGetDetail( "Lote" ) )

      apoloMsgStop( "El campo lote es obligatorio" )

      ::oViewEditDetail:oGetLote:SetFocus()

      lReturn        := .f.

   end if

Return ( lReturn  )

//---------------------------------------------------------------------------//