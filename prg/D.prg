#include "FiveWin.Ch"
#include "Factu.ch" 
#include "DBStruct.ch"
#include "Ads.ch"
#include "Xbrowse.ch"
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS D

   CLASSDATA   aStatus

   CLASSDATA   hViews                        INIT {=>}
   CLASSDATA   nView                         INIT 0

   CLASSDATA   cTag

   CLASSDATA   hashTiposIncidencias          INIT {=>}

   METHOD CreateView()                       INLINE   ( HSet( ::hViews, ++::nView, {=>} ), ::nView )
   METHOD DeleteView( nView )

   METHOD InfoView()                         INLINE   ( MsgStop( valtoprg( hGet( ::hViews, ::nView ) ), "Vista : " + alltrim( str( ::nView ) ) ) )

   METHOD AssertView()

   METHOD Get( cDatabase, nView )
      METHOD AddView( cDatabase, cHandle )
      METHOD GetView( cDatabase )
      METHOD OpenDataBase( cDataTable, nView )

   // Temporales---------------------------------------------------------------

   METHOD BuildTmp( cDatabase, cAlias, nView ) 
      METHOD AddViewTmp( cAlias, cHandle, nView )  
      METHOD GetTmp( cAlias, nView )   
      METHOD Tmp( cAlias, nView )
      METHOD GetFileTmp( cAlias, nView ) 
   METHOD CloseTmp( cAlias, nView )

   METHOD GetObject( cObject, nView )

   METHOD getHashRecord( cDatabase, nView )
   METHOD getHashFromAlias( cAlias, aDictionary )
   METHOD getFieldDictionary( cField, cDataTable, nView )
   METHOD getFieldFromAliasDictionary( cField, cAlias, aDictionary )   
   METHOD getIndexFromAliasDictionary( cIndex, aIndex )     INLINE ( hGet( aIndex, cIndex ) )

   METHOD getHashArray( aRecord, cDatabase, nView )
   METHOD getHashTable( cAlias, cDatabase, nView )
   METHOD getHashRecordById( id, cDatabase, nView )
   METHOD getHashRecordBlank( cDatabase, nView )
   METHOD getHashRecordDefaultValues( cDatabase, nView )    INLINE ( ::setDefaultValue( ::getHashRecordBlank( cDatabase, nView ), cDatabase, nView ) )
   METHOD deleteRecord( cDataTable, nView )  

   METHOD getArrayRecordById( id, cDatabase, nView )
   METHOD setDefaultValue( hash, cDataTable, nView )

   METHOD appendHashRecord( hTable, cDataTable, nView ) 
   METHOD appendHashRecordInWorkarea( hTable, cDataTable, workArea ) 
   METHOD editHashRecord( hTable, cDataTable, nView )

   METHOD setHashRecord( cDatabase, nView )
   METHOD saveFieldsToRecord()
   METHOD getFieldFromDictionary()

   METHOD getId( cDatabase, nView )                         INLINE ( ( ::Get( cDatabase, nView ) )->( eval( TDataCenter():getIdBlock( cDatabase ) ) ) )
   METHOD getDictionary( cDatabase )                        INLINE ( TDataCenter():getDictionary( cDatabase ) )  
   METHOD getDictionaryFromArea( cArea )                    INLINE ( TDataCenter():getDictionaryFromArea( cArea ) )   
   METHOD getIndexFromArea( cArea )                         INLINE ( TDataCenter():getIndexFromArea( cArea ) )   

   // Presupuestos de clientes-------------------------------------------------

   METHOD PresupuestosClientes( nView )                     INLINE ( ::Get( "PreCliT", nView ) )
      METHOD PresupuestosClientesFecha( nView )             INLINE ( ( ::Get( "PreCliT", nView ) )->dFecPre )
      METHOD PresupuestosClientesId( nView )                INLINE ( ( ::Get( "PreCliT", nView ) )->cSerPre + str( ( ::Get( "PreCliT", nView ) )->nNumPre, 9 ) + ( ::Get( "PreCliT", nView ) )->cSufPre )
      METHOD PresupuestosClientesIdTextShort( nView ) ;
                                                            INLINE ( ( ::Get( "PreCliT", nView ) )->cSerPre + "/" + alltrim( str( ( ::Get( "PreCliT", nView ) )->nNumPre, 9 ) ) )
      METHOD PresupuestosClientesIdText( nView ) ;
                                                            INLINE ( ::PresupuestosClientesIdTextShort( nView ) + "/" + ( ::Get( "PreCliT", nView ) )->cSufPre )

   METHOD PresupuestosClientesLineas( nView )               INLINE ( ::Get( "PreCliL", nView ) )
      METHOD PresupuestosClientesLineasId( nView )          INLINE ( ( ::Get( "PreCliL", nView ) )->cSerPre + str( ( ::Get( "PreCliL", nView ) )->nNumPre, 9 ) + ( ::Get( "PreCliL", nView ) )->cSufPre )

   METHOD PresupuestosClientesDocumentos( nView )           INLINE ( ::Get( "PreCliD", nView ) )
      METHOD PresupuestosClientesDocumentosId( nView )      INLINE ( ( ::Get( "PreCliD", nView ) )->cSerPre + str( ( ::Get( "PreCliD", nView ) )->nNumPre, 9 ) + ( ::Get( "PreCliD", nView ) )->cSufPre )

   METHOD PresupuestosClientesIncidencias( nView )          INLINE ( ::Get( "PreCliI", nView ) )
      METHOD PresupuestosClientesIncidenciasId( nView )     INLINE ( ( ::Get( "PreCliI", nView ) )->cSerPre + str( ( ::Get( "PreCliI", nView ) )->nNumPre, 9 ) + ( ::Get( "PreCliI", nView ) )->cSufPre )

   METHOD PresupuestosClientesSituaciones( nView )          INLINE ( ::Get( "PreCliE", nView ) )
      METHOD PresupuestosClientesSituacionesId( nView )     INLINE ( ( ::Get( "PreCliE", nView ) )->cSerPre + str( ( ::Get( "PreCliE", nView ) )->nNumPre, 9 ) + ( ::Get( "PreCliE", nView ) )->cSufPre )
      METHOD PresupuestosClientesSituacionesIdText( nView ) INLINE ( ::Get( "PreCliE", nView ) )->cSerPre + "/" + Alltrim( Str( ( ::Get( "PreCliE", nView ) )->nNumPre ) )

   // SAT de clientes------------------------------------------------------

   METHOD SatClientesTableName()                            INLINE ( "SatCliT" )
   METHOD SatClientes( nView )                              INLINE ( ::Get( "SatCliT", nView ) )
      METHOD SatClientesId( nView )                         INLINE ( ( ::Get( "SatCliT", nView ) )->cSerSat + str( ( ::Get( "SatCliT", nView ) )->nNumSat, 9 ) + ( ::Get( "SatCliT", nView ) )->cSufSat )
      METHOD SatClientesFecha( nView )                      INLINE ( ( ::Get( "SatCliT", nView ) )->dFecSat )
      METHOD SatClientesIdTextShort( nView )                INLINE ( ( ::Get( "SatCliT", nView ) )->cSerSat + "/" + alltrim( str( ( ::Get( "SatCliT", nView ) )->nNumSat, 9 ) ) )
      METHOD SatClientesIdText( nView )                     INLINE ( ::SatClientesIdTextShort( nView ) + "/" + ( ::Get( "SatCliT", nView ) )->cSufSat )

      METHOD GetSatClientesHash( aArray, nView )            INLINE ( ::getHashArray( aArray, "SatCliL", nView ) )

   METHOD SATClientesLineasTableName()                      INLINE ( "SatCliL" )
   METHOD SatClientesLineas( nView )                        INLINE ( ::Get( "SatCliL", nView ) )
      METHOD SatClientesLineasId( nView )                   INLINE ( ( ::SatClientesLineas( nView ) )->cSerSat + str( ( ::SatClientesLineas( nView ) )->nNumSat, 9 ) + ( ::SatClientesLineas( nView ) )->cSufSat )
      METHOD SatClientesLineasEof( nView )                  INLINE ( ( ::SatClientesLineas( nView ) )->( eof() ) )
      METHOD SatClientesLineasNotEof( nView )               INLINE ( !::SatClientesLineasEof( nView ) )
      METHOD GetSatClientesLineasHash( aArray, nView )      INLINE ( ::getHashArray( aArray, "SatCliT", nView ) )

   METHOD SatClientesIncidencias( nView )                   INLINE ( ::Get( "SatCliI", nView ) )
      METHOD SatClientesIncidenciasId( nView )              INLINE ( ( ::Get( "SatCliI", nView ) )->cSerSat + str( ( ::Get( "SatCliI", nView ) )->nNumSat, 9 ) + ( ::Get( "SatCliI", nView ) )->cSufSat )

   METHOD SatClientesDocumentos( nView )                    INLINE ( ::Get( "SatCliD", nView ) )
      METHOD SatClientesDocumentosId( nView )               INLINE ( ( ::Get( "SatCliD", nView ) )->cSerSat + str( ( ::Get( "SatCliD", nView ) )->nNumSat, 9 ) + ( ::Get( "SatCliD", nView ) )->cSufSat )                                                

   // Albaranes de clientes----------------------------------------------------

   METHOD AlbaranesClientes( nView )                        INLINE ( ::Get( "AlbCliT", nView ) )
      METHOD AlbaranesClientesFecha( nView )                INLINE ( ( ::Get( "AlbCliT", nView ) )->dFecAlb )
      METHOD AlbaranesClientesId( nView )                   INLINE ( ( ::Get( "AlbCliT", nView ) )->cSerAlb + str( ( ::Get( "AlbCliT", nView ) )->nNumAlb, 9 ) + ( ::Get( "AlbCliT", nView ) )->cSufAlb )
      METHOD AlbaranesClientesIdTextShort( nView );
                                                            INLINE ( ::Get( "AlbCliT", nView ) )->cSerAlb + "/" + Alltrim( Str( ( ::Get( "AlbCliT", nView ) )->nNumAlb ) )
      METHOD AlbaranesClientesIdText( nView )               INLINE ( ::AlbaranesClientesIdTextShort( nView ) + "/" + ( ::Get( "AlbCliT", nView ) )->cSufAlb ) 
      METHOD getHashAlbaranCliente( nView )                 INLINE ( ::getHashRecordById( ::AlbaranesClientesId( nView ), ::AlbaranesClientes( nView ), nView ) )
      METHOD getDefaultHashAlbaranCliente( nView )          INLINE ( ::getHashRecordDefaultValues( ::AlbaranesClientes( nView ), nView ) )

   METHOD AlbaranesClientesLineas( nView )                  INLINE ( ::Get( "AlbCliL", nView ) )
      METHOD AlbaranesClientesLineasId( nView )             INLINE ( ( ::Get( "AlbCliL", nView ) )->cSerAlb + str( ( ::Get( "AlbCliL", nView ) )->nNumAlb, 9 ) + ( ::Get( "AlbCliL", nView ) )->cSufAlb )
      METHOD AlbaranesClientesLineasEof( nView )            INLINE ( ( ::AlbaranesClientesLineas( nView ) )->( eof() ) )
      METHOD AlbaranesClientesLineasNotEof( nView )         INLINE (!( ::AlbaranesClientesLineasEof( nView ) ) ) 

      METHOD getAlbaranClienteLineasHash( nView )           INLINE ( ::getHashRecord( ::AlbaranesClientesLineas( nView ), nView ) )
      METHOD getAlbaranClienteLineas( nView )               INLINE ( ::getArrayRecordById( ::AlbaranesClientesId( nView ), ::AlbaranesClientesLineas( nView ), nView ) )
      METHOD getAlbaranClienteLineaBlank( nView )           INLINE ( ::getHashRecordBlank( ::AlbaranesClientesLineas( nView ), nView ) )
      METHOD getAlbaranClienteLineaDefaultValues( nView )   INLINE ( ::getHashRecordDefaultValues( ::AlbaranesClientesLineas( nView ), nView ) )

   METHOD getStatusAlbaranesClientesLineas( nView )         INLINE ( ::aStatus := aGetStatus( ::AlbaranesClientesLineas( nView ) ) )
   METHOD setStatusAlbaranesClientesLineas( nView )         INLINE ( SetStatus( ::AlbaranesClientesLineas( nView ), ::aStatus ) )

   METHOD setFocusAlbaranesClientesLineas( cTag, nView )    INLINE ( ::cTag   := ( ::AlbaranesClientesLineas( nView ) )->( ordSetFocus( cTag ) ) )

   METHOD getStatusAlbaranesClientes( nView )               INLINE ( ::aStatus := aGetStatus( ::AlbaranesClientes( nView ) ) )
   METHOD setStatusAlbaranesClientes( nView )               INLINE ( SetStatus( ::AlbaranesClientes( nView ), ::aStatus ) )

   METHOD AlbaranesClientesSeries( nView )                  INLINE ( ::Get( "AlbCliS", nView ) )
      METHOD AlbaranesClientesSeriesId( nView )             INLINE ( ( ::Get( "AlbCliS", nView ) )->cSerAlb + str( ( ::Get( "AlbCliS", nView ) )->nNumAlb, 9 ) + ( ::Get( "AlbCliS", nView ) )->cSufAlb )

   METHOD AlbaranesClientesCobros( nView )                  INLINE ( ::Get( "AlbCliP", nView ) )
      METHOD AlbaranesClientesCobrosId( nView )             INLINE ( ( ::Get( "AlbCliP", nView ) )->cSerAlb + str( ( ::Get( "AlbCliP", nView ) )->nNumAlb, 9 ) + ( ::Get( "AlbCliP", nView ) )->cSufAlb )

   METHOD AlbaranesClientesIncidencias( nView )             INLINE ( ::Get( "AlbCliI", nView ) )
      METHOD AlbaranesClientesIncidenciasId( nView )        INLINE ( ( ::Get( "AlbCliI", nView ) )->cSerAlb + str( ( ::Get( "AlbCliI", nView ) )->nNumAlb, 9 ) + ( ::Get( "AlbCliI", nView ) )->cSufAlb )

   METHOD AlbaranesClientesDocumentos( nView )              INLINE ( ::Get( "AlbCliD", nView ) )
      METHOD AlbaranesClientesDocumentosId( nView )         INLINE ( ( ::Get( "AlbCliD", nView ) )->cSerAlb + str( ( ::Get( "AlbCliD", nView ) )->nNumAlb, 9 ) + ( ::Get( "AlbCliD", nView ) )->cSufAlb )

   METHOD AlbaranesClientesSituaciones( nView )             INLINE ( ::Get( "AlbCliE", nView ) )
      METHOD AlbaranesClientesSituacionesId( nView )        INLINE ( ( ::Get( "AlbCliE", nView ) )->cSerAlb + str( ( ::Get( "AlbCliE", nView ) )->nNumAlb, 9 ) + ( ::Get( "AlbCliE", nView ) )->cSufAlb )
      METHOD AlbaranesClientesSituacionesIdText( nView )    INLINE ( ::Get( "AlbCliE", nView ) )->cSerAlb + "/" + Alltrim( Str( ( ::Get( "AlbCliE", nView ) )->nNumAlb ) )

   // Facturas de clientes-----------------------------------------------------

   METHOD FacturasClientes( nView )                         INLINE ( ::Get( "FacCliT", nView ) )
      METHOD FacturasClientesFecha( nView )                 INLINE ( ( ::FacturasClientes( nView ) )->dFecFac )
      METHOD FacturasClientesId( nView )                    INLINE ( if( ( ::Get( "FacCliT", nView ) )->nNumFac == 0, "", ( ::Get( "FacCliT", nView ) )->cSerie + Str( ( ::Get( "FacCliT", nView ) )->nNumFac ) + ( ::Get( "FacCliT", nView ) )->cSufFac ) )
      METHOD FacturasClientesIdShort( nView )               INLINE ( ( ::Get( "FacCliT", nView ) )->cSerie + alltrim( Str( ( ::Get( "FacCliT", nView ) )->nNumFac ) ) )
      METHOD FacturasClientesIdTextShort( nView )           INLINE ( ( ::Get( "FacCliT", nView ) )->cSerie + "/" + Alltrim( Str( ( ::Get( "FacCliT", nView ) )->nNumFac ) ) )
      METHOD FacturasClientesIdText( nView )                INLINE ( ::FacturasClientesIdTextShort( nView ) + "/" + ( ::Get( "FacCliT", nView ) )->cSufFac )
      METHOD getFacturaCliente( nView )                     INLINE ( ::getHashRecordById( ::FacturasClientesId( nView ), ::FacturasClientes( nView ), nView ) )
      METHOD getDefaultHashFacturaCliente( nView )          INLINE ( ::getHashRecordDefaultValues( ::FacturasClientes( nView ), nView ) )

      METHOD getStatusFacturasClientes( nView )             INLINE ( ::aStatus := aGetStatus( ::FacturasClientes( nView ) ) )
      METHOD setStatusFacturasClientes( nView )             INLINE ( SetStatus( ::FacturasClientes( nView ), ::aStatus ) ) 

      METHOD lockFacturasClientes( nView )                  INLINE ( dbLock( ::Get( "FacCliT", nView ) ) )
      METHOD unlockFacturasClientes( nView )                INLINE ( ( ::Get( "FacCliT", nView ) )->( dbUnLock() ) ) 

   METHOD FacturasClientesLineas( nView )                   INLINE ( ::Get( "FacCliL", nView ) )
      METHOD FacturasClientesLineasId( nView )              INLINE ( ( ::Get( "FacCliL", nView ) )->cSerie + Str( ( ::Get( "FacCliL", nView ) )->nNumFac ) +  ( ::Get( "FacCliL", nView ) )->cSufFac )
      METHOD FacturasClientesLineasEof( nView )             INLINE ( ( ::FacturasClientesLineas( nView ) )->( eof() ) )
      METHOD FacturasClientesLineasNotEof( nView )          INLINE (!( ::FacturasClientesLineasEof( nView ) ) ) 

      METHOD setFocusFacturasClientesLineas( cTag, nView )  INLINE ( ::cTag   := ( ::FacturasClientesLineas( nView ) )->( ordSetFocus( cTag ) ) )

      METHOD getFacturaClienteLineasHash( nView )           INLINE ( ::getHashRecord( ::FacturasClientesLineas( nView ), nView ) )
      METHOD getFacturaClienteLineas( nView )               INLINE ( ::getArrayRecordById( ::FacturasClientesId( nView ), ::FacturasClientesLineas( nView ), nView ) )
      METHOD getFacturaClienteLineaBlank( nView )           INLINE ( ::getHashRecordBlank( ::FacturasClientesLineas( nView ), nView ) )
      METHOD getFacturaClienteLineaDefaultValues( nView )   INLINE ( ::getHashRecordDefaultValues( ::FacturasClientesLineas( nView ), nView ) )

   METHOD getStatusFacturasClientesLineas( nView )          INLINE ( ::aStatus := aGetStatus( ::FacturasClientesLineas( nView ) ) )
   METHOD setStatusFacturasClientesLineas( nView )          INLINE ( SetStatus( ::FacturasClientesLineas( nView ), ::aStatus ) )

   METHOD FacturasClientesIncidencias( nView )              INLINE ( ::Get( "FacCliI", nView ) )
      METHOD FacturasClientesIncidenciasId( nView )         INLINE ( ( ::Get( "FacCliI", nView ) )->cSerie + Str( ( ::Get( "FacCliI", nView ) )->nNumFac ) +  ( ::Get( "FacCliI", nView ) )->cSufFac )

   METHOD FacturasClientesDocumentos( nView )               INLINE ( ::Get( "FacCliD", nView ) )
      METHOD FacturasClientesDocumentosId( nView )          INLINE ( ( ::Get( "FacCliD", nView ) )->cSerie + Str( ( ::Get( "FacCliD", nView ) )->nNumFac ) +  ( ::Get( "FacCliD", nView ) )->cSufFac )

   METHOD FacturasClientesCobros( nView )                   INLINE ( ::Get( "FacCliP", nView ) )
      METHOD FacturasClientesCobrosIdShort( nView )         INLINE ( ( ::Get( "FacCliP", nView ) )->cSerie + Str( ( ::Get( "FacCliP", nView ) )->nNumFac ) +  ( ::Get( "FacCliP", nView ) )->cSufFac )
      METHOD FacturasClientesCobrosId( nView )              INLINE ( ::FacturasClientesCobrosIdShort( nView ) + Str( ( ::Get( "FacCliP", nView ) )->nNumRec ) )

   METHOD FacturasClientesEntidades( nView )                INLINE ( ::Get( "FacCliE", nView ) )
      METHOD FacturasClientesEntidadesId( nView )           INLINE ( ( ::FacturasClientesEntidades(nView) ) )->cSerFac + Str( ( ::FacturasClientesEntidades(nView) )->nNumFac ) + ( ( ::FacturasClientesEntidades(nView) )->cSufFac )
      METHOD gotoIdFacturasClientesEntidades( id, nView )   INLINE ( ::seek( ::FacturasClientesEntidades( nView ), id ) ) 
      METHOD deleteFacturasClientesEntidades( nView )       INLINE ( iif(  dbLock( ( ::FacturasClientesEntidades( nView ) ) ),;
                                                                           ( ( ::FacturasClientesEntidades( nView ) )->( dbDelete() ), ( ::FacturasClientesEntidades( nView ) )->( dbUnLock() ) ),;
                                                                     ) )  
      METHOD eofFacturasClientesEntidades( nView )          INLINE ( ( ::FacturasClientesEntidades( nView ) )->( eof() ) )

   METHOD FacturasClientesSituaciones( nView )              INLINE ( ::Get( "FacCliC", nView ) )
      METHOD FacturasClientesSituacionesId( nView )         INLINE ( ( ::Get( "FacCliC", nView ) )->cSerFac + str( ( ::Get( "FacCliC", nView ) )->nNumFac, 9 ) + ( ::Get( "FacCliC", nView ) )->cSufFac )
      METHOD FacturasClientesSituacionesIdText( nView )     INLINE ( ::Get( "FacCliC", nView ) )->cSerFac + "/" + Alltrim( Str( ( ::Get( "FacCliC", nView ) )->nNumFac ) )

   METHOD FacturasClientesSeries( nView )                   INLINE ( ::Get( "FacCliS", nView ) )

   METHOD AnticiposClientes( nView )                        INLINE ( ::Get( "AntCliT", nView ) )
      METHOD AnticiposClientesId( nView )                   INLINE ( ( ::Get( "AntCliT", nView ) )->cSerAnt )  

   // Facturas rectificativas--------------------------------------------------

   METHOD FacturasRectificativas( nView )                      INLINE ( ::Get( "FacRecT", nView ) )
      METHOD FacturasRectificativasId( nView )                 INLINE ( ( ::Get( "FacRecT", nView ) )->cSerie + str( ( ::Get( "FacRecT", nView ) )->nNumFac, 9 ) + ( ::Get( "FacRecT", nView ) )->cSufFac )

   METHOD FacturasRectificativasLineas( nView )                INLINE ( ::Get( "FacRecL", nView ) )
      METHOD FacturasRectificativasLineasId( nView )           INLINE ( ( ::Get( "FacRecL", nView ) )->cSerie + str( ( ::Get( "FacRecL", nView ) )->nNumFac, 9 ) + ( ::Get( "FacRecL", nView ) )->cSufFac )

   METHOD FacturasRectificativasIncidencias( nView )           INLINE ( ::Get( "FacRecI", nView ) )
      METHOD FacturasRectificativasIncidenciasId( nView )      INLINE ( ( ::Get( "FacRecI", nView ) )->cSerie + str( ( ::Get( "FacRecI", nView ) )->nNumFac, 9 ) + ( ::Get( "FacRecI", nView ) )->cSufFac )

   METHOD FacturasRectificativasDocumentos( nView )            INLINE ( ::Get( "FacRecD", nView ) )
      METHOD FacturasRectificativasDocumentosId( nView )       INLINE ( ( ::Get( "FacRecD", nView ) )->cSerie + str( ( ::Get( "FacRecD", nView ) )->nNumFac, 9 ) + ( ::Get( "FacRecD", nView ) )->cSufFac )

   METHOD FacturasRectificativasSituaciones( nView )           INLINE ( ::Get( "FacRecE", nView ) )
      METHOD FacturasRectificativasSituacionesId( nView )      INLINE ( ( ::Get( "FacRecE", nView ) )->cSerFac + str( ( ::Get( "FacRecE", nView ) )->nNumFac, 9 ) + ( ::Get( "FacRecE", nView ) )->cSufFac )
      METHOD FacturasRectificativasSituacionesIdText( nView )  INLINE ( ::Get( "FacRecE", nView ) )->cSerFac + "/" + Alltrim( Str( ( ::Get( "FacRecE", nView ) )->nNumFac ) )

   // Tikets de clientes-------------------------------------------------------

   METHOD Tikets( nView )                                   INLINE ( ::Get( "TikeT", nView ) )
      METHOD TiketsId( nView )                              INLINE ( ( ::Tikets( nView ) )->cSerTik + ( ::Tikets( nView ) )->cNumTik + ( ::Tikets( nView ) )->cSufTik )
      METHOD gotoIdTikets( id, nView )                      INLINE ( ::seekInOrd( ::Tikets( nView ), id, "cNumTik" ) ) 

   METHOD TiketsLineas( nView )                             INLINE ( ::Get( "TikeL", nView ) )
      METHOD TiketsLineasId( nView )                        INLINE ( ( ::TiketsLineas( nView ) )->cSerTil + ( ::TiketsLineas( nView ) )->cNumTil + ( ::TiketsLineas( nView ) )->cSufTil )
      METHOD gotoIdTiketsLineas( id, nView )                INLINE ( ::seekInOrd( ::TiketsLineas( nView ), id, "cNumTil" ) ) 

      METHOD setFocusTiketsLineas( cTag, nView )            INLINE ( ::cTag   := ( ::TiketsLineas( nView ) )->( ordSetFocus( cTag ) ) )

      METHOD TiketsLineasEof( nView )                       INLINE ( ( ::TiketsLineas( nView ) )->( eof() ) )
      METHOD TiketsLineasNotEof( nView )                    INLINE (!( ::TiketsLineasEof( nView ) ) ) 

   METHOD getStatusTiketsLineas( nView )                    INLINE ( ::aStatus := aGetStatus( ::TiketsLineas( nView ) ) )
   METHOD setStatusTiketsLineas( nView )                    INLINE ( SetStatus( ::TiketsLineas( nView ), ::aStatus ) )

   // Pedidos de clientes------------------------------------------------------

   METHOD PedidosClientesTableName()                        INLINE ( "PedCliT" )
   METHOD PedidosClientes( nView )                          INLINE ( ::Get( "PedCliT", nView ) )
      METHOD PedidosClientesId( nView )                     INLINE ( ( ::Get( "PedCliT", nView ) )->cSerPed + str( ( ::Get( "PedCliT", nView ) )->nNumPed, 9 ) + ( ::Get( "PedCliT", nView ) )->cSufPed )
      METHOD PedidosClientesIdText( nView )                 INLINE ( ::Get( "PedCliT", nView ) )->cSerPed + "/" + Alltrim( Str( ( ::Get( "PedCliT", nView ) )->nNumPed ) )
      METHOD GetPedidoCliente( nView )                      INLINE ( ::getHashRecordById( ::PedidosClientesId( nView ), ::PedidosClientes( nView ), nView ) )
      METHOD GetPedidoClienteById( id, nView )              INLINE ( ::getHashRecordById( id, ::PedidosClientes( nView ), nView ) )
      METHOD GetPedidoClienteBlank( nView )                 INLINE ( ::getHashRecordBlank( ::PedidosClientes( nView ), nView ) )
      METHOD getDefaultHashPedidoCliente( nView )           INLINE ( ::getHashRecordDefaultValues( ::PedidosClientes( nView ), nView ) )

      METHOD gotoIdPedidosClientes( id, nView )             INLINE ( ::seekInOrd( ::PedidosClientes( nView ), id, "nNumPed" ) ) 

      METHOD getStatusPedidosClientes( nView )              INLINE ( ::aStatus := aGetStatus( ::PedidosClientes( nView ) ) )
      METHOD setStatusPedidosClientes( nView )              INLINE ( SetStatus( ::PedidosClientes( nView ), ::aStatus ) ) 
      METHOD setFocusPedidosClientes( cTag, nView )         INLINE ( ::cTag   := ( ::PedidosClientes( nView )  )->( ordSetFocus( cTag ) ) )

   METHOD PedidosClientesReservas( nView )                  INLINE ( ::Get( "PedCliR", nView ) )

   METHOD PedidosClientesLineasTableName()                  INLINE ( "PedCliL" )
   METHOD PedidosClientesLineas( nView )                    INLINE ( ::Get( "PedCliL", nView ) )
      METHOD PedidosClientesLineasId( nView )               INLINE ( ( ::Get( "PedCliL", nView ) )->cSerPed + str( ( ::Get( "PedCliL", nView ) )->nNumPed, 9 ) + ( ::Get( "PedCliL", nView ) )->cSufPed )
      METHOD GetPedidoClienteLineasHash( nView )            INLINE ( ::getHashRecord( ::PedidosClientesLineas( nView ), nView ) )
      METHOD GetPedidoClienteLineas( nView )                INLINE ( ::getArrayRecordById( ::PedidosClientesId( nView ), ::PedidosClientesLineas( nView ), nView ) )
      METHOD GetPedidoClienteLineaBlank( nView )            INLINE ( ::getHashRecordBlank( ::PedidosClientesLineas( nView ), nView ) )
      METHOD GetPedidoClienteLineasDefaultValue( nView )    INLINE ( ::getHashRecordDefaultValues( ::PedidosClientesLineas( nView ), nView ) )

      METHOD getStatusPedidosClientesLineas( nView )        INLINE ( ::aStatus := aGetStatus( ::PedidosClientesLineas( nView ) ) )
      METHOD setStatusPedidosClientesLineas( nView )        INLINE ( SetStatus( ::PedidosClientesLineas( nView ), ::aStatus ) ) 

   METHOD PedidosClientesSituaciones( nView )               INLINE ( ::Get( "PedCliE", nView ) )
      METHOD PedidosClientesSituacionesId( nView )          INLINE ( ( ::Get( "PedCliE", nView ) )->cSerPed + str( ( ::Get( "PedCliE", nView ) )->nNumPed, 9 ) + ( ::Get( "PedCliE", nView ) )->cSufPed )
      METHOD PedidosClientesSituacionesIdText( nView )      INLINE ( ::Get( "PedCliE", nView ) )->cSerPed + "/" + Alltrim( Str( ( ::Get( "PedCliE", nView ) )->nNumPed ) )

   METHOD PedidosClientesIncidencias( nView )               INLINE ( ::Get( "PedCliI", nView ) )
      METHOD PedidosClientesIncidenciasId( nView )          INLINE ( ( ::Get( "PedCliI", nView ) )->cSerPed + str( ( ::Get( "PedCliI", nView ) )->nNumPed, 9 ) + ( ::Get( "PedCliI", nView ) )->cSufPed )

   METHOD PedidosClientesDocumentos( nView )                INLINE ( ::Get( "PedCliD", nView ) )
      METHOD PedidosClientesDocumentosId( nView )           INLINE ( ( ::Get( "PedCliD", nView ) )->cSerPed + str( ( ::Get( "PedCliD", nView ) )->nNumPed, 9 ) + ( ::Get( "PedCliD", nView ) )->cSufPed )

   METHOD PedidosClientesPagos( nView )                     INLINE ( ::Get( "PedCliP", nView ) )
      METHOD PedidosClientesPagosId( nView )                INLINE ( ( ::Get( "PedCliP", nView ) )->cSerPed + str( ( ::Get( "PedCliP", nView ) )->nNumPed, 9 ) + ( ::Get( "PedCliP", nView ) )->cSufPed )

   // Situaciones----------------------------------------------------------------

   METHOD Situaciones( nView )                        INLINE ( ::Get( "Situa", nView ) )
      METHOD SituacionesId( nView )                   INLINE ( ( ::Get( "Situa", nView ) )->cSitua )

   // Clientes-----------------------------------------------------------------

   METHOD Clientes( nView )                           INLINE ( ::Get( "Client", nView ) )
      METHOD ClientesId( nView )                      INLINE ( ( ::Get( "Client", nView ) )->Cod )
      METHOD ClientesNombre( nView )                  INLINE ( ( ::Get( "Client", nView ) )->Titulo )
      METHOD getClientesField( nView, cField )        INLINE ( ( ::Get( "Client", nView ) )->( fieldget( fieldpos( cField ) ) ) )
      METHOD gotoIdClientes( id, nView )              INLINE ( ::SeekInOrd( ::Clientes( nView ), id, "Cod" ) ) 
      METHOD getStatusClientes( nView )               INLINE ( ::aStatus := aGetStatus( ::Clientes( nView ) ) )
      METHOD setStatusClientes( nView )               INLINE ( SetStatus( ::Get( "Client", nView ), ::aStatus ) ) 
      METHOD getCurrentHashClientes( nView )          INLINE ( ::getHashRecordById( ::ClientesId( nView ), ::Clientes( nView ), nView ) )
      METHOD getDefaultHashClientes( nView )          INLINE ( ::getHashRecordDefaultValues( ::Clientes( nView ), nView ) )
      METHOD setScopeClientes( id, nView )            INLINE ( iif( empty( id ), id := ::ClientesId( nView ), ),;
                                                               ::getStatusClientes( nView ),;
                                                               ( ::Clientes( nView ) )->( ordScope( 0, id ) ),;
                                                               ( ::Clientes( nView ) )->( ordScope( 1, id ) ),;
                                                               ( ::Clientes( nView ) )->( dbgotop() ) )  
      METHOD quitScopeClientes( nView )               INLINE ( ( ::Clientes( nView ) )->( ordScope( 0, nil ) ),;
                                                               ( ::Clientes( nView ) )->( ordScope( 1, nil ) ),;
                                                               ::setStatusClientes( nView ) )
      METHOD getLastKeyClientes( nView )              INLINE ( nextkey( space(12), ::Clientes( nView ), "0", retNumCodCliEmp() ) )
      METHOD setFocusClientes( cTag, nView )          INLINE ( ::cTag   := ( ::Clientes( nView )  )->( ordSetFocus( cTag ) ) )

   METHOD ClientesDirecciones( nView )                   INLINE ( ::Get( "ObrasT", nView ) )
      METHOD ClientesDireccionesId( nView )              INLINE ( ( ::Get( "ObrasT", nView ) )->cCodCli )
      METHOD getStatusClientesDirecciones( nView )       INLINE ( ::aStatus := aGetStatus( ::ClientesDirecciones( nView ) ) )
      METHOD setStatusClientesDirecciones( nView )       INLINE ( SetStatus( ::Get( "ObrasT", nView ), ::aStatus ) ) 
      METHOD setFocusClientesDirecciones( cTag, nView )  INLINE ( ::cTag   := ( ::ClientesDirecciones( nView )  )->( ordSetFocus( cTag ) ) )
      METHOD gotoIdClientesDirecciones( id, nView );
                                                         INLINE ( ::seek( ::ClientesDirecciones( nView ), id ) ) 

   METHOD TiposIncidencias( nView )                      INLINE ( ::Get( "TipInci", nView ) )
      METHOD TiposIncidenciasId( nView )                 INLINE ( ( ::Get( "TipInci", nView ) )->cCodInci )
      METHOD TiposIncidenciasNombre( nView )             INLINE ( ( ::Get( "TipInci", nView ) )->cNomInci )
      METHOD getHashTiposIncidencias( nView )
      METHOD getTiposIncicencias( nView )      
      METHOD getCodigoTipoIncicencias( cNombreIncidencia, nView )
      METHOD getNombreTipoIncicencias( cCodigoIncidencia, nView )


   METHOD ClientesIncidencias( nView )                   INLINE ( ::Get( "CliInc", nView ) )
      METHOD ClientesIncidenciasId( nView )              INLINE ( ( ::Get( "CliInc", nView ) )->cCodCli )
      METHOD ClientesIncidenciasNombre( nView )          INLINE ( ( ::Get( "CliInc", nView ) )->mDesInc )
      METHOD gotoIdClientesIncidencias( id, nView )      INLINE ( ::SeekInOrd( ::ClientesIncidencias( nView ), id, "cCodCli" ) ) 
      METHOD eofClientesIncidecias( nView )              INLINE ( ( ::ClientesIncidencias( nView ) )->( eof() ) )
      METHOD getStatusClientesIncidencias( nView )       INLINE ( ::aStatus := aGetStatus( ::ClientesIncidencias( nView ) ) )
      METHOD setStatusClientesIncidencias( nView )       INLINE ( SetStatus( ::ClientesIncidencias( nView ), ::aStatus ) ) 
      METHOD setScopeClientesIncidencias( id, nView )    INLINE ( if( empty( id ), id := ::ClientesId( nView ), ),;
                                                                  ::getStatusClientesIncidencias( nView ),;
                                                                  ( ::ClientesIncidencias( nView ) )->( ordScope( 0, id ) ),;
                                                                  ( ::ClientesIncidencias( nView ) )->( ordScope( 1, id ) ),;
                                                                  ( ::ClientesIncidencias( nView ) )->( dbgotop() ) )  
      METHOD quitScopeClientesIncidencias( nView )       INLINE ( ( ::ClientesIncidencias( nView ) )->( ordScope( 0, nil ) ),;
                                                                  ( ::ClientesIncidencias( nView ) )->( ordScope( 1, nil ) ),;
                                                                  ::setStatusClientesIncidencias( nView ) )  

   METHOD ClientesDocumentos( nView )                 INLINE ( ::Get( "ClientD", nView ) )

   METHOD ClientesBancos( nView )                     INLINE ( ::Get( "CliBnc", nView ) )
      METHOD getStatusClientesBancos( nView )         INLINE ( ::aStatus := aGetStatus( ::ClientesBancos( nView ) ) )
      METHOD setStatusClientesBancos( nView )         INLINE ( SetStatus( ::Get( "CliBnc", nView ), ::aStatus ) ) 
      METHOD setFocusClientesBancos( cTag, nView )    INLINE ( ::cTag   := ( ::ClientesBancos( nView )  )->( ordSetFocus( cTag ) ) )

   METHOD ClientesEntidad( nView )                    INLINE ( ::Get( "CliDad", nView ) )
      METHOD ClientesEntidadId( nView )               INLINE ( ( ::Get( "CliDad", nView ) )->cCodCli )
      METHOD eofClientesEntidad( nView )              INLINE ( ( ::Get( "CliDad", nView ) )->( eof() ) )
      METHOD gotoIdClientesEntidad( id, nView )       INLINE ( ::seek( ::ClientesEntidad( nView ), id ) ) 

   METHOD GruposClientes( nView )                     INLINE ( ::GetObject( "GruposClientes", nView ) )
   METHOD GrupoClientes( nView )                      INLINE ( ::Get( "GrpCli", nView ) )

   METHOD MovimientosAlmacen( nView )                 INLINE ( ::Get( "RemMovT", nView ) )
   METHOD MovimientosAlmacenLineas( nView )           INLINE ( ::Get( "HisMov", nView ) )

   // Pedidos de proveedores---------------------------------------------------

   METHOD PedidosProveedoresTableName()               INLINE ( "PedProvT" )
   METHOD PedidosProveedores( nView )                 INLINE ( ::Get( "PedProvT", nView ) )
      METHOD PedidosProveedoresId( nView )            INLINE ( ( ::Get( "PedProvT", nView ) )->cSerPed + str( ( ::Get( "PedProvT", nView ) )->nNumPed, 9 ) + ( ::Get( "PedProvT", nView ) )->cSufPed )
      METHOD gotoIdPedidosProveedores( id, nView )    INLINE ( ::seekInOrd( ::PedidosProveedores( nView ), id, "nNumPed" ) ) 

   METHOD PedidosProveedoresLineasTableName( nView )           INLINE ( "PedProvL" )
   METHOD PedidosProveedoresLineas( nView )                    INLINE ( ::Get( "PedProvL", nView ) )
      METHOD PedidosProveedoresLineasId( nView )               INLINE ( ( ::Get( "PedProvL", nView ) )->cSerPed + str( ( ::Get( "PedProvL", nView ) )->nNumPed, 9 ) + ( ::Get( "PedProvL", nView ) )->cSufPed )
      METHOD getStatusPedidosProveedoresLineas( nView )        INLINE ( ::aStatus := aGetStatus( ::PedidosProveedoresLineas( nView ) ) )
      METHOD setStatusPedidosProveedoresLineas( nView )        INLINE ( SetStatus( ::PedidosProveedoresLineas( nView ), ::aStatus ) ) 
      METHOD setFocusPedidosProveedoresLineas( cTag, nView )   INLINE ( ::cTag   := ( ::PedidosProveedoresLineas( nView )  )->( ordSetFocus( cTag ) ) )

   METHOD PedidosProveedoresIncidencias( nView )            INLINE ( ::Get( "PedPrvI", nView ) )

   METHOD PedidosProveedoresDocumentos( nView )             INLINE ( ::Get( "PedPrvD", nView ) )

   // Albaranes de proveedores-------------------------------------------------

   METHOD AlbaranesProveedores( nView )                  INLINE ( ::Get( "AlbProvT", nView ) ) 
      METHOD AlbaranesProveedoresId( nView )             INLINE ( ( ::Get( "AlbProvT", nView ) )->cSerAlb + str( ( ::Get( "AlbProvT", nView ) )->nNumAlb, 9 ) + ( ::Get( "AlbProvT", nView ) )->cSufAlb )
      METHOD AlbaranesProveedoresFecha( nView )          INLINE ( ( ::Get( "AlbProvT", nView ) )->dFecAlb )
      METHOD AlbaranesProveedoresFacturado( nView )      INLINE ( ( ::Get( "AlbProvT", nView ) )->nFacturado == 3 )
      METHOD AlbaranesProveedoresNoFacturado( nView )    INLINE ( !::AlbaranesProveedoresFacturado( nView ) )

      METHOD getStatusAlbaranesProveedores( nView )      INLINE ( ::aStatus := aGetStatus( ::Get( "AlbProvT", nView ) ) )
      METHOD setStatusAlbaranesProveedores( nView )      INLINE ( SetStatus( ::Get( "AlbProvT", nView ), ::aStatus ) ) 

      METHOD setFocusAlbaranesProveedores( cTag, nView );
                                                         INLINE ( ::cTag   := ( ::Get( "AlbProvT", nView ) )->( ordSetFocus( cTag ) ) )
      METHOD restoreFocusAlbaranesProveedores( nView );
                                                         INLINE ( ( ::Get( "AlbProvT", nView ) )->( ordSetFocus( ::cTag ) ) )

      METHOD AlbaranesProveedoresLineas( nView )         INLINE ( ::Get( "AlbProvL", nView ) )
         METHOD AlbaranesProveedoresLineasId( nView )    INLINE ( ( ::Get( "AlbProvL", nView ) )->cSerAlb + str( ( ::Get( "AlbProvL", nView ) )->nNumAlb, 9 ) + ( ::Get( "AlbProvL", nView ) )->cSufAlb )
         METHOD AlbaranesProveedoresLineasNumero( nView );
                                                         INLINE ( ( ::Get( "AlbProvL", nView ) )->cSerAlb + str( ( ::Get( "AlbProvL", nView ) )->nNumAlb, 9 ) + ( ::Get( "AlbProvL", nView ) )->cSufAlb + str( ( ::Get( "AlbProvL", nView ) )->nNumLin, 4 ) )
      METHOD AlbaranesProveedoresLineasFacturada( nView );
                                                         INLINE ( ( ::AlbaranesProveedoresLineas( nView ) )->lFacturado )
      METHOD AlbaranesProveedoresLineasNoFacturada( nView );
                                                         INLINE ( !::AlbaranesProveedoresLineasFacturada( nView ) )

      METHOD getStatusAlbaranesProveedoresLineas( nView );
                                                         INLINE ( ::aStatus := aGetStatus( ::Get( "AlbProvL", nView ) ) )
      METHOD setStatusAlbaranesProveedoresLineas( nView );
                                                         INLINE ( SetStatus( ::Get( "AlbProvL", nView ), ::aStatus ) ) 

      METHOD setFocusAlbaranesProveedoresLineas( cTag, nView );
                                                         INLINE ( ::cTag   := ( ::Get( "AlbProvL", nView ) )->( ordSetFocus( cTag ) ) )
      METHOD restoreFocusAlbaranesProveedoresLineas( nView );
                                                         INLINE ( ( ::Get( "AlbProvL", nView ) )->( ordSetFocus( ::cTag ) ) )

      METHOD AlbaranesProveedoresSeries( nView )         INLINE ( ::Get( "AlbPrvS", nView ) )
         METHOD AlbaranesProveedoresSeriesId( nView )    INLINE ( ( ::Get( "AlbPrvS", nView ) )->cSerAlb + str( ( ::Get( "AlbPrvS", nView ) )->nNumAlb, 9 ) + ( ::Get( "AlbPrvS", nView ) )->cSufAlb )

      METHOD getStatusAlbaranesProveedoresSeries( nView );
                                                         INLINE ( ::aStatus := aGetStatus( ::Get( "AlbPrvS", nView ) ) )
      METHOD setStatusAlbaranesProveedoresSeries( nView );
                                                         INLINE ( SetStatus( ::Get( "AlbPrvS", nView ), ::aStatus ) ) 

      METHOD setFocusAlbaranesProveedoresSeries( cTag, nView );
                                                         INLINE ( ::cTag   := ( ::Get( "AlbPrvS", nView ) )->( ordSetFocus( cTag ) ) )
      METHOD restoreFocusAlbaranesProveedoresSeries( nView );
                                                         INLINE ( ( ::Get( "AlbPrvS", nView ) )->( ordSetFocus( ::cTag ) ) )

      METHOD AlbaranesProveedoresIncidencias( nView )    INLINE ( ::Get( "AlbPrvI", nView ) )
      METHOD AlbaranesProveedoresDocumentos( nView )     INLINE ( ::Get( "AlbPrvD", nView ) )


   // Facturas proveedores-----------------------------------------------------

   METHOD FacturasProveedores( nView )                   INLINE ( ::Get( "FacPrvT", nView ) ) 
      METHOD FacturasProveedoresId( nView )              INLINE ( ( ::Get( "FacPrvT", nView ) )->cSerFac + str( ( ::Get( "FacPrvT", nView ) )->nNumFac, 9 ) + ( ::Get( "FacPrvT", nView ) )->cSufFac )
      METHOD FacturasProveedoresIdText( nView )          INLINE ( ( ::Get( "FacPrvT", nView ) )->cSerFac + "/" + alltrim( str( ( ::Get( "FacPrvT", nView ) )->nNumFac, 9 ) ) + "/" + ( ::Get( "FacPrvT", nView ) )->cSufFac )

   METHOD FacturasProveedoresLineas( nView )             INLINE ( ::Get( "FacPrvL", nView ) )
      METHOD FacturasProveedoresLineasId( nView )        INLINE ( ( ::Get( "FacPrvL", nView ) )->cSerFac + str( ( ::Get( "FacPrvL", nView ) )->nNumFac, 9 ) + ( ::Get( "FacPrvL", nView ) )->cSufFac )

   METHOD FacturasProveedoresIncidencias( nView )        INLINE ( ::Get( "FacPrvI", nView ) )
      METHOD FacturasProveedoresIncidenciasId ( nView )  INLINE ( ( ::Get( "FacPrvI", nView ) )->cSerFac + str( ( ::Get( "FacPrvI", nView ) )->nNumFac, 9 ) + ( ::Get( "FacPrvI", nView ) )->cSufFac )

   METHOD FacturasProveedoresDocumentos( nView )         INLINE ( ::Get( "FacPrvD", nView ) )
      METHOD FacturasProveedoresDocumentosId( nView )    INLINE ( ( ::Get( "FacPrvD", nView ) )->cSerFac + str( ( ::Get( "FacPrvD", nView ) )->nNumFac, 9 ) + ( ::Get( "FacPrvD", nView ) )->cSufFac )

   METHOD FacturasProveedoresSeries( nView )             INLINE ( ::Get( "FacPrvS", nView ) )
      METHOD FacturasProveedoresSeriesId( nView )        INLINE ( ( ::Get( "FacPrvS", nView ) )->cSerFac + str( ( ::Get( "FacPrvS", nView ) )->nNumFac, 9 ) + ( ::Get( "FacPrvS", nView ) )->cSufFac )

   METHOD FacturasProveedoresPagos( nView )              INLINE ( ::Get( "FacPrvP", nView ) )
      METHOD FacturasProveedoresPagosId( nView )         INLINE ( ( ::Get( "FacPrvP", nView ) )->cSerFac + str( ( ::Get( "FacPrvP", nView ) )->nNumFac, 9 ) + ( ::Get( "FacPrvP", nView ) )->cSufFac )

   // Facturas rectificativas proveedores--------------------------------------

   METHOD FacturasRectificativasProveedores( nView )                 INLINE ( ::Get( "RctPrvT", nView ) )
      METHOD FacturasRectificativasProveedoresId( nView )            INLINE ( ( ::Get( "RctPrvT", nView ) )->cSerFac + str( ( ::Get( "RctPrvT", nView ) )->nNumFac, 9 ) + ( ::Get( "RctPrvT", nView ) )->cSufFac )

      METHOD FacturasRectificativasProveedoresLineas( nView )        INLINE ( ::Get( "RctPrvL", nView ) )
      METHOD FacturasRectificativasProveedoresLineasId( nView )      INLINE ( ( ::Get( "RctPrvL", nView ) )->cSerFac + str( ( ::Get( "RctPrvL", nView ) )->nNumFac, 9 ) + ( ::Get( "RctPrvL", nView ) )->cSufFac )

      METHOD FacturasRectificativasProveedoresIncidencias( nView )   INLINE ( ::Get( "RctPrvI", nView ) )

      METHOD FacturasRectificativasProveedoresDocumentos( nView )    INLINE ( ::Get( "RctPrvD", nView ) )

      METHOD FacturasRectificativasProveedoresSeries( nView )        INLINE ( ::Get( "RctPrvS", nView ) )

   // Proveedores--------------------------------------------------------------

   METHOD Proveedores( nView )                                       INLINE ( ::Get( "Provee", nView ) )
      METHOD ProveedoresId( nView )                                  INLINE ( ( ::Get( "Provee", nView ) )->COD )
      METHOD GruposProveedores( nView )                              INLINE ( ::GetObject( "GruposProveedores", nView ) )
      METHOD BancosProveedores( nView )                              INLINE ( ::Get( "PrvBnc", nView ) )

   // Produccion---------------------------------------------------------------

   METHOD PartesProduccion( nView )                                  INLINE ( ::Get( "ProCab", nView ) )

      METHOD PartesProduccionMaterialProducido( nView )              INLINE ( ::Get( "ProLin", nView ) )
      METHOD PartesProduccionMaterialProduccionSeries( nView )       INLINE ( ::Get( "ProSer", nView ) )
      METHOD PartesProduccionMateriaPrima( nView )                   INLINE ( ::Get( "ProMat", nView ) )
      METHOD PartesProduccionMaquinaria( nView )                     INLINE ( ::Get( "ProMaq", nView ) )  
      METHOD PartesProduccionOperarios( nView )                      INLINE ( ::Get( "ProPer", nView ) )

   METHOD TiposIva( nView )                                       INLINE ( ::Get( "TIva", nView ) )

   METHOD ProveedorArticulo( nView )                              INLINE ( ::Get( "ProvArt", nView ) )

   METHOD ArticuloLenguaje( nView )                               INLINE ( ::Get( "ArtLeng", nView ) )

   METHOD Articulos( nView )                                      INLINE ( ::Get( "Articulo", nView ) )
   METHOD ArticulosId( nView )                                    INLINE ( ( ::Articulos( nView ) )->Codigo )
   METHOD ArticulosIdText( nView )                                INLINE ( alltrim( ( ::Articulos( nView ) )->Codigo ) + Space(1) + alltrim( ( ::Articulos( nView ) )->Nombre ) )

   METHOD gotoArticulos( id, nView )                              INLINE ( ::seekInOrd( ::Articulos( nView ), id, "Codigo" ) ) 
   METHOD getArticuloTablaPropiedades( id, nView )  
   METHOD setArticuloTablaPropiedades( id, idCodigoPrimeraPropiedad, idCodigoSegundaPropiedad, idValorPrimeraPropiedad, idValorSegundaPropiedad, nUnidades, aPropertiesTable )

      METHOD getStatusArticulos( nView )                          INLINE ( ::aStatus := aGetStatus( ::Articulos( nView ) ) )
      METHOD setStatusArticulos( nView )                          INLINE ( SetStatus( ::Articulos( nView ), ::aStatus ) ) 
      METHOD setFocusArticulos( cTag, nView )                     INLINE ( ::cTag   := ( ::Articulos( nView )  )->( ordSetFocus( cTag ) ) )

      METHOD ArticulosCodigosBarras( nView )                      INLINE ( ::Get( "ArtCodebar", nView ) )
      METHOD ArticuloPrecioPropiedades( nView )                   INLINE ( ::Get( "ArtDiv", nView ) )
      METHOD ArticuloStockAlmacenes( nView )                      INLINE ( ::Get( "ArtAlm", nView ) )
      METHOD ArticuloStockAlmacenesId( nView )                    INLINE ( ( ::Get( "ArtAlm", nView ) )->cCodArt ) 

   METHOD Ofertas( nView )                                        INLINE ( ::Get( "Oferta", nView ) )
      METHOD getStatusOfertas( nView )                            INLINE ( ::aStatus := aGetStatus( ::Ofertas( nView ) ) )
      METHOD setStatusOfertas( nView )                            INLINE ( SetStatus( ::Ofertas( nView ), ::aStatus ) ) 

   METHOD TipoArticulos( nView )                                  INLINE ( ::Get( "TipArt", nView ) )

   METHOD TarifaPrecios( nView )                                  INLINE ( ::Get( "TarPreT", nView ) )

   METHOD TarifaPreciosLineas( nView )                            INLINE ( ::Get( "TarPreL", nView ) )

   METHOD Familias( nView )                                       INLINE ( ::Get( "Familias", nView ) )
      METHOD FamiliasId( nView )                                  INLINE ( ( ::Get( "Familias", nView ) )->CCODFAM )
   
   METHOD Temporadas( nView )                                     INLINE ( ::Get( "Temporadas", nView ) )

   METHOD Categorias( nView )                                     INLINE ( ::Get( "Categorias", nView ) )

   METHOD Kit( nView )                                            INLINE ( ::Get( "ArtKit", nView ) )

   METHOD FormasPago( nView )                                     INLINE ( ::Get( "FPago", nView ) )
      METHOD gotoFormasPago( id, nView )                          INLINE ( ::seekInOrd( ::FormasPago( nView ), id, "cCodPago" ) ) 
      METHOD getStatusFormasPago( nView )                         INLINE ( ::aStatus := aGetStatus( ::FormasPago( nView ) ) )
      METHOD setStatusFormasPago( nView )                         INLINE ( SetStatus( ::FormasPago( nView ), ::aStatus ) ) 

   METHOD Divisas( nView )                                        INLINE ( ::Get( "Divisas", nView ) )

   METHOD Cajas( nView )                                          INLINE ( ::Get( "Cajas", nView ) )

   METHOD Propiedades( nView )                                    INLINE ( ::Get( "Pro", nView ) )
      METHOD PropiedadesLineas( nView )                           INLINE ( ::Get( "TblPro", nView ) )
      METHOD gotoIdPropiedadesLineas( id, nView )                 INLINE ( ::seekInOrd( ::PropiedadesLineas( nView ), id, "cCodPro" ) ) 

   METHOD Almacen( nView )                   INLINE ( ::Get( "Almacen", nView ) )

   METHOD Documentos( nView )                INLINE ( ::Get( "RDocumen", nView ) )

   METHOD Usuarios( nView )                  INLINE ( ::Get( "Users", nView ) )

   METHOD UbicacionLineas( nView )           INLINE ( ::Get( "UbiCal", nView ) )

   METHOD Delegaciones( nView )              INLINE ( ::Get( "Delega", nView ) )

   METHOD Contadores( nView )                INLINE ( ::Get( "NCount", nView ) )

   METHOD Empresa( nView )                   INLINE ( ::Get( "Empresa", nView ) )
   METHOD EmpresaBancos( nView )             INLINE ( ::Get( "EmpBnc", nView ) )

   METHOD Atipicas( nView )                  INLINE ( ::Get( "CliAtp", nView ) )
      METHOD gotoIdAtipicasAgentes( idAgente, idArticulo, nView ) ;
                                             INLINE ( ::seekInOrd( ::Atipicas( nView ), idAgente + idArticulo, "cAgeArt" ) )

   METHOD ClientesContactos( nView )         INLINE ( ::Get( "CliCto", nView ) )

   METHOD ImpuestosEspeciales( nView )       INLINE ( ::GetObject( "ImpuestosEspeciales", nView ) )

   METHOD Agentes( nView )                   INLINE ( ::Get( "Agentes", nView ) )
      METHOD AgentesId( nView )              INLINE ( ( ::Get( "Agentes", nView ) )->cCodAge )
      METHOD AgentesComisiones( nView )      INLINE ( ::Get( "AgeCom", nView ) )
      METHOD AgentesRelaciones( nView )      INLINE ( ::Get( "AgeRel", nView ) )

   METHOD Lenguajes( nView )                 INLINE ( ::Get( "Lenguaje", nView ) )

   METHOD Fabricantes( nView )               INLINE ( ::Get( "Fabricantes", nView ) )

   METHOD Ruta( nView )                      INLINE ( ::Get( "Ruta", nView ) )

   METHOD Operarios( nView )                 INLINE ( ::Get( "OpeT", nView ) )

   METHOD EstadoArticulo( nView )            INLINE ( ::Get( "EstadoSat", nView ) )

   METHOD CamposExtras( nView )              INLINE ( ::Get( "CAMPOEXTRA", nView ) )
   METHOD DetCamposExtras( nView )           INLINE ( ::Get( "DETCEXTRA", nView ) )

   METHOD Pais( nView )                      INLINE ( ::Get( "Pais", nView ) )

   METHOD Turnos( nView )                    INLINE ( ::Get( "Turno", nView ) )

   METHOD Lock( cDatabase, nView )           INLINE ( dbLock( ::Get( cDatabase, nView ) ) )
   METHOD UnLock( cDatabase, nView )         INLINE ( ( ::Get( cDatabase, nView ) )->( dbUnLock() ) ) 

   METHOD GetStatus( cDatabase, nView )      INLINE ( ::aStatus := aGetStatus( ::Get( cDatabase, nView ) ) )
   METHOD SetStatus( cDatabase, nView )      INLINE ( SetStatus( ::Get( cDatabase, nView ), ::aStatus ) ) 
   METHOD GetInitStatus( cDatabase, nView )  INLINE ( ::aStatus := aGetStatus( ::Get( cDatabase, nView ), .t. ) )

   METHOD GetStatusTmp( cDatabase, nView )      INLINE ( ::aStatus := aGetStatus( ::Tmp( cDatabase, nView ) ) )
   METHOD SetStatusTmp( cDatabase, nView )      INLINE ( SetStatus( ::Tmp( cDatabase, nView ), ::aStatus ) ) 
   METHOD GetInitStatusTmp( cDatabase, nView )  INLINE ( ::aStatus := aGetStatus( ::Tmp( cDatabase, nView ), .t. ) )

   METHOD Seek( cWorkArea, uValue )   INLINE ( ( cWorkArea )->( dbSeek( uValue ) ) ) 

   METHOD SeekInOrd( cWorkArea, uValue, cOrder ) ;
                                             INLINE ( dbSeekInOrd( uValue, cOrder, cWorkArea ) )
   METHOD Eof( cWorkArea, nView )            INLINE ( ( cWorkArea )->( eof() ) )

   METHOD Top( cDatabase, nView )            INLINE ( dbFirst( ::Get( cDatabase, nView ) ) )
   METHOD Bottom( cDatabase, nView )         INLINE ( dbLast( ::Get( cDatabase, nView ) ) )

   METHOD OpenObject( oDataTable )

