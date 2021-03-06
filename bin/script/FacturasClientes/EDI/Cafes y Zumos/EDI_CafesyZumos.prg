#include "Factu.ch" 
#include "FiveWin.ch"

//#define __localDirectory__       "\\Srvcafesyzumos\nueva estructura servidor\FicherosVoxel\"
#define __localDirectory__       "c:\ficheros\voxel\"
#define __separator__            ";"

//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
/*
Ejemplo Fichero de Factura
Supongamos que el establecimiento “El Pato Barcelona” de la cadena “El Pato Andaluz, S.L.”, ha realizado el siguiente pedido al proveedor “Bebidas y Refrescos, S.A.”:
- 200 botellas de agua
- 15 Kgs de naranjas
- 100 entrecots de ternera de 300 gramos cada uno
La factura correspondiente sería la siguiente (se han utilizado únicamente los segmentos y campos marcados en rojo en las especificaciones):
Nombre del fichero: Factura_20140618_100000_000.txt
Carácter de separación de campos: ‘;’
Contenidos del fichero:
DatosGenerales;F132589;FacturaComercial;2014-06-18;EUR;
Proveedor;525;B61742348;Bebidas y Refrescos,S.A.;Av. Diagonal,23;Barcelona; 08012;Barcelona;ESP
Cliente;1;1024;2;12345678Z;El Pato Andaluz, S.L.;La Toja, 53;Barcelona; 08027;Barcelona;ESP
Estab;25;1024;2;El Pato BCN;Av.Icaria,34;Barcelona;08005;Barcelona;ESP
Referencias;A534687;P459034;;2014-06-18
Detalle;50;500;Agua Castillo de Montblanc;200;Unidades;0,2;40
ImpuestosLinea;IVA;4;1,6
Detalle;60;600;Naranjas Navel;15;Kgs;;;;2;30
ImpuestosLinea;IVA;4;1,2
Detalle;70;700;Entrecot Ternera;30;Kgs;;;;10;300
ImpuestosLinea;IVA;4;12
ResumenImpuestos;IVA;4;370;14,8
Vencimientos;2014-06-30;384,8;ReciboDomiciliado
ResumenTotales;370;370;0;370;14,8;384,8
*/
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//
//---------------------------------------------------------------------------//

Function EDI_CafesyZymos( lNoExportados, oTree, nView )

   local oTEdiExporarFacturas

   oTEdiExporarFacturas          := TEdiExporarFacturas():New( lNoExportados, oTree, nView )
   oTEdiExporarFacturas:Run()

Return nil

//---------------------------------------------------------------------------//

CLASS TEdiExporarFacturas

   DATA nView

   DATA oTree

   DATA lNoExportados

   DATA cFileEDI
   DATA oFileEDI

   DATA cCodigoCliente

   DATA sTotalFactura

   DATA hAcumulaIva
   DATA nTotalIva

   METHOD New( lNoExportados, oTree, nView )
   METHOD Run()

   METHOD isFacturaProcesada()
   METHOD infoFacturaEnProceso() INLINE   ( ::oTree:Select( ::oTree:Add( "Factura : " + D():FacturasClientesIdText( ::nView ) + " en proceso.", 1 ) ) )
   METHOD infoFacturaGenerada()  INLINE   ( ::oTree:Select( ::oTree:Add( "Factura : " + D():FacturasClientesIdText( ::nView ) + " generada en el fichero " + ::cFileEDI, 1 ) ) )

   METHOD getSerlizeFileName()
   METHOD createFile()
   METHOD closeFile()            INLINE   ( ::oFileEDI:Close() )
   METHOD isFile()               INLINE   ( file( ::cFileEDI ) )

   METHOD writeDatosGenerales()
   METHOD writeDatosProveedor()
   METHOD writeDatosCliente()
   
   METHOD getDatosEstablecimiento()   
      METHOD writeDatosEstablecimiento()
      METHOD writeClienteEstablecimiento()

   METHOD writeReferencias()

   METHOD writeLineas()
      METHOD writeDetallesLinea()
      METHOD writeDescuentoLinea()
      METHOD writeImpuestosLinea()

   METHOD writeResumenPrimerImpuesto()
   METHOD writeResumenSegundoImpuesto()
   METHOD writeResumenTercerImpuesto()

   METHOD writeVencimientos()
      METHOD writeDetallesVencimientos()
   
   METHOD writeResumenTotales()

   METHOD getNumero( nNumero )   INLINE   ( alltrim( transform( nNumero, "@E 99999999999999.99" ) ) )
   METHOD getFecha( dFecha )     INLINE   ( transform( dtos( dFecha ), "@R 9999-99-99") )

   METHOD isLineaValida()        INLINE   ( lValLine( D():FacturasClientesLineas( ::nView ) ) .and. !( D():FacturasClientesLineas( ::nView ) )->lTotLin .and. nTotNFacCli() != 0 )
   METHOD isDescuentoValido()    INLINE   ( ( D():FacturasClientesLineas( ::nView ) )->nDto != 0 )

   METHOD setFacturaClienteGeneradaEDI()

   METHOD acumulaIva( nIva, nImporte )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( lNoExportados, oTree, nView )

   ::lNoExportados            := lNoExportados
   ::oTree                    := oTree
   ::nView                    := nView

   ::hAcumulaIva              := {=>}
   ::nTotalIva                := 0

