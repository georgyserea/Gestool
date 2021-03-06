
#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentHeader FROM DocumentBase

   METHOD newBuildDictionary( oSender )

   METHOD getDate()                                            INLINE ( ::getValue( "Fecha" ) )
   METHOD setDate( value )                                     INLINE ( ::setValue( "Fecha", value ) )

   METHOD getClient()                                          INLINE ( ::getValue( "Cliente" ) )
   METHOD setClient( value )                                   INLINE ( ::setValue( "Cliente", value ) )

   METHOD getClientName()                                      INLINE ( ::getValue( "NombreCliente" ) )
   METHOD setClientName( value )                               INLINE ( ::setValue( "NombreCliente", value ) )

END CLASS

//---------------------------------------------------------------------------//

METHOD newBuildDictionary( oSender ) CLASS DocumentHeader

   ::new( oSender )

   ::setDictionary( D():getHashFromAlias( oSender:getHeaderAlias(), oSender:getHeaderDictionary() ) )

Return ( Self )

//---------------------------------------------------------------------------//

CLASS AliasDocumentHeader FROM DocumentHeader

   METHOD getAlias()                                           INLINE ( ::oSender:getHeaderAlias() )
   METHOD getDictionary()                                      INLINE ( ::oSender:getHeaderDictionary() )

   METHOD getValue( key, uDefault )                            INLINE ( D():getFieldFromAliasDictionary( key, ::getAlias(), ::getDictionary(), uDefault ) )
   METHOD setValue( key, value )                               INLINE ( hSet( ::hDictionary, key, value ) )

END CLASS

//---------------------------------------------------------------------------//

