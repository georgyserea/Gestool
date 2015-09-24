#include "HbXml.ch"
#include "TDbfDbf.ch"
#include "FiveWin.Ch"
#include "Struct.ch"
#include "Factu.ch" 
#include "Ini.ch"
#include "MesDbf.ch"
#include "Report.ch"
#include "Print.ch"

#define __localDirectory            "c:\EdiversaEDI\"
#define __localDirectoryPorcessed   "c:\Bestseller\Processed\"
#define __timeWait                  1

//---------------------------------------------------------------------------//

Function ImportarEDI( nView )

   ImportarPedidosClientesEDI():Run( nView )

Return ( nil )

//---------------------------------------------------------------------------//

CLASS ImportarPedidosClientesEDI

   DATA nView

   DATA aEDIFiles

   DATA oFileEDI

   DATA aTokens

   DATA hDocument
   DATA hLine

   DATA hPedidoCabecera
   DATA hPedidoLinea

   DATA ordTipo                              INIT  {  '220' => 'Pedido normal',;
                                                      '22E' => 'Propuesta de pedido',;
                                                      '221' => 'Pedido abierto',;
                                                      '224' => 'Pedido urgente',;
                                                      '226' => 'Pedido parcial que cancela un pedido abierto',;
                                                      '227' => 'Pedido consignaci�n',;
                                                      'YB1' => 'Pedido cross dock' }

   DATA ordFuncion                           INIT  {  '9'   => 'Original',;
                                                      '3'   => 'Cancelaci�n',;
                                                      '5'   => 'Sustituci�n',;
                                                      '6'   => 'Confirmaci�n',;
                                                      '7'   => 'Duplicado',;
                                                      '16'  => 'Propuesta',;
                                                      '31'  => 'Copia',;
                                                      '46'  => 'Provisional' }

   DATA calificadorCodigo                    INIT  {  'SA'  => 'C�digo de art�culo interno del proveedor ',;
                                                      'IN'  => 'codigoInternoComprador',;
                                                      'BP'  => 'C�digo interno del comprador ',;
                                                      'SN'  => 'N�mero de serie ',;
                                                      'NS'  => 'N�mero de lote',;
                                                      'ADU' => 'C�digo de la unidad de embalaje ',;
                                                      'MN'  => 'Identificaci�n interna del modelo del fabricante ',;
                                                      'DW'  => 'Identificaci�n interna del proveedor para el dibujo ',;
                                                      'PV'  => 'Variable promocional',;
                                                      'EN'  => 'N�mero EAN de la unidad de expedici�n',;
                                                      'GB'  => 'C�digo de grupo de producto interno ',;
                                                      'CNA' => 'C�digo nacional',;
                                                      'AT'  => 'numeroBusquedaPrecio' }

   DATA calificadorDescripcion               INIT  {  'F'   => 'descripcionTextoLibre',;
                                                      'C'   => 'Descripci�n codificada',;
                                                      'E'   => 'Descripci�n corta ECI',;
                                                      'B'   => 'C�digo y texto' }

   DATA calificadorCantidad                  INIT  {  '21'  => 'unidadesPedidas',;
                                                      '59'  => 'N�mero de unidades de consumo en la unidad de expedici�n',;
                                                      '15E' => 'Cantidad de mercanc�a sin cargo',;
                                                      '61'  => 'Cantidad devuelta',;
                                                      '17E' => 'Unidades a nivel de subembalaje',;
                                                      '192' => 'Cantidad gratuita incluida TRU',;
                                                      '1'   => 'Cantidad solicitada para bonificaci�n' }

   DATA calificadorPrecios                   INIT  {  'AAA' => 'precioNetoUnitario',;
                                                      'AAB' => 'Precio bruto unitario',;
                                                      'INF' => 'Precio a t�tulo informativo',;
                                                      'NTP' => 'Precio neto' }

   METHOD Run( nView )
   
   METHOD labelToken()                       INLINE ( ::aTokens[ 1 ] )
   METHOD say()                              INLINE ( hb_valtoexp( ::hDocument ) )
   
   METHOD proccessEDIFiles( cEDIFiles )
   METHOD proccessEDILine()
   METHOD proccessEDITokens( aTokens )
      METHOD proccessORD()
      METHOD proccessDTM()
      METHOD proccessNADMS()                 INLINE ( ::hDocument[ "emisor" ]    := ::getField( 1 ) )
      METHOD proccessNADMR()                 INLINE ( ::hDocument[ "receptor" ]  := ::getField( 1 ) )
      METHOD proccessNADSU()
      METHOD proccessNADBY()     
      METHOD proccessNADDP()         
      METHOD proccessNADIV()
      METHOD proccessLIN()
      METHOD proccessPIALIN()
      METHOD proccessIMDLIN()
      METHOD proccessQTYLIN()
      METHOD proccessPRILIN()
      METHOD proccessLOCLIN()
      METHOD proccessTAXLIN()                INLINE ( if( !empty( ::hLine ), ::hLine[ "porcentajeImpuesto" ]  := ::getNum( 2 ), ) )
      METHOD proccessCNTRES()                

   METHOD insertLineInDcoument()

   METHOD getField( nPosition )              INLINE ( if( len( ::aTokens ) >= nPosition + 1, ::aTokens[ nPosition + 1 ], "" ) )
   METHOD getFieldTable( nPosition, hTable ) INLINE ( hget( hTable, ::getField( nPosition ) ) )
   METHOD getDate( nPosition )               INLINE ( stod( ::getField( nPosition ) ) )
   METHOD getNum( nPosition )                INLINE ( val( ::getField( nPosition ) ) )

   METHOD isbuildPedidoCliente()
   METHOD buildPedidoCliente()
   METHOD isDocumentImported()

   METHOD isClient()

   METHOD CodigoClient()

   METHOD buildPedido()

   METHOD buildCabecera()