Return ( self )

//---------------------------------------------------------------------------//

METHOD Run()

   local oNode

   if ::isFacturaProcesada()
      Return ( self )
   end if
   
   ::infoFacturaEnProceso()

   ::sTotalFactura         := sTotFacCli()

   ::cCodigoCliente        := ( D():FacturasClientes( ::nView ) )->cCodCli

   ::createFile()

   if ::isFile()

      ::writeDatosGenerales()
      ::writeDatosProveedor()
      ::writeDatosCliente()

      ::getDatosEstablecimiento()

      ::writeReferencias()
      
      ::writeLineas()  

      ::writeResumenPrimerImpuesto()
      ::writeResumenSegundoImpuesto()
      ::writeResumenTercerImpuesto()

      ::writeVencimientos()
      ::writeResumenTotales()

      ::closeFile()

      ::setFacturaClienteGeneradaEDI()

      ::infoFacturaGenerada()

   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD isFacturaProcesada()

   if ( D():FacturasClientes( ::nView ) )->lExpEdi .and. ::lNoExportados
      ::oTree:Select( ::oTree:Add( "Factura : " + D():FacturasClientesIdText( ::nView ) + " anteriormente generada.", 1 ) )
      Return ( .t. )
   end if

Return ( .f. )

//---------------------------------------------------------------------------//

METHOD getSerlizeFileName()

   local nSequencial := 0
   local cRootName   := __localDirectory__ + "Factura_" + dtos( date() ) + "_" + strtran( time(), ":", "" ) + "_" 
   local cFileName   := cRootName + strzero( nSequencial, 3 ) + "." + "txt"

   while file( cFileName )
      cFileName      := cRootName + strzero( ++nSequencial, 3 ) + "." + "txt"
   end while

Return ( cFileName )

//---------------------------------------------------------------------------//

