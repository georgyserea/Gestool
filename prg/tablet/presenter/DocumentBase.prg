
#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS repositoryBase

   DATA hDictionary

   METHOD getValue( key, uDefault )                            VIRTUAL
   METHOD setValue( key, value )                               VIRTUAL

END CLASS

//---------------------------------------------------------------------------//

CLASS repositoryDictionary FROM repositoryBase
 
   METHOD getValue( key, uDefault )                            INLINE ( hGetDefault( ::hDictionary, key, uDefault ) )
   METHOD setValue( key, value )                               INLINE ( hSet( ::hDictionary, key, value ) )

END CLASS

//---------------------------------------------------------------------------//

CLASS repositoryAlias FROM repositoryBase

   METHOD getAlias()                                           VIRTUAL
   METHOD getDictionary()                                      VIRTUAL

   METHOD getValue( key, uDefault )                            INLINE ( D():getFieldFromAliasDictionary( key, ::getAlias(), ::getDictionary(), uDefault ) )
   METHOD setValue( key, value )                               INLINE ( hSet( ::hDictionary, key, value ) )

END CLASS

//---------------------------------------------------------------------------//

CLASS DocumentBase 

   DATA oSender
   DATA hDictionary

   DATA select                                                 INIT .f.

   METHOD new()
   METHOD newBuildDictionary( oSender )
   METHOD newFromDictionary()

   METHOD getView()                                            INLINE ( ::oSender:getView() )

   METHOD getDictionary()                                      INLINE ( ::hDictionary )
   METHOD setDictionary( hDictionary )                         INLINE ( ::hDictionary := hDictionary )

   METHOD getValue( key, uDefault )                            INLINE ( hGetDefault( ::hDictionary, key, uDefault ) )
   METHOD setValue( key, value )                               INLINE ( hSet( ::hDictionary, key, value ) )

   METHOD setValueFromDictionary( hDictionary, cKey )          INLINE ( if( hHaskey( hDictionary, cKey ), ::setValue( cKey, hGet( hDictionary, cKey ) ), ) )

   METHOD selectLine()                                         INLINE ( ::select := .t. )                           
   METHOD unSelectLine()                                       INLINE ( ::select := .f. )                           
   METHOD toogleSelectLine()                                   INLINE ( ::select := !::select )                           
   METHOD isSelectLine()                                       INLINE ( ::select )

   METHOD getSerie()                                           INLINE ( ::getValue( "Serie" ) )
   METHOD setSerie( value )                                    INLINE ( ::setValue( "Serie", value ) )
   METHOD getNumero()                                          INLINE ( ::getValue( "Numero" ) )
   METHOD setNumero( value )                                   INLINE ( ::setValue( "Numero", value ) )
   METHOD getSufijo()                                          INLINE ( ::getValue( "Sufijo" ) )
   METHOD setSufijo( value )                                   INLINE ( ::setValue( "Sufijo", value ) )

   METHOD getDocumentId()                                      INLINE ( ::getValue( "Serie" ) + str( ::getValue( "Numero" ) ) + ::getValue( "Sufijo" ) )
   METHOD getNumeroDocumento()                                 INLINE ( ::getValue( "Serie" ) + alltrim( str( ::getValue( "Numero" ) ) ) )

   METHOD getDivisa()                                          INLINE ( ::getValue( "Divisa" ) ) 

   METHOD getStore()                                           INLINE ( ::getValue( "Almacen" ) )
   METHOD setStore( cStore )                                   INLINE ( ::setValue( "Almacen", cStore ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD new( oSender ) CLASS DocumentBase

   ::oSender            := oSender

Return ( Self )

//---------------------------------------------------------------------------//

METHOD newBuildDictionary( oSender ) CLASS DocumentBase

   ::new( oSender )

   ::setDictionary( D():getHashFromAlias( oSender:getLineAlias(), oSender:getLineDictionary() ) )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD newFromDictionary( oSender, hDictionary ) CLASS DocumentBase

   ::new( oSender )

   ::setDictionary( hDictionary )

Return ( Self )

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

CLASS AliasDocumentBase FROM DocumentBase

   DATA cAlias
   
   METHOD getAlias()                                           VIRTUAL
   METHOD getDictionary()                                      VIRTUAL

   METHOD getValue( key, uDefault )                            INLINE ( D():getFieldFromAliasDictionary( key, ::getAlias(), ::getDictionary(), uDefault ) )
   METHOD setValue( key, value )                               INLINE ( hSet( ::hDictionary, key, value ) )

   METHOD getRecno()                                           INLINE ( ( ::getAlias() )->( recno() ) )
   METHOD eof()                                                INLINE ( ( ::getAlias() )->( eof() ) )

   METHOD setLinesScope( id )                                  INLINE ( ( ::getAlias() )->( ordscope( 0, id ) ),;
                                                                        ( ::getAlias() )->( ordscope( 1, id ) ),;
                                                                        ( ::getAlias() )->( dbgotop() ) ) 
   METHOD quitLinesScope()                                     INLINE ( ::setLinesScope( nil ) )

END CLASS

//---------------------------------------------------------------------------//