ENDCLASS

   //---------------------------------------------------------------------------//

   METHOD AssertView( nView ) CLASS D

      DEFAULT nView  := ::nView

      if empty( nView )
         msgStop( "No hay vistas disponibles." )
         Return ( .f. )
      end if

      if !hHasKey( ::hViews, nView )
         msgStop( "Vista " + alltrim( str( nView ) / 0 ) + " no encontrada." )

         Return ( .f. )
      end if 

   Return ( .t. )

//---------------------------------------------------------------------------//

   METHOD DeleteView( nView ) CLASS D

      local u
      local value
      local hView

      if ::AssertView( nView )

         hView          := hGet( ::hViews, nView )
         if hb_ishash( hView ) 

            for each u in hView

               value    := u
               do case
                  case isChar( value )
                     if( ( value )->( used() ), ( value )->( dbCloseArea() ), )
                  case isObject( value )
                     value:CloseService()
               end case

            next 

         end if 

         HDel( ::hViews, nView )
         
      end if 

   Return ( Self )

//---------------------------------------------------------------------------//

   METHOD Get( cDataTable, nView ) CLASS D

      local cHandle  := ::GetView( cDataTable, nView )

      if empty( cHandle )
         cHandle     := ::OpenDatabase( cDataTable, nView )
      end if

   RETURN ( cHandle )

//---------------------------------------------------------------------------//

   METHOD GetObject( cName, nView ) CLASS D

      local cHandle  := ::GetView( cName, nView )

      if empty( cHandle )
         ::OpenObject( cName, nView )
      end if

   Return ( cHandle )

//---------------------------------------------------------------------------//

   METHOD GetView( cDatabase, nView ) CLASS D

      local hView
      local cHandle

      if ::AssertView( nView )
         hView          := hGet( ::hViews, nView )
         if hb_ishash( hView ) 
            if hHasKey( hView, Upper( cDatabase ) )
               cHandle  := hGet( hView, Upper( cDatabase ) )
            end if 
         end if 
      end if 

   RETURN ( cHandle )

   //---------------------------------------------------------------------------//

   METHOD GetTmp( cAlias, nView ) CLASS D

      local hGet
      local hView

      if ::AssertView( nView )
         hView             := hGet( ::hViews, nView )
         if hb_ishash( hView ) 
            if hHasKey( hView, Upper( cAlias ) )
               hGet        := hGet( hView, Upper( cAlias ) )
            end if 
         end if 
      end if 

   RETURN ( hGet )

   //---------------------------------------------------------------------------//

   METHOD Tmp( cAlias, nView ) CLASS D

      local hGet
      local cHandle

      hGet           :=  ::GetTmp( Upper( cAlias ), nView )
      if hb_ishash( hGet ) 
         if hHasKey( hGet, "Area" )
            cHandle  := hGet( hGet, "Area" )
         end if 
      end if 

   RETURN ( cHandle )

   //---------------------------------------------------------------------------//

   METHOD GetFileTmp( cAlias, nView ) CLASS D

      local hView
      local hGet
      local cFile

      hGet        := ::GetTmp( Upper( cAlias ), nView )
      if hb_ishash( hGet ) 
         if hHasKey( hGet, "File" )
            cFile    := hGet( hGet, "File" )
         end if 
      end if 

   RETURN ( cFile )

   //---------------------------------------------------------------------------//

   METHOD AddView( cDatabase, cHandle, nView ) CLASS D

      local hView

      if ::AssertView( nView )

         hView    := hGet( ::hViews, nView )
         if hb_ishash( hView )
            hSet( hView, Upper( cDatabase ), cHandle )
         end if 

      end if  

   RETURN ( Self )

   //---------------------------------------------------------------------------//

   METHOD AddViewTmp( cAlias, cFile, cHandle, nView ) CLASS D

      local hView

      if ::AssertView( nView )

         hView    := hGet( ::hViews, nView )
         if hb_ishash( hView )
            hSet( hView, Upper( cAlias ), { "File" => cFile, "Area" => cHandle } )
         end if 

      end if  

   RETURN ( Self )

   //---------------------------------------------------------------------------//

   METHOD OpenDataBase( cDataTable, nView ) CLASS D

      local dbf
      local lOpen
      local oError
      local oBlock
      local uHandle        := .f.
      local oDataTable

      oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
      BEGIN SEQUENCE

         oDataTable        := TDataCenter():ScanDataTable( cDataTable )

         if !empty( oDataTable )

            dbUseArea( .t., ( cDriver() ), ( oDataTable:cAreaName() ), ( cCheckArea( oDataTable:cArea, @dbf ) ), .t., .f. ) // oDataTable:cFileName()
            iif( !lAIS(), ordListAdd( ( oDataTable:cIndexFile ) ), ordSetFocus( 1 ) )

            if !neterr()

               ::AddView( oDataTable:cArea, dbf, nView )

               uHandle     := ::GetView( cDataTable, nView ) 

            end if 

         else 

            msgStop( "No puedo encontrar la tabla " + cDataTable )   

         end if

      RECOVER USING oError

         msgStop( "Imposible abrir todas la base de datos" + CRLF + ErrorMessage( oError ) )

      END SEQUENCE

      ErrorBlock( oBlock )

   Return ( uHandle )

   //---------------------------------------------------------------------------//

   METHOD BuildTmp( cDataTable, cAlias, aIndex, nView ) CLASS D

      local cArea
      local cFile
      local hIndex
      local lOpen       := .f.
      local oDataTable

      cFile             := cGetNewFileName( cPatTmp() + cAlias )
      oDataTable        := TDataCenter():ScanDataTable( cDataTable )

      if empty( oDataTable )
         msgStop( "No puedo encontrar la tabla " + cDataTable )   
         Return ( .f. )
      end if 

      if empty( oDataTable:aStruct )
         msgStop( "La tabla " + cDataTable + " no contiene estructura." )   
         Return ( .f. )
      end if 

      dbCreate( cFile, aSqlStruct( oDataTable:aStruct ), cLocalDriver() )
      dbUseArea( .t., cLocalDriver(), cFile, cCheckArea( cAlias, @cArea ), .f. )

      lOpen       := !neterr()
      if lOpen

         if !empty(aIndex)

            for each hIndex in aIndex
               ( cAlias )->( OrdCondSet( "!Deleted()", {|| !Deleted() } ) )
               ( cAlias )->( OrdCreate( cFile, hGet( hIndex, "tagName" ), hGet( hIndex, "tagExpresion" ), hGet( hIndex, "tagBlock" ) ) )
            next
         
         end if

         ::AddViewTmp( cAlias, cFile, cArea, nView )

      end if 

   Return ( lOpen )

