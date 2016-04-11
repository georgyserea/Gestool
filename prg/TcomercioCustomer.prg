#include "FiveWin.Ch" 
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch" 

//---------------------------------------------------------------------------//

CLASS TComercioCustomer

   DATA  TComercio

   DATA  idCustomerGestool
   
   METHOD New( TComercio )                                  CONSTRUCTOR

   METHOD isCustomerInGestool( idCustomer )
   METHOD isAddressInGestool( idAddress )                   INLINE ( !empty( ::TPrestashopId():getGestoolAddress( idAddress, ::getCurrentWebName() ) ) )
  
   METHOD insertCustomerInGestoolIfNotExist( idCustomer ) 

   METHOD createCustomerInGestool()    
   METHOD getCustomerFromPrestashop()
      METHOD appendCustomerInGestool()

   METHOD createAddressInGestool()    
   METHOD getAddressFromPrestashop()
      METHOD appendAddressInGestool()

   METHOD getState( idState ) 
   METHOD getPaymentGestool( module ) 

   // facades------------------------------------------------------------------

   METHOD TPrestashopId()                                   INLINE ( ::TComercio:TPrestashopId )
   METHOD TPrestashopConfig()                               INLINE ( ::TComercio:TPrestashopConfig )
   METHOD getCurrentWebName()                               INLINE ( ::TComercio:getCurrentWebName() )

   METHOD writeText( cText )                                INLINE ( ::TComercio:writeText( cText ) )

   METHOD oCustomerDatabase()                               INLINE ( ::TComercio:oCli )
   METHOD oAddressDatabase()                                INLINE ( ::TComercio:oObras )
   METHOD oAddressDatabase()                                INLINE ( ::TComercio:oObras )
   METHOD oPaymentDatabase()                                INLINE ( ::TComercio:oFPago )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( TComercio ) CLASS TComercioCustomer

   ::TComercio          := TComercio

Return ( Self )

//---------------------------------------------------------------------------//

METHOD isCustomerInGestool( idCustomer ) CLASS TComercioCustomer

   ::idCustomerGestool  := ::TPrestashopId():getGestoolCustomer( idCustomer, ::getCurrentWebName(), "" )

Return ( !empty( ::idCustomerGestool ) )

//---------------------------------------------------------------------------//

METHOD insertCustomerInGestoolIfNotExist( idCustomer, idAddressDelivery ) CLASS TComercioCustomer

   if !( ::isCustomerInGestool( idCustomer ) )
      ::createCustomerInGestool( idCustomer )
   end if 

   if !( ::isAddressInGestool( idAddressDelivery ) )
      ::createAddressInGestool( idAddressDelivery )
   end if 

Return ( Self )

//---------------------------------------------------------------------------//

METHOD createCustomerInGestool( idCustomer ) CLASS TComercioCustomer

   local oQuery   := ::getCustomerFromPrestashop( idCustomer )

   if empty( oQuery )
      Return ( Self )
   end if 

   if oQuery:recCount() > 0 
      ::appendCustomerInGestool( idCustomer, oQuery )
   end if 

   oQuery:Free()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getCustomerFromPrestashop( idCustomer ) CLASS TComercioCustomer

   local cQuery
   local oQuery 

   cQuery            := "SELECT * FROM " + ::TComercio:cPrefixTable( "customer" ) + " " + ;
                        "WHERE id_customer = " + alltrim( str( idCustomer ) ) 

   oQuery            := TMSQuery():New( ::TComercio:oCon, cQuery )

   if oQuery:Open() 
      Return ( oQuery )   
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD appendCustomerInGestool( oQuery ) CLASS TComercioCustomer

   ::idCustomerGestool              := nextkey( dbLast( ::oCustomerDatabase(), 1 ), ::oCustomerDatabase():cAlias, "0", retnumcodcliemp() )

   ::oCustomerDatabase():Append()
   ::oCustomerDatabase():Cod        := ::idCustomerGestool
   
   if ::TPrestashopConfig():isInvertedNameFormat()
      ::oCustomerDatabase():Titulo  := upper( oQuery:fieldGetbyName( "lastname" ) ) + ", " + upper( oQuery:fieldGetByName( "firstname" ) ) // Last Name - firstname
   else   
      ::oCustomerDatabase():Titulo  := upper( oQuery:fieldGetbyName( "firstname" ) ) + space( 1 ) + upper( oQuery:fieldGetByName( "lastname" ) ) //firstname - Last Name
   end if   
   
   ::oCustomerDatabase():nTipCli    := 3
   ::oCustomerDatabase():CopiasF    := 1
   ::oCustomerDatabase():Serie      := ::TPrestashopConfig():getOrderSerie()
   ::oCustomerDatabase():nRegIva    := 1
   ::oCustomerDatabase():nTarifa    := 1
   ::oCustomerDatabase():cMeiInt    := oQuery:fieldGetByName( "email" ) //email
   ::oCustomerDatabase():lChgPre    := .t.
   ::oCustomerDatabase():lSndInt    := .t.
   ::oCustomerDatabase():CodPago    := ::getPaymentGestool( oQuery:FieldGetByName( "module" ) )
   ::oCustomerDatabase():cCodAlm    := ::TPrestashopConfig():getStore()
   ::oCustomerDatabase():dFecChg    := GetSysDate()
   ::oCustomerDatabase():cTimChg    := Time()
   ::oCustomerDatabase():lWeb       := .t.

   if ::oCustomerDatabase():Save()

      ::TPrestashopId():setValueCustomer( ::idCustomerGestool, ::getCurrentWebName(), oQuery:fieldGet( 1 ) ) 

      ::writeText( "Cliente " + alltrim( oQuery:fieldGetByName( "ape" ) ) + Space( 1 ) + alltrim( oQuery:fieldGetByName( "firstname" ) ) + " introducido correctamente.", 3 )

   else
      
      ::writeText( "Error al guardar el cliente en gestool : " + alltrim( oQuery:fieldGetByName( "ape" ) ) + Space( 1 ) + alltrim( oQuery:fieldGetByName( "firstname" ) ), 3 )

      Return ( .f. )

   end if