ENDCLASS

//---------------------------------------------------------------------------//

METHOD Run( nView ) CLASS ImportarPedidosClientesEDI 

   local aEDIFile

   ::nView           := nView

   ::aEDIFiles       := Directory( __localDirectory + "*.pla" )

   if !empty( ::aEDIFiles )
      for each aEDIFile in ::aEDIFiles
         ::ProccessEDIFiles( aEDIFile[ 1 ] )
         ::buildPedidoCliente()
      next
   else
      msgStop( "No hay ficheros en el directorio")
   end if 

   msgStop( ::say(), "proceso finalizado" )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessEDIFiles( cEDIFile )

   if !file( __localDirectory + cEDIFile )
      msgStop( __localDirectory + cEDIFile, "Fichero no existe" )
      Return .f.
   end if 

   ::hDocument          := {=>}
   ::oFileEDI           := TTxtFile():New( __localDirectory + cEDIFile )

   while ! ::oFileEDI:lEoF()
      ::proccessEDILine()
      ::oFileEDI:Skip()
   end while

   ::oFileEDI:Close()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessEDILine()

   ::aTokens              := hb_atokens( ::oFileEDI:cLine, "|" )

   if valtype( ::aTokens ) != "A" .or. len( ::aTokens ) <= 1
      Return ( nil )
   end if 

   ::proccessEDITokens()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessEDITokens()

   do case
      case ::labelToken() == "ORD"     ;  ::proccessORD()

      case ::labelToken() == "DTM"     ;  ::proccessDTM()
      
      case ::labelToken() == "NADMS"   ;  ::proccessNADMS()
      
      case ::labelToken() == "NADMR"   ;  ::proccessNADMR()

      case ::labelToken() == "NADSU"   ;  ::proccessNADSU()

      case ::labelToken() == "NADBY"   ;  ::proccessNADBY()

      case ::labelToken() == "NADDP"   ;  ::proccessNADDP()

      case ::labelToken() == "NADIV"   ;  ::proccessNADIV()

      case ::labelToken() == "LIN"     ;  ::proccessLIN()

      case ::labelToken() == "PIALIN"  ;  ::proccessPIALIN()

      case ::labelToken() == "IMDLIN"  ;  ::proccessIMDLIN()

      case ::labelToken() == "QTYLIN"  ;  ::proccessQTYLIN()

      case ::labelToken() == "LOCLIN"  ;  ::proccessLOCLIN()

      case ::labelToken() == "TAXLIN"  ;  ::proccessTAXLIN()

      case ::labelToken() == "CNTRES"  ;  ::proccessCNTRES()

   end case

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessORD()

   ::hDocument[ "documentoOrigen" ]    := ::getField( 1 )
   ::hDocument[ "tipo" ]               := ::getFieldTable( 2, ::ordTipo )
   ::hDocument[ "funcion" ]            := ::getFieldTable( 3, ::ordFuncion )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessDTM()

   ::hDocument[ "documento" ]    := ::getDate( 1 )
   ::hDocument[ "entrega" ]      := ::getDate( 2 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessNADSU()

   ::hDocument[ "proveedor" ]    := ::getField( 1 )
   ::hDocument[ "codprov" ]      := ::getField( 2 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessNADBY()

   ::hDocument[ "comprador" ]    := ::getField( 1 )
   ::hDocument[ "departamento" ] := ::getField( 2 )
   ::hDocument[ "reposicion" ]   := ::getField( 3 )
   ::hDocument[ "sucursal" ]     := ::getField( 4 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessNADDP()

   ::hDocument[ "almacen" ]      := ::getField( 1 )
   ::hDocument[ "puerta" ]       := ::getField( 2 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessNADIV()

   ::hDocument[ "receptorFactura" ]        := ::getField( 1 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD insertLineInDcoument()

   if !empty(::hLine)

      if !hhaskey( ::hDocument, "lineas" )
         ::hDocument[ "lineas" ]       := {}         
      end if 

      aadd( ::hDocument[ "lineas" ], ::hLine )

   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessLIN()

   ::hLine                       := {=>}

   ::hLine[ "codigo" ]           := ::getField( 1 )
   ::hLine[ "tipoCodigo" ]       := ::getField( 2 )
   ::hLine[ "linea" ]            := ::getNum( 3 )

   ::insertLineInDcoument()

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessPIALIN()

   local calificadorCodigo
   local referenciaArticulo      

   if empty( ::hLine )
      Return ( nil )
   end if 

   calificadorCodigo                  := ::getFieldTable( 1, ::calificadorCodigo )
   referenciaArticulo                 := ::getField( 2 )

   if !empty(calificadorCodigo) .and. !empty(referenciaArticulo)
      ::hLine[ calificadorCodigo ]    := referenciaArticulo
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessIMDLIN()

   local calificadorDescripcion
   local descripcionArticulo      

   if empty( ::hLine )
      Return ( nil )
   end if 

   calificadorDescripcion                 := ::getFieldTable( 1, ::calificadorDescripcion )
   descripcionArticulo                    := ::getNum( 2 )

   if !empty(calificadorDescripcion) .and. !empty(descripcionArticulo)
      ::hLine[ calificadorDescripcion ]  := descripcionArticulo
   end if 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessQTYLIN()

   local calificadorCantidad
   local cantidadArticulo      

   if empty( ::hLine )
      Return ( nil )
   end if 

   calificadorCantidad                 := ::getFieldTable( 1, ::calificadorCantidad )
   cantidadArticulo                    := ::getNum( 2 )

   if !empty(calificadorCantidad) .and. !empty(cantidadArticulo)
      ::hLine[ calificadorCantidad ]   := cantidadArticulo
   end if 

   ::hLine[ "unidadMedicion" ]         := ::getField( 3 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessPRILIN() 

   local calificadorPrecios
   local cantidadArticulo      

   if empty( ::hLine )
      Return ( nil )
   end if 

   calificadorPrecios                  := ::getFieldTable( 1, ::calificadorPrecios )
   cantidadArticulo                    := ::getNum( 2 )

   if !empty(calificadorPrecios) .and. !empty(cantidadArticulo)
      ::hLine[ calificadorPrecios ]    := cantidadArticulo
   end if 

   ::hLine[ "precioVenta" ]            := ::getField( 3 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessLOCLIN() 

   if empty( ::hLine )
      Return ( nil )
   end if 

   ::hLine[ "puntoEntrega" ]           := ::getField( 1 )
   ::hLine[ "unidadesEntrega" ]        := ::getField( 3 )

Return ( nil )

//---------------------------------------------------------------------------//

METHOD proccessCNTRES()

   ::hDocument[ "numeroBultos" ]    := ::getNum( 1 ) 
   ::hDocument[ "numeroLineas" ]    := ::getNum( 4 ) 

Return ( nil )

//---------------------------------------------------------------------------//

METHOD isbuildPedidoCliente()

   if ::isDocumentImported()
      msgStop( "El documento ya ha sido importado" )
      Return ( .f. )
   end if 

   if !::isClient()
      msgStop( "Cliente no encontrado")
      Return ( .f. )
   end if 

return .t.

//-----------------------------------------------------------------------------

METHOD buildPedidoCliente()

   if ::isbuildPedidoCliente()

      MsgInfo( "Creamos el pedido de cliente" )

      ::buildPedido()

   end if 

   msgAlert( "Fin de la importaci�n")

Return ( nil )

//---------------------------------------------------------------------------//

METHOD isDocumentImported()

   local isDocumentImported   := .f.

   D():getStatusPedidosClientes( ::nView )
   D():setFocusPedidosClientes( "cSuPed", ::nView )

   isDocumentImported         := ( D():PedidosClientes( ::nView ) )->( dbseek( ::hDocument[ "documentoOrigen" ] ) )

   D():setStatusPedidosClientes( ::nView )

Return ( isDocumentImported )

//---------------------------------------------------------------------------//

METHOD isClient()

   local isClient   := .f.
 
   D():getStatusClientes( ::nView )
   D():setFocusClientes( "cCodEdi", ::nView )

   MsgInfo( ::hDocument[ "receptorFactura" ] )

   isClient         := ( D():Clientes( ::nView ) )->( dbseek( ::hDocument[ "receptorFactura" ] ) )

   D():setStatusClientes( ::nView )

Return ( isClient )

//---------------------------------------------------------------------------//

METHOD CodigoClient()

   local CodClient    := ""
 
   D():getStatusClientes( ::nView )
   D():setFocusClientes( "cCodEdi", ::nView )

   if ( D():Clientes( ::nView ) )->( dbseek( ::hDocument[ "receptorFactura" ] ) )

      CodigoClient      := ( D():Clientes( ::nView ) )->Cod

   end if

   D():setStatusClientes( ::nView )

Return ( CodigoClient )

//---------------------------------------------------------------------------//

METHOD buildPedido()

   ::buildCabecera()

   //D():appendHashPedidoCabecera( ::hPedidoCabecera, D():PedidosClientes( ::nView ), ::nView )   

Return ( nil )

//---------------------------------------------------------------------------//

METHOD buildCabecera()

   MsgInfo( "entro en el buildCabecera" )

   ::hPedidoCabecera                   := D():getPedidoClienteDefaultValue( ::nView )

   ::hPedidoCabecera[ "Serie"     ]    := "A"
   ::hPedidoCabecera[ "Numero"    ]    := nNewDoc( "A", D():PedidosClientes( ::nView ), "nPedCli", , D():Contadores( ::nView ) )
   ::hPedidoCabecera[ "Fecha"     ]    := getSysDate()
   ::hPedidoCabecera[ "Cliente"   ]    := ::CodigoClient()

   Msginfo( hb_valtoexp( ::hPedidoCabecera ), "buildCabecera" )

Return ( nil )

//---------------------------------------------------------------------------//