//---------------------------------------------------------------------------//

   METHOD CloseTmp( cAlias, nView ) CLASS D

      local cFile
      local cArea
      local hView

      cArea             := ::Tmp( cAlias, nView )
      if !empty( cArea )
         ( cArea )->( dbCloseArea() )
      end if 

      cFile             := ::GetFileTmp( cAlias, nView )
      if !empty( cFile )
         dbfErase( cFile )
      end if 

      // Sacamos de la lista --------------------------------------------------

      if ::AssertView( nView )
         hView          := hGet( ::hViews, nView )
         if hb_ishash( hView ) 
            hDel( hView, Upper( cAlias ) )
         end if 
      end if 

   Return ( .t. )

//---------------------------------------------------------------------------//

   METHOD OpenObject( cObject, nView ) CLASS D

      local lOpen
      local oObject     := TDataCenter():ScanObject( cObject )

      if !empty( oObject )
         lOpen          := oObject:OpenService()

         if lOpen
            ::AddView( cObject, oObject, nView )
         end if 

      else 

         msgStop( "No puedo encontrar el objeto " + cObject )   
         Return ( .f. )

      end if

   Return ( .t. )

//---------------------------------------------------------------------------//

METHOD getHashRecordById( id, cDatabase, nView ) CLASS D

   local hash  

   ( ::Get( cDatabase, nView ) )->( ordsetfocus( 1 ) )

   if ( ::Get( cDatabase, nView ) )->( dbseek( id ) )
      hash  := ::getHashRecord( cDatabase, nView )
   end if 
   