METHOD createFile()

   ::cFileEDI     := ::getSerlizeFileName()
   ::oFileEDI     := TTxtFile():New( ::cFileEDI )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDatosGenerales()

   local cLine    := "DatosGenerales" + __separator__
   cLine          += D():FacturasClientesIdShort( ::nView ) + __separator__
   if ( D():FacturasClientes( ::nView ) )->nTotFac > 0
      cLine       += "FacturaComercial" + __separator__ 
   else 
      cLine       += "FacturaAbono" + __separator__
   end if 
   cLine          += ::getFecha( ( D():FacturasClientes( ::nView ) )->dFecFac ) + __separator__
   cLine          += "EUR"

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDatosProveedor()

   local cLine    := "DatosProveedor" + __separator__
   cLine          += "9990000076857" + __separator__
   cLine          += "9990000076857" + __separator__ 
   cLine          += "B91012468" + __separator__
   cLine          += "Cafés y Zumos, S.L." + __separator__
   cLine          += "Pol. Ind. El Pino C7 Pino Silvestre, 21-22" + __separator__
   cLine          += "Sevilla" + __separator__
   cLine          += "41017" + __separator__
   cLine          += "Sevilla" + __separator__
   cLine          += "España" 
   // cLine          += "Registro" + __separator__
   // cLine          += "Email"                                               

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDatosCliente()
   
    local cLine    := "DatosCliente" + __separator__                                                   

	
	//Cliente--------------------------------------------------------------

   	cLine          += "" + __separator__                                                                           // Código del cliente (interno del cliente)
   	cLine          += alltrim( ::cCodigoCliente ) + __separator__                                                  // Código del cliente (interno del proveedor)
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "cCodEdi" ) ) + __separator__    // Código de un centro del cliente (interno del proveedor). Algunos proveedores no lo utilizan (solo usan el campo DCliProv)
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Nif" ) ) + __separator__        // CIF del cliente
   		
   	if !empty( ( D():FacturasClientes( ::nView ) )->cCodObr ) .and. ( D():ClientesDirecciones( ::nView ) )->( dbseek( ::cCodigoCliente + ( D():FacturasClientes( ::nView ) )->cCodObr ) )
   		cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cNomObr ) + __separator__     // Razón social del cliente
   	else
   		cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Titulo" ) ) + __separator__     // Razón social del cliente
   	end if
   		
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Domicilio" ) ) + __separator__  // Domicilio del cliente
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Poblacion" ) ) + __separator__  // Población del cliente
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "CodPostal" ) ) + __separator__  // Codigo postal del cliente
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Provincia" ) ) + __separator__  // Provincia del cliente
   	cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "cCodPai" ) )                    // País del cliente (España: ESP)
   	cLine          += ""                                                                                           // Nº de registro mercantil del cliente
   	cLine          += ""                                                                                           // Dirección de email del cliente

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD getDatosEstablecimiento()

   if !empty( ( D():FacturasClientes( ::nView ) )->cCodObr ) .and. ( D():ClientesDirecciones( ::nView ) )->( dbseek( ::cCodigoCliente + ( D():FacturasClientes( ::nView ) )->cCodObr ) )
      ::writeDatosEstablecimiento()
   else
      ::writeClienteEstablecimiento()
   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDatosEstablecimiento()

   local cLine    := "Estab" + __separator__
   cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cCodEdi ) + __separator__    // Código del establecimiento del cliente donde se entrega de la mercancía (interno del cliente)
   cLine          += alltrim( ::cCodigoCliente ) + __separator__                                   // Código del cliente (interno del proveedor)
   cLine          += "" + __separator__                                                            // Código secundario del establecimiento del cliente según el proveedor (interno del proveedor). Algunos proveedores solo utilizan el campo IDCliProv
   //cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cNomObr ) + __separator__    // Nombre del establecimiento
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Titulo" ) ) + __separator__    // Nombre del establecimiento
   cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cDirObr ) + __separator__    // Dirección del establecimiento
   cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cPobObr ) + __separator__    // Población del establecimiento
   cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cPosObr ) + __separator__    // Código postal del establecimiento
   cLine          += alltrim( ( D():ClientesDirecciones( ::nView ) )->cPrvObr ) + __separator__    // Provincia del establecimiento
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "cCodPai" ) )
   cLine          += ""                                               

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeClienteEstablecimiento()

   local cLine    := "Estab" + __separator__
   cLine          += "" + __separator__                                    // Código del establecimiento del cliente donde se entrega de la mercancía (interno del cliente)
   cLine          += alltrim( ::cCodigoCliente ) + __separator__           // Código del cliente (interno del proveedor)
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "cCodEdi" ) ) + __separator__  // Código secundario del establecimiento del cliente según el proveedor (interno del proveedor). Algunos proveedores solo utilizan el campo IDCliProv
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Titulo" ) ) + __separator__ 
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Domicilio" ) ) + __separator__
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Poblacion" ) ) + __separator__  // Población del cliente
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "CodPostal" ) ) + __separator__  // Codigo postal del cliente
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "Provincia" ) ) + __separator__  // Provincia del cliente
   cLine          += alltrim( retfld( ::cCodigoCliente, D():Clientes( ::nView ), "cCodPai" ) )                    // País del cliente (España: ESP)
   cLine          += ""                                               

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeReferencias()

   local cLine    := "Referencias" + __separator__

   if Empty( ( D():FacturasClientes( ::nView ) )->cNumAlb )
      cLine       += alltrim( D():FacturasClientesIdShort( ::nView ) ) + __separator__   //Número del albarán de procedencia
      cLine       += "" + __separator__                                                  // Número del pedido no obligatorio
      cLine       += alltrim( D():FacturasClientesIdShort( ::nView ) ) + __separator__   // Número de la factura
      cLine       += ::getFecha( ( D():FacturasClientes( ::nView ) )->dFecFac ) + __separator__   // Fecha de la factura
      cLine       += "" + __separator__                                                  // Fecha del pedido no obligatorio
      cLine       += ::getFecha( ( D():FacturasClientes( ::nView ) )->dFecFac )          // Fecha de la factura
   else
      cLine       += alltrim( StrTran( ( D():FacturasClientes( ::nView ) )->cNumAlb, " ", "" ) ) + __separator__     //Número del albarán de procedencia
      cLine       += "" + __separator__                                                  // Número del pedido no obligatorio
      cLine       += alltrim( D():FacturasClientesIdShort( ::nView ) ) + __separator__   // Número de la factura
      cLine       += ::getFecha( retfld( ( D():FacturasClientes( ::nView ) )->cNumAlb, D():AlbaranesClientes( ::nView ), "dFecAlb" ) ) + __separator__   // Fecha del albarán
      cLine       += "" + __separator__                                                  // Fecha del pedido no obligatorio
      cLine       += ::getFecha( ( D():FacturasClientes( ::nView ) )->dFecFac )          // Fecha de la factura
   end if
   cLine          += ""  

   ::oFileEDI:add( cLine )      

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeLineas()

   local id       := D():FacturasClientesId( ::nView )

   if ( D():FacturasClientesLineas( ::nView ) )->( dbSeek( id ) )  

      while ( D():FacturasClientesLineasId( ::nView ) == id ) .and. !( D():FacturasClientesLineas( ::nView ) )->( eof() ) 

         if ::isLineaValida()

            ::writeDetallesLinea()

            if ::isDescuentoValido()
               ::writeDescuentoLinea()
            end if

            ::writeImpuestosLinea()

         end if 
      
         ( D():FacturasClientesLineas( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 
   
Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDetallesLinea()

   local cLine    := "Detalle" + __separator__
   cLine          += alltrim( ( D():FacturasClientesLineas( ::nView ) )->cRef ) + __separator__       // Código de artículo interno del proveedor
   cLine          += "" + __separator__                                                               // Código de artículo interno del cliente
   cLine          += alltrim( ( D():FacturasClientesLineas( ::nView ) )->cDetalle ) + __separator__   // Descripción (nombre) del artículo
   cLine          += ::getNumero( nTotNFacCli() ) + __separator__                                     // Cantidad del artículo
   cLine          += "Unidades" + __separator__                                                       // Unidad de medida de la cantidad
   /*
   cLine          += "" + __separator__                                                               // Número de unidades de expedición (bultos, cajas, etc.)
   cLine          += "" + __separator__                                                               // Número de unidades de consumo por unidad de expedición
   cLine          += "" + __separator__                                                               // Peso en gramos de una unidad. Solo tiene sentido cuando UM
   */
   cLine          += ::getNumero( nTotUFacCli() ) + __separator__                                     // Precio bruto unitario (sin descuentos, impuestos, etc.)
   cLine          += ::getNumero( nTotLFacCli() )                                                     // Importe bruto total de esta línea (Cdad x Punit)

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDescuentoLinea()

   local cLine    := "DescuentosLinea" + __separator__                                                 
   cLine          += "Descuento" + __separator__                                                      // Identifica si es un descuento o un cargo
   cLine          += "Comercial" + __separator__                                                      // Indica el tipo de descuento que es, atendiendo a una tabla dada por ellos
   cLine          += ::getNumero( ( D():FacturasClientesLineas( ::nView ) )->nDto ) + __separator__   // Indica el % de descuento
   cLine          += ::getNumero( nDtoLFacCli() )                                                     // Indica el importe del descuento

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeImpuestosLinea()

   local nImporte
   local cLine    := "ImpuestosLinea" + __separator__                                                 

   cLine          += "IVA" + __separator__                                                            // Identifica el tipo de impuesto. En la tabla códigos de impuesto se describen los valores posibles de este campo
   cLine          += ::getNumero( ( D():FacturasClientesLineas( ::nView ) )->nIva ) + __separator__   // Indica el % o el importe unitario del impuesto a aplicar
   nImporte       := nIvaLFacCli()                                                                    // Importe del impuesto
   cLine          += ::getNumero( nImporte )

   ::acumulaIva( ( D():FacturasClientesLineas( ::nView ) )->nIva, nImporte )

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeResumenPrimerImpuesto()

   local cLine    := ""

   if empty( ::sTotalFactura:nPorcentajePrimerIva() )
      Return ( self )
   end if 

   cLine          += "ResumenImpuestos" + __separator__
   cLine          += "IVA" + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nPorcentajePrimerIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nBasePrimerIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nTotalPrimerIva() ) 

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeResumenSegundoImpuesto()

   local cLine    := ""

   if empty( ::sTotalFactura:nPorcentajeSegundoIva() )
      Return ( self )
   end if 

   cLine          += "ResumenImpuestos" + __separator__
   cLine          += "IVA" + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nPorcentajeSegundoIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nBaseSegundoIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nTotalSegundoIva() )

   ::oFileEDI:add( cLine ) 

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeResumenTercerImpuesto()

   local cLine    := ""

   if empty( ::sTotalFactura:nPorcentajeTercerIva() )
      Return ( self )
   end if 

   cLine          += "ResumenImpuestos" + __separator__
   cLine          += "IVA" + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nPorcentajeTercerIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nBaseTercerIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nTotalTercerIva() ) 

   ::oFileEDI:add( cLine )

   MsgInfo( hb_valtoexp( ::hAcumulaIva ), "Resultado"  )