Return ( .t. )

//---------------------------------------------------------------------------//
 
METHOD createAddressInGestool( idAddress ) CLASS TComercioCustomer

   local oQuery 

   oQuery      := ::getAddressFromPrestashop( idAddress )

   if empty( oQuery ) 
      Return ( Self )
   end if 

   if oQuery:recCount() > 0 
      ::appendAddressInGestool( idAddress, oQuery )
   end if 

   oQuery:Free()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD getAddressFromPrestashop( idAddress ) CLASS TComercioCustomer

   local cQuery
   local oQuery 

   cQuery            := "SELECT * FROM " + ::TComercio:cPrefixTable( "address" ) + " WHERE id_address = " + alltrim( str( idAddress ) ) 
   oQuery            := TMSQuery():New( ::TComercio:oCon, cQuery )

   if oQuery:Open() 
      Return ( oQuery )   
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD appendAddressInGestool( idAddress, oQuery ) CLASS TComercioCustomer

   local idAddressGestool        := "@" + alltrim( str( oQuery:fieldGet( 1 ) ) ) 
   local nameAddressGestool      := upper( oQuery:fieldGetbyName( "firstname" ) ) + space( 1 ) + upper( oQuery:fieldGetByName( "lastname" ) ) 

   ::TComercio:oObras:Append()
   ::TComercio:oObras:Blank()

   ::TComercio:oObras:cCodCli        := ::TComercio:CodigoClienteinGestool( idCustomer )
   ::TComercio:oObras:cCodObr        := "@" + alltrim( str( oQuery:fieldGet( 1 ) ) ) //"id_address"
   ::TComercio:oObras:cNomObr        := upper( oQuery:FieldGetbyName( "firstname" ) ) + Space( 1 ) + upper( oQuery:FieldGetByName( "lastname" ) ) //firstname - Last Name
   ::TComercio:oObras:cDirObr        := oQuery:FieldGetByName( "address1" ) + " " + oQuery:FieldGetByName( "address2" ) //"address1" - "address2"
   ::TComercio:oObras:cPobObr        := oQuery:FieldGetByName( "city" ) //"city"
   ::TComercio:oObras:cPosObr        := oQuery:FieldGetByName( "postcode" ) //"postcode"
   ::TComercio:oObras:cPrvObr        := ::getState(oQuery:fieldGetbyName( "id_state" ) )
   ::TComercio:oObras:cTelObr        := oQuery:FieldGetByName( "phone" ) //"phone"
   ::TComercio:oObras:cMovObr        := oQuery:FieldGetByName( "phone_mobile" ) //"phone_mobile"
   ::TComercio:oObras:cCodWeb        := oQuery:FieldGet( 1 ) //"id_address"

   ::TComercio:oObras:Save()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD getState( idState ) CLASS TComercioCustomer
             
   local cQuery
   local oQuery
   local cState      := ""

   cQuery            := "SELECT * FROM " + ::TComercio:cPrefixTable( "state" ) + " WHERE id_state = " + alltrim( str( idState ) )
   oQuery            := TMSQuery():New( ::TComercio:oCon, cQuery )

   if oQuery:Open() .and. oQuery:RecCount() > 0
      cState         := oQuery:fieldGetbyName( "name" )
      oQuery:free()
   end if   

Return ( cState )

//---------------------------------------------------------------------------//

METHOD getPaymentGestool( cPrestashopModule ) CLASS TComercioCustomer

   local paymentGestool    := cDefFpg()

   if ::oPaymentDatabase():seekInOrd( upper( cPrestashopModule ), "cCodWeb" )
      paymentGestool       := ::oPaymentDatabase():cCodPago 
   end if 

Return ( paymentGestool )

//---------------------------------------------------------------------------//