RETURN ( hash ) 

//---------------------------------------------------------------------------//

METHOD getHashRecordBlank( cDatabase, nView ) CLASS D

   local hash

   ::GetStatus( cDatabase, nView )
   
   ( ::Get( cDatabase, nView ) )->( dbgobottom() )      
   ( ::Get( cDatabase, nView ) )->( dbskip() )
   
   hash  := ::getHashRecord( cDatabase, nView )

   ::SetStatus( cDatabase, nView )

RETURN ( hash ) 

//---------------------------------------------------------------------------//

METHOD getArrayRecordById( id, cDatabase, nView ) CLASS D

   local array    := {}

   ::GetStatus( cDatabase, nView )

   ( ::Get( cDatabase, nView ) )->( ordSetFocus( 1 ) )

   if ( ::Get( cDatabase, nView ) )->( dbSeek( id ) )  
      while ( ::getId( cDatabase, nView ) == id ) .and. !( ::Get( cDatabase, nView ) )->( eof() )  
         aAdd( array, ::getHashRecord( cDatabase, nView ) )
         ( ::Get( cDatabase, nView ) )->( dbSkip() ) 
      end while
   end if 
   
   ::SetStatus( cDatabase, nView )

RETURN ( array ) 

//---------------------------------------------------------------------------//