Return ( self )

//---------------------------------------------------------------------------//


METHOD writeVencimientos()

   local id       := D():FacturasClientesId( ::nView )

   if ( D():FacturasClientesCobros( ::nView ) )->( dbSeek( id ) )  

      while ( D():FacturasClientesCobrosIdShort( ::nView ) == id ) .and. !( D():FacturasClientesCobros( ::nView ) )->( eof() ) 

         ::writeDetallesVencimientos()
      
         ( D():FacturasClientesCobros( ::nView ) )->( dbSkip() ) 
      
      end while

   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeDetallesVencimientos()

   local cLine    := "Vencimientos" + __separator__
   cLine          += ::getFecha( ( D():FacturasClientesCobros( ::nView ) )->dPreCob ) + __separator__
   cLine          += ::getNumero( ( D():FacturasClientesCobros( ::nView ) )->nImporte ) + __separator__
   cLine          += "Recibo" + __separator__
   cLine          += alltrim( ( D():FacturasClientesCobros( ::nView ) )->cDescrip ) 

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD writeResumenTotales()

   local cLine    := "ResumenTotales" + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nTotalBruto ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:nTotalNeto ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:TotalDescuento() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:TotalBase() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:TotalIva() ) + __separator__
   cLine          += ::getNumero( ::sTotalFactura:TotalDocumento() )

   ::oFileEDI:add( cLine )

Return ( self )

//---------------------------------------------------------------------------//

METHOD setFacturaClienteGeneradaEDI()

   if D():lockFacturasClientes( ::nView )
      ( D():FacturasClientes( ::nView ) )->lExpEdi    := .t.
      ( D():FacturasClientes( ::nView ) )->dFecEdi    := getSysDate()
      ( D():FacturasClientes( ::nView ) )->cHorEdi    := time()
      D():unlockFacturasClientes( ::nView )
   end if 

Return ( self )

//---------------------------------------------------------------------------//

METHOD acumulaIva( nIva, nImporte )

   local nValor   := 0
   
   if hHaskey( ::hAcumulaIva, AllTrim( str( nIva ) ) )
      nValor      := hGet( ::hAcumulaIva, AllTrim( str( nIva ) ) )
      hSet( ::hAcumulaIva, AllTrim( str( nIva ) ), nValor + nImporte )      
   else
      hSet( ::hAcumulaIva, AllTrim( str( nIva ) ), nImporte )
   end if

   ::nTotalIva    += nImporte

Return .t.

//---------------------------------------------------------------------------//