METHOD getHashRecord( cDataTable, nView ) CLASS D

   local hash        := {=>}
   local cAlias      := ::Get( cDataTable, nView )   
   local aDictionary := TDataCenter():getDictionary( cDataTable )

RETURN ( ::getHashFromAlias( cAlias, aDictionary ) )

//---------------------------------------------------------------------------//

METHOD getHashFromAlias( cAlias, aDictionary ) CLASS D

   local hash        := {=>}

   if isHash( aDictionary ) .and. !empty( cAlias )
      hEval( aDictionary, {|key,value| hSet( hash, key, ( cAlias )->( fieldget( ( cAlias )->( fieldPos( value ) ) ) ) ) } )
      hSet( hash, 'lineSelected', .f. )
   end if 

RETURN ( hash )

//---------------------------------------------------------------------------//

METHOD getFieldDictionary( cField, cDataTable, nView ) CLASS D

   local dbf         := ::Get( cDataTable, nView )   
   local aDictionary := TDataCenter():getDictionary( cDataTable )
   local value       := hGet( aDictionary, cField )

   if !empty( value )
      Return ( ( dbf )->( fieldget( ( dbf )->( fieldPos( value ) ) ) ) )
   endif

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getFieldFromAliasDictionary( cField, cAlias, hDictionary, uDefault ) CLASS D

   local value       

   if hhaskey( hDictionary, cField )
      value          := hGet( hDictionary, cField )
      if !empty( value )
         Return ( ( cAlias )->( fieldget( ( cAlias )->( fieldPos( value ) ) ) ) )
      endif
   end if 

RETURN ( uDefault )

//---------------------------------------------------------------------------//

METHOD getHashArray( aRecord, cDataTable, nView ) CLASS D

   local hash        := {=>}
   local dbf         := ::Get( cDataTable, nView )   
   local aDictionary := TDataCenter():getDictionary( cDataTable )

   if isHash( aDictionary ) .and. !empty( dbf )
      hEval( aDictionary, {|key,value| hSet( hash, key, aRecord[ ( dbf )->( fieldPos( value ) ) ] ) } )
   end if 

RETURN ( hash )

//---------------------------------------------------------------------------//

METHOD getHashTable( dbf, cDataTable, nView ) CLASS D

   local hash        := {=>}
   local aDictionary := TDataCenter():getDictionary( cDataTable )

   if isHash( aDictionary ) .and. !empty( dbf )
      hEval( aDictionary, {|key,value| hSet( hash, key, ( dbf )->( fieldgetbyname( value ) ) ) } )
   end if 

RETURN ( hash )

//---------------------------------------------------------------------------//

METHOD appendHashRecord( hTable, cDataTable, nView ) CLASS D

   local workArea    := ::Get( cDataTable, nView )  

RETURN ( ::appendHashRecordInWorkarea( hTable, cDataTable, workArea )  )

//---------------------------------------------------------------------------//

METHOD appendHashRecordInWorkarea( hTable, cDataTable, workArea )

   local lAppend     := .f.
   local hDictionary 

   if empty( workArea )
      return ( lAppend )
   end if

   hDictionary       := TDataCenter():getDictionary( cDataTable )

   if empty( hDictionary )
      return ( lAppend )
   end if

   ( workArea )->( dbAppend() )
   if !( workArea )->( neterr() )
      ::setHashRecord( hTable, workArea, hDictionary )
      lAppend        := .t.
      ( workArea )->( dbUnLock() )
   end if 

RETURN ( lAppend )

//---------------------------------------------------------------------------//

METHOD editHashRecord( hTable, cDataTable, nView ) CLASS D

   local lEdit       := .f.
   local workArea    := ::Get( cDataTable, nView )   
   local hDictionary := TDataCenter():getDictionary( cDataTable )

   if empty( workArea )
      return ( lEdit )
   end if
      
   if empty( hDictionary )
      return ( lEdit )
   end if

   if ( workArea )->( dbrlock() )
      ::setHashRecord( hTable, workArea, hDictionary )
      lEdit          := .t.
      ( workArea )->( dbUnLock() )
   end if 

RETURN ( lEdit )

//---------------------------------------------------------------------------//

METHOD setHashRecord( hTable, workArea, hDictionary ) CLASS D

   if isHash( hDictionary ) .and. !empty( workArea )
      hEval( hTable, {|cKeyDictionary, uValueDictionary| ::saveFieldsToRecord( cKeyDictionary, uValueDictionary, workArea, hDictionary ) } )
   end if 

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD saveFieldsToRecord( cKeyDictionary, uValueDictionary, workArea, hDictionary ) CLASS D

   local cField

   cField   := ::getFieldFromDictionary( cKeyDictionary, hDictionary )
   if !empty( cField )
      ( workArea )->( fieldput( ( workArea )->( fieldPos( cField ) ), uValueDictionary ) )
   end if

RETURN ( nil )

//---------------------------------------------------------------------------//

METHOD getFieldFromDictionary( cKeyDictionary, hDictionary ) CLASS D

   local nScan
   local cField

   nScan       := hScan( hDictionary, {|k,v,i| k == cKeyDictionary } )   
   if nScan != 0 
      cField   := hgetValueAt( hDictionary, nScan )
   end if 

Return ( cField )

//---------------------------------------------------------------------------//

METHOD setDefaultValue( hash, cDataTable, nView ) CLASS D

   local workArea
   local aDefaultValue

   if !isHash( hash )
      Return .f.
   end if

   workArea          := ::Get( cDataTable, nView )   
   aDefaultValue     := TDataCenter():getDefaultValue( cDataTable )

   hEval( aDefaultValue, {|key, value, nView| hSet( hash, key, Eval( Value, nView ) ) } )

RETURN ( hash )

//---------------------------------------------------------------------------//

METHOD getHashTiposIncidencias( nView ) CLASS D

   if !empty( ::hashTiposIncidencias )
      Return ( ::hashTiposIncidencias )
   end if 

   ( ::TiposIncidencias( nView ) )->( dbgotop() )
   while !( ::TiposIncidencias( nView ) )->( eof() )
      hSet( ::hashTiposIncidencias, ::TiposIncidenciasNombre( nView ), ::TiposIncidenciasId( nView ) )
      ( ::TiposIncidencias( nView ) )->( dbskip() )
   end while

RETURN ( ::hashTiposIncidencias )

//---------------------------------------------------------------------------//

METHOD getTiposIncicencias( nView ) CLASS D

RETURN ( hGetKeys( ::getHashTiposIncidencias( nView ) ) )

//---------------------------------------------------------------------------//

METHOD getCodigoTipoIncicencias( cNombreIncidencia, nView ) CLASS D

   local cCodigo              := ""
   local hashTiposIncidencias := ::getHashTiposIncidencias( nView )

   if hHasKey( hashTiposIncidencias, cNombreIncidencia )
      cCodigo                 := hGet( hashTiposIncidencias, cNombreIncidencia )   
   end if 

RETURN ( cCodigo )

//---------------------------------------------------------------------------//

METHOD getNombreTipoIncicencias( cCodigoIncidencia, nView ) CLASS D

   local nScan
   local cNombreIncidencia    := ""
   local hashTiposIncidencias := ::getHashTiposIncidencias( nView )

   nScan                      := hScan( hashTiposIncidencias, {|k,v,i| v == cCodigoIncidencia } )   
   if nScan != 0 
      cNombreIncidencia       := hGetKeyAt( hashTiposIncidencias, nScan )
   end if 

RETURN ( cNombreIncidencia )

//---------------------------------------------------------------------------//

METHOD deleteRecord( cDataTable, nView ) CLASS D

   local nNext
   local nRecord           
   local lDelete     := .f.
   local workArea    := ::Get( cDataTable, nView )   

   if empty( workArea )
      return ( lDelete )
   end if

   nRecord           := ( workArea )->( ordKeyNo() )
   ( workArea )->( dbSkip() )
   nNext             := ( workArea )->( ordKeyNo() )
   ( workArea )->( ordKeyGoTo( nRecord ) )
      
   if ( workArea )->( dbrlock() )
      ( workArea )->( dbDelete() )
      ( workArea )->( dbUnLock() )
      lDelete        := .t.
   end if 

   if lDelete
      ( workArea )->( ordKeyGoTo( nRecord ) )
      if ( ( workArea )->( eof() ) .or. nNext == nRecord )
         ( workArea )->( dbGoBottom() )
      end if
   end if 

RETURN ( lDelete )

//---------------------------------------------------------------------------//

METHOD getArticuloTablaPropiedades( id, nView ) CLASS D

   local n
   local nRow                    := 1
   local nCol                    := 1
   local nTotalRow               := 0
   local nTotalCol               := 0
   local aPropertiesTable        := {}
   local hValorPropiedad
   local idPrimeraPropiedad
   local idSegundaPropiedad

   local aPropiedadesArticulo1   
   local aPropiedadesArticulo2   

   if !::gotoArticulos( id, nView )
      Return ( aPropertiesTable )
   end if 
      
   idPrimeraPropiedad            := ( D():Articulos( nView ) )->cCodPrp1
   idSegundaPropiedad            := ( D():Articulos( nView ) )->cCodPrp2

   aPropiedadesArticulo1         := aPropiedadesArticulo1( id, nView ) 
   nTotalRow                     := len( aPropiedadesArticulo1 )
   if nTotalRow != 0
      aPropiedadesArticulo2      := aPropiedadesArticulo2( id, nView ) 
   else 
      aPropiedadesArticulo1      := aPropiedadesGeneral( idPrimeraPropiedad, nView )
      nTotalRow                  := len( aPropiedadesArticulo1 )
      if nTotalRow != 0
         aPropiedadesArticulo2   := aPropiedadesGeneral( idSegundaPropiedad, nView )
      else
         Return nil
      end if 
   end if

   // Montamos los array con las propiedades-----------------------------------

   if len( aPropiedadesArticulo2 ) == 0
      nTotalCol                  := 2
   else
      nTotalCol                  := len( aPropiedadesArticulo2 ) + 1
   end if

   aPropertiesTable              := array( nTotalRow, nTotalCol )

   for each hValorPropiedad in aPropiedadesArticulo1

      aPropertiesTable[ nRow, nCol ]                        := TPropertiesItems():New()
      aPropertiesTable[ nRow, nCol ]:cCodigo                := id
      aPropertiesTable[ nRow, nCol ]:cHead                  := hValorPropiedad[ "TipoPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:cText                  := hValorPropiedad[ "CabeceraPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:cCodigoPropiedad1      := hValorPropiedad[ "CodigoPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:cValorPropiedad1       := hValorPropiedad[ "ValorPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:lColor                 := hValorPropiedad[ "ColorPropiedad" ]
      aPropertiesTable[ nRow, nCol ]:nRgb                   := hValorPropiedad[ "RgbPropiedad" ]

      nRow++

   next

   if !empty( idSegundaPropiedad ) .and. !empty( aPropiedadesArticulo2 )

      for each hValorPropiedad in aPropiedadesArticulo2

         nCol++

         for n := 1 to nTotalRow
            aPropertiesTable[ n, nCol ]                     := TPropertiesItems():New()
            aPropertiesTable[ n, nCol ]:Value               := 0
            aPropertiesTable[ n, nCol ]:cCodigo             := id
            aPropertiesTable[ n, nCol ]:cHead               := hValorPropiedad[ "CabeceraPropiedad" ]
            aPropertiesTable[ n, nCol ]:cCodigoPropiedad1   := aPropertiesTable[ n, 1 ]:cCodigoPropiedad1
            aPropertiesTable[ n, nCol ]:cValorPropiedad1    := aPropertiesTable[ n, 1 ]:cValorPropiedad1
            aPropertiesTable[ n, nCol ]:cCodigoPropiedad2   := hValorPropiedad[ "CodigoPropiedad" ]
            aPropertiesTable[ n, nCol ]:cValorPropiedad2    := hValorPropiedad[ "ValorPropiedad" ]
            aPropertiesTable[ n, nCol ]:lColor              := aPropertiesTable[ n, 1 ]:lColor
            aPropertiesTable[ n, nCol ]:nRgb                := aPropertiesTable[ n, 1 ]:nRgb
         next

      next

   else

      nCol++

      for n := 1 to nTotalRow
         aPropertiesTable[ n, nCol ]                        := TPropertiesItems():New()
         aPropertiesTable[ n, nCol ]:Value                  := 0
         aPropertiesTable[ n, nCol ]:cHead                  := "Unidades"
         aPropertiesTable[ n, nCol ]:cCodigo                := id
         aPropertiesTable[ n, nCol ]:cCodigoPropiedad1      := aPropertiesTable[ n, 1 ]:cCodigoPropiedad1
         aPropertiesTable[ n, nCol ]:cValorPropiedad1       := aPropertiesTable[ n, 1 ]:cValorPropiedad1
         aPropertiesTable[ n, nCol ]:cCodigoPropiedad2      := Space( 20 )
         aPropertiesTable[ n, nCol ]:cValorPropiedad2       := Space( 40 )
         aPropertiesTable[ n, nCol ]:lColor                 := aPropertiesTable[ n, 1 ]:lColor
         aPropertiesTable[ n, nCol ]:nRgb                   := aPropertiesTable[ n, 1 ]:nRgb
      next

   end if

Return ( aPropertiesTable )

//---------------------------------------------------------------------------//

METHOD setArticuloTablaPropiedades( id, idCodigoPrimeraPropiedad, idCodigoSegundaPropiedad, idValorPrimeraPropiedad, idValorSegundaPropiedad, nUnidades, aPropertiesTable )

   local oColumn
   local aProperty

   for each aProperty in aPropertiesTable

      for each oColumn in aProperty

         if rtrim( oColumn:cCodigo )            == rtrim( id ) .and. ;
            rtrim( oColumn:cCodigoPropiedad1 )  == rtrim( idCodigoPrimeraPropiedad ) .and. ;
            rtrim( oColumn:cCodigoPropiedad2 )  == rtrim( idCodigoSegundaPropiedad ) .and. ;
            rtrim( oColumn:cValorPropiedad1 )   == rtrim( idValorPrimeraPropiedad ) .and. ;
            rtrim( oColumn:cValorPropiedad2 )   == rtrim( idValorSegundaPropiedad )

            oColumn:Value  := nUnidades

         end if
   
      next
   
   next 

Return ( .t. )

//---------------------------------------------------------------------------//


