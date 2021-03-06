#include "FiveWin.Ch"
#include "Factu.ch" 
 
CLASS DocumentsSales FROM Documents

   DATA oSender

   DATA oProduct
   DATA oStore
   DATA oPayment
   DATA oDirections

   DATA oViewEditResumen

   DATA oDocumentLines

   DATA oLinesDocumentsSales

   DATA nUltimoCliente

   DATA hTextDocuments                    INIT  {  "textMain"     => "Facturas de clientes",;
                                                   "textShort"    => "Factura",;
                                                   "textTitle"    => "lineas de facturas",;
                                                   "textSummary"  => "Resumen factura",;
                                                   "textGrid"     => "Grid facturas clientes" }
   
   DATA hOrdenRutas                       INIT  {  "1" => "lVisDom",;
                                                   "2" => "lVisLun",;
                                                   "3" => "lVisMar",;
                                                   "4" => "lVisMie",;
                                                   "5" => "lVisJue",;
                                                   "6" => "lVisVie",;
                                                   "7" => "lVisSab",;
                                                   "8" => "Cod" }

   DATA cTextSummaryDocument              INIT ""
   DATA cTypePrintDocuments               INIT ""                                       
   DATA cCounterDocuments                 INIT "" 

   DATA oTotalDocument

   DATA oldSerie                          INIT ""

   METHOD New( oSender )
   METHOD play() 

   METHOD runNavigator()
      METHOD onPreRunNavigator()

   METHOD hSetMaster( cField, uValue )                      INLINE ( hSet( ::oSender:hDictionaryMaster, cField, uValue ) )
   METHOD hGetMaster( cField )                              INLINE ( hGet( ::oSender:hDictionaryMaster, cField ) )

   METHOD hSetDetail( cField, uValue )                      INLINE ( hSet( ::oSender:oDocumentLineTemporal:hDictionary, cField, uValue ) )
   METHOD hGetDetail( cField )                              INLINE ( hGet( ::oSender:oDocumentLineTemporal:hDictionary, cField ) )

   METHOD setTextSummaryDocument( cTextSummaryDocument )    INLINE ( ::cTextSummaryDocument := cTextSummaryDocument )
   METHOD getTextSummaryDocument()                          INLINE ( if( hhaskey( ::hTextDocuments, "textSummary" ), hget( ::hTextDocuments, "textSummary"), ::cTextSummaryDocument ) )

   METHOD getTextGrid()                                     INLINE ( if( hhaskey( ::hTextDocuments, "textGrid" ), hget( ::hTextDocuments, "textGrid"), "" ) )
   METHOD getTextTitle()                                    INLINE ( if( hhaskey( ::hTextDocuments, "textTitle" ), hget( ::hTextDocuments, "textTitle"), "" ) )

   METHOD setTypePrintDocuments( cTypePrintDocuments )      INLINE ( ::cTypePrintDocuments := cTypePrintDocuments )
   METHOD getTypePrintDocuments()                           INLINE ( ::cTypePrintDocuments )

   METHOD setCounterDocuments( cCounterDocuments )          INLINE ( ::cCounterDocuments := cCounterDocuments )
   METHOD getCounterDocuments()                             INLINE ( ::cCounterDocuments )

   METHOD OpenFiles()
   METHOD CloseFiles()                                      INLINE ( D():DeleteView( ::nView ) )

   METHOD getSerie()                                        INLINE ( ::hGetMaster( "Serie" ) )
   METHOD getNumero()                                       INLINE ( ::hGetMaster( "Numero" ) )
   METHOD getSufijo()                                       INLINE ( ::hGetMaster( "Sufijo" ) )
   METHOD getStore()                                        INLINE ( ::hGetMaster( "Almacen" ) )

   METHOD getID()                                           INLINE ( ::getSerie() + str( ::getNumero() ) + ::getSufijo() )

   METHOD isPuntoVerde()                                    INLINE ( ::hGetMaster( "OperarPuntoVerde" ) )
   METHOD isRecargoEquivalencia()                           INLINE ( ::hGetMaster( "lRecargo" ) )

   METHOD resourceDetail( nMode )                           INLINE ( ::oLinesDocumentsSales:resourceDetail( nMode ) )

   METHOD onViewCancel()
   METHOD onViewSave()
   METHOD isResumenVenta()
   METHOD lValidResumenVenta()

   METHOD getDataBrowse( Name )                             INLINE ( hGet( ::oDocumentLineTemporal:hDictionary[ ::oViewEdit:oBrowse:nArrayAt ], Name ) )

   METHOD isChangeSerieTablet( lReadyToSend, getSerie )
   
   METHOD changeSerieTablet( getSerie )

   METHOD runGridCustomer()
   METHOD lValidCliente()

   METHOD runGridDirections()
   METHOD lValidDireccion()

   METHOD runGridPayment()
   METHOD lValidPayment()

   METHOD changeRuta()

   METHOD priorClient()                                     INLINE ( ::moveClient( .t. ) )
   METHOD nextClient()                                      INLINE ( ::moveClient( .f. ) )
   METHOD moveClient()

   METHOD loadNextClient()
      METHOD gotoUltimoCliente()
      METHOD setUltimoCliente()

   METHOD getBruto()                                        INLINE ( ::oDocumentLines:getBruto() )
   METHOD calculaIVA()                                      VIRTUAL

   METHOD saveAppendDetail()
   METHOD saveEditDetail()

   METHOD isPrintDocument()
   METHOD printDocument()                                   VIRTUAL

   METHOD saveEditDocumento()
   METHOD saveAppendDocumento()

   METHOD onPreSaveAppend()
      METHOD onPreSaveAppendDetail()                  

   METHOD onPostGetDocumento()                              INLINE ( ::oldSerie  := ::getSerie() ) 
   METHOD onPreSaveEdit()                                   
   
   METHOD onPreEnd()
      METHOD setDatasFromClientes()
      METHOD setDatasInDictionaryMaster( NumeroDocumento ) 

   // Lineas-------------------------------------------------------------------

   METHOD addDocumentLine()
      METHOD assignLinesDocument()
      METHOD setLinesDocument()
      METHOD appendDocumentLine( oDocumentLine )            INLINE ( D():appendHashRecord( oDocumentLine:hDictionary, ::getDataTableLine(), ::nView ) )
      METHOD delDocumentLine()                              INLINE ( D():deleteRecord( ::getDataTableLine(), ::nView ) )

   METHOD cComboRecargoValue()

   METHOD onclickClientEdit()                               INLINE ( ::oCliente:EditCustomer( hGet( ::hDictionaryMaster, "Cliente" ) ) )
   METHOD onclickClientSales()                              INLINE ( ::oCliente:SalesCustomer( hGet( ::hDictionaryMaster, "Cliente" ) ) )

   METHOD getEditDetail() 
   
   METHOD setDocuments()
   
   METHOD Resource( nMode )

END CLASS

//---------------------------------------------------------------------------//

METHOD New( oSender ) CLASS DocumentsSales

   ::oSender               := oSender

   if !::openFiles()
      return ( self )
   end if 

   ::oViewSearchNavigator  := DocumentSalesViewSearchNavigator():New( oSender )

   ::oViewEdit             := DocumentSalesViewEdit():New( oSender )

   ::oViewEditResumen      := ViewEditResumen():New( oSender )

   ::oCliente              := Customer():init( oSender )  

   ::oProduct              := Product():init( oSender )

   ::oStore                := Store():init( oSender )

   ::oPayment              := Payment():init( oSender )

   ::oDirections           := Directions():init( oSender )

   ::oDocumentLines        := DocumentLines():New( oSender )

   ::oLinesDocumentsSales  := LinesDocumentsSales():New( oSender )

   ::oTotalDocument        := TotalDocument():New( oSender )

return ( self )

//---------------------------------------------------------------------------//

METHOD play() CLASS DocumentsSales

   if ::onPreRunNavigator()
      ::runNavigator()
   end if 

   ::closeFiles()

return ( self )

//---------------------------------------------------------------------------//
//
// Filtro para codigos de agente
//

METHOD onPreRunNavigator() CLASS DocumentsSales

   if empty( ::getWorkArea() )
      Return .t.
   end if 

   ( ::getWorkArea() )->( ordsetfocus( "dFecDes" ) )
   ( ::getWorkArea() )->( dbgotop() ) 

   if ( accessCode():lFilterByAgent ) .and. !empty( accessCode():cAgente )
   
      ( ::getWorkArea() )->( dbsetfilter( {|| Field->cCodAge == accessCode():cAgente }, "Field->cCodAge == '" + accessCode():cAgente + "'" ) )
      ( ::getWorkArea() )->( dbgotop() )

      ( D():Clientes( ::nView ) )->( dbsetfilter( {|| Field->cAgente == accessCode():cAgente }, "Field->cCodAge == '" + accessCode():cAgente + "'" ) )
      ( D():Clientes( ::nView ) )->( dbgotop() )

   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD runNavigator() CLASS DocumentsSales

   if !empty( ::oViewSearchNavigator )
      ::oViewSearchNavigator:Resource()
   end if

return ( self )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS DocumentsSales
   
   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():PedidosClientes( ::nView )

      D():PedidosClientesLineas( ::nView )

      D():AlbaranesClientes( ::nView )

      D():AlbaranesClientesLineas( ::nView )

      D():FacturasClientes( ::nView )

      D():FacturasClientesLineas( ::nView )

      D():FacturasClientesCobros( ::nView )

      D():TiposIva( ::nView )

      D():Divisas( ::nView )

      D():Clientes( ::nView )

      D():ClientesDirecciones( ::nView )

      D():Articulos( ::nView )

      D():ArticulosCodigosBarras( ::nView )

      D():ProveedorArticulo( ::nView )

      D():Proveedores( ::nView )

      D():Familias( ::nView )

      D():ImpuestosEspeciales( ::nView )

      D():Kit( ::nView )

      D():Contadores( ::nView )

      D():Documentos( ::nView )

      D():FormasPago( ::nView )

      D():TiposIncidencias( ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      apoloMsgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

   if !lOpenFiles
      ::closeFiles()
   end if

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD isChangeSerieTablet() CLASS DocumentsSales
   
   if ::lZoomMode()
      Return ( self )
   end if 

   if hGet( ::hDictionaryMaster, "Envio" )
      ::ChangeSerieTablet( ::oViewEdit:getSerie )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD ChangeSerieTablet( getSerie ) CLASS DocumentsSales

   local cSerie   := getSerie:VarGet()

   do case
      case cSerie == "A"
         getSerie:cText( "B" )

      case cSerie == "B"
         getSerie:cText( "C" )

      case cSerie == "C"
         getSerie:cText( "A" )

      otherwise
         getSerie:cText( "A" )

   end case

Return ( self )

//---------------------------------------------------------------------------//

METHOD lValidDireccion() CLASS DocumentsSales

   local nRec
   local nOrdAnt
   local lValid            := .f.
   local codigoCliente     := ::oViewEdit:getCodigoCliente:varGet()     // hGet( ::hDictionaryMaster, "Cliente" )
   local codigoDireccion   := ::oViewEdit:getCodigoDireccion:varGet()

   if empty( codigoCliente )
      return .t.
   end if

   if empty( codigoDireccion )
      return .t.
   end if

   ::oViewEdit:getCodigoDireccion:Disable()

   ::oViewEdit:getNombreDireccion:cText( "" )

   codigoDireccion         := padr( codigoCliente, 12 ) + padr( codigoDireccion, 10 )

   nRec                    := ( D():ClientesDirecciones( ::nView ) )->( recno() )
   nOrdAnt                 := ( D():ClientesDirecciones( ::nView ) )->( ordsetfocus( "cCodCli" ) )

   if ( D():ClientesDirecciones( ::nView ) )->( dbseek( codigoDireccion ) )

      ::oViewEdit:getCodigoDireccion:cText( ( D():ClientesDirecciones( ::nView ) )->cCodObr )
      ::oViewEdit:getNombreDireccion:cText( ( D():ClientesDirecciones( ::nView ) )->cNomObr )

      lValid               := .t.

   else

      apoloMsgStop( "Direcci�n no encontrada" )
      
   end if

   ( D():ClientesDirecciones( ::nView ) )->( ordsetfocus( nOrdAnt ) )
   ( D():ClientesDirecciones( ::nView ) )->( dbgoto( nRec ) )

   ::oViewEdit:getCodigoDireccion:Enable()

Return lValid

//---------------------------------------------------------------------------//

METHOD lValidPayment() CLASS DocumentsSales

   local nRec
   local nOrdAnt
   local lValid            := .f.
   local codigoPayment     := hGet( ::hDictionaryMaster, "Pago" )

   if empty( codigoPayment )
      return .f.
   end if

   ::oViewEditResumen:oCodigoFormaPago:Disable()
   ::oViewEditResumen:oNombreFormaPago:cText( "" )
   
   nRec                    := ( D():FormasPago( ::nView ) )->( Recno() )
   nOrdAnt                 := ( D():FormasPago( ::nView ) )->( ordsetfocus( "cCodPago" ) )

   if ( D():FormasPago( ::nView ) )->( dbSeek( codigoPayment ) )

      ::oViewEditResumen:oCodigoFormaPago:cText( ( D():FormasPago( ::nView ) )->cCodPago )
      ::oViewEditResumen:oNombreFormaPago:cText( ( D():FormasPago( ::nView ) )->cDesPago )

      lValid               := .t.

   else

      apoloMsgStop( "Forma de pago no encontrada" )
      
   end if

   ( D():FormasPago( ::nView ) )->( ordsetfocus( nOrdAnt ) )
   ( D():FormasPago( ::nView ) )->( dbgoto( nRec ) )

   ::oViewEditResumen:oCodigoFormaPago:Enable()

Return lValid

//---------------------------------------------------------------------------//

METHOD lValidCliente() CLASS DocumentsSales

   local lValid      := .t.
   local cNewCodCli  := hGet( ::hDictionaryMaster, "Cliente" )

   if empty( cNewCodCli )
      Return .t.
   else
      cNewCodCli     := Rjust( cNewCodCli, "0", RetNumCodCliEmp() )
   end if

   ::oViewEdit:getCodigoCliente:Disable()

   if !empty( ::oViewEdit:getCodigoDireccion )
      ::oViewEdit:getCodigoDireccion:cText( "" )
   end if

   if !empty( ::oViewEdit:getNombreDireccion )
      ::oViewEdit:getNombreDireccion:cText( "" )
   end if

   if ::setDatasFromClientes( cNewCodCli )

      ::oViewEdit:refreshCliente()
      ::oViewEdit:refreshSerie()

      lValid         := .t.

   else

      ApoloMsgStop( "Cliente no encontrado" )

      lValid         := .f.

   end if

   ::oViewEdit:getCodigoCliente:Enable()

RETURN lValid

//---------------------------------------------------------------------------//

METHOD ChangeRuta() CLASS DocumentsSales

   local cCliente          := ""
   local nOrdAnt           := ( D():Clientes( ::nView ) )->( ordsetfocus() )

   if hhaskey( ::hOrdenRutas, alltrim( str( ::oViewEdit:oCbxRuta:nAt ) ) )

      nOrdAnt              := ( D():Clientes( ::nView ) )->( ordsetfocus( ::hOrdenRutas[ alltrim( str( ::oViewEdit:oCbxRuta:nAt ) ) ] ) )

      if ( D():Clientes( ::nView ) )->( OrdKeyCount() ) != 0 
         
         ( D():Clientes( ::nView ) )->( dbgotop() )

         if !( D():Clientes( ::nView ) )->( eof() )
            cCliente       := ( D():Clientes( ::nView ) )->Cod
         end if   

         if !empty( ::oViewEdit:getRuta )
            ::oViewEdit:getRuta:cText( alltrim( Str( ( D():Clientes( ::nView ) )->( OrdKeyNo() ) ) ) + "/" + alltrim( str( ( D():Clientes( ::nView ) )->( OrdKeyCount() ) ) ) )
            ::oViewEdit:getRuta:Refresh()
         end if

      else

         ( D():Clientes( ::nView ) )->( ordsetfocus( "Cod" ) )
         ( D():Clientes( ::nView ) )->( dbgotop() )

         cCliente          := ( D():Clientes( ::nView ) )->Cod

         if !empty( ::oViewEdit:getRuta )
            ::oViewEdit:getRuta:cText( "1/1" )
            ::oViewEdit:getRuta:Refresh()
         end if
      
      end if   

      ( D():Clientes( ::nView ) )->( ordsetfocus( nOrdAnt ) )

   end if

   if !empty( ::oViewEdit:getCodigoCliente )
      ::oViewEdit:getCodigoCliente:cText( cCliente )
      ::oViewEdit:getCodigoCliente:lValid()
   end if 

   if !empty( ::oViewEdit:getCodigoDireccion )
      ::oViewEdit:getCodigoDireccion:cText( space( 10 ) )
      ::oViewEdit:getCodigoDireccion:lValid()
   end if   

return cCliente

//---------------------------------------------------------------------------//

METHOD moveClient( lAnterior ) CLASS DocumentsSales

   local lSet              := .f.
   local nOrdAnt

   if hhaskey( ::hOrdenRutas, alltrim( Str( ::oViewEdit:oCbxRuta:nAt ) ) )
      
      nOrdAnt              := ( D():Clientes( ::nView ) )->( ordsetfocus( ::hOrdenRutas[ alltrim( str( ::oViewEdit:oCbxRuta:nAt ) ) ] ) )

      if isTrue( lAnterior )

         if ( D():Clientes( ::nView ) )->( OrdKeyNo() ) != 1
            ( D():Clientes( ::nView ) )->( dbSkip( -1 ) )
            lSet           := .t.
         end if

      end if 

      if isFalse( lAnterior )

         if ( D():Clientes( ::nView ) )->( OrdKeyNo() ) != ( D():Clientes( ::nView ) )->( OrdKeyCount() )
            ( D():Clientes( ::nView ) )->( dbSkip() )
            lSet           := .t.
         end if

      end if   

      if isNil( lAnterior )
         lSet              := .t.
      end if 

      if !empty( ::oViewEdit:getRuta )
         ::oViewEdit:getRuta:cText( alltrim( str( ( D():Clientes( ::nView ) )->( OrdKeyNo() ) ) ) + "/" + alltrim( str( ( D():Clientes( ::nView ) )->( OrdKeyCount() ) ) ) )
         ::oViewEdit:getRuta:Refresh()
      end if

      ( D():Clientes( ::nView ) )->( ordsetfocus( nOrdAnt ) )   

      if lSet

         ::oViewEdit:getCodigoCliente:cText( ( D():Clientes( ::nView ) )->Cod )
         ::oViewEdit:getCodigoCliente:lValid()

         ::oViewEdit:getCodigoDireccion:cText( Space( 10 ) )
         ::oViewEdit:getCodigoDireccion:lValid()

      end if

   end if

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD loadNextClient() CLASS DocumentsSales

   ::gotoUltimoCliente()

   if ::nUltimoCliente != 0 
      ::nextClient()
   else
      ::moveClient()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD gotoUltimoCliente() CLASS DocumentsSales

   local nOrdAnt     := ( D():Clientes( ::nView ) )->( ordsetfocus( ::hOrdenRutas[ alltrim( str( ::oViewEdit:oCbxRuta:nAt ) ) ] ) )

   if empty( ::nUltimoCliente )
      ( D():Clientes( ::nView ) )->( dbgotop() )
   else
      ( D():Clientes( ::nView ) )->( OrdKeyGoto( ::nUltimoCliente ) )
   end if 

   ( D():Clientes( ::nView ) )->( ordsetfocus( nOrdAnt ) ) 
         
Return .t.

//---------------------------------------------------------------------------//

METHOD setUltimoCliente() CLASS DocumentsSales

   local nOrdAnt     := ( D():Clientes( ::nView ) )->( ordsetfocus( ::hOrdenRutas[ alltrim( Str( ::oViewEdit:oCbxRuta:nAt ) ) ] ) )

   ::nUltimoCliente  := ( D():Clientes( ::nView ) )->( OrdKeyNo() )

   ( D():Clientes( ::nView ) )->( ordsetfocus( nOrdAnt ) ) 

Return nil

//---------------------------------------------------------------------------//

METHOD saveAppendDetail() CLASS DocumentsSales

   ::oDocumentLines:appendLineDetail( ::oDocumentLineTemporal )

   if !empty( ::oViewEdit:oBrowse )
      ::oViewEdit:oBrowse:Refresh()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD saveEditDetail() CLASS DocumentsSales

   ::oDocumentLines:saveLineDetail( ::nPosDetail, ::oDocumentLineTemporal )

   if !empty( ::oViewEdit:oBrowse )
      ::oViewEdit:oBrowse:Refresh()
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD lValidResumenVenta() CLASS DocumentsSales

   local lReturn  := .t.
   
   // Comprobamos que el cliente no est� vac�o-----------------------------------

   if empty( hGet( ::hDictionaryMaster, "Cliente" ) )
      ApoloMsgStop( "Cliente no puede estar vac�o.", "�Atenci�n!" )
      return .f.
   end if

   // Comprobamos que el documento tenga l�neas----------------------------------

   if len( ::oDocumentLines:aLines ) <= 0
      ApoloMsgStop( "No puede almacenar un documento sin lineas.", "�Atenci�n!" )
      return .f.
   end if

Return lReturn

//---------------------------------------------------------------------------//

METHOD onViewCancel()

   ::oViewEdit:oDlg:end( )

Return ( self )

//---------------------------------------------------------------------------//  

METHOD onViewSave()

   ::oTotalDocument:Calculate()

   if ::isResumenVenta()

      ::setUltimoCliente()

      ::oViewEdit:oDlg:end( IDOK )

   end if 

Return ( self )

//---------------------------------------------------------------------------//  

METHOD isResumenVenta() CLASS DocumentsSales

   if !::lValidResumenVenta()
      Return .f.
   end if

   if empty( ::oViewEditResumen )
      Return .f.
   end if 

   ::oViewEditResumen:setTitleDocumento( ::getTextSummaryDocument() )

Return ( ::oViewEditResumen:Resource() )

//---------------------------------------------------------------------------//

METHOD isPrintDocument() CLASS DocumentsSales

   if empty( ::cFormatToPrint ) .or. alltrim( ::cFormatToPrint ) == "No imprimir"
      Return .f.
   end if

   ::cFormatToPrint  := left( ::cFormatToPrint, 3 )

   ::printDocument()

   ::resetFormatToPrint()

Return( self )

//---------------------------------------------------------------------------//

METHOD saveEditDocumento() CLASS DocumentsSales            

   ::Super:saveEditDocumento()

   ::deleteLinesDocument()

   ::assignLinesDocument()   

   ::setLinesDocument()

return ( .t. )

//---------------------------------------------------------------------------//

METHOD saveAppendDocumento() CLASS DocumentsSales

   ::Super:saveAppendDocumento()

   ::assignLinesDocument()

   ::setLinesDocument()

return ( .t. )

//---------------------------------------------------------------------------//

METHOD assignLinesDocument() CLASS DocumentsSales

   local oDocumentLine
   local nNumeroLinea   := 0

   for each oDocumentLine in ::oDocumentLines:aLines
   
      nNumeroLinea++

      oDocumentLine:setNumeroLinea( nNumeroLinea )
      oDocumentLine:setPosicionImpresion( nNumeroLinea )
      oDocumentLine:setSerieMaster( ::hDictionaryMaster )
      oDocumentLine:setNumeroMaster( ::hDictionaryMaster )
      oDocumentLine:setSufijoMaster( ::hDictionaryMaster )
      oDocumentLine:setAlmacenMaster( ::hDictionaryMaster )

   next

Return( self )

//---------------------------------------------------------------------------//

METHOD setLinesDocument() CLASS DocumentsSales

   local oDocumentLine

   for each oDocumentLine in ::oDocumentLines:aLines
      ::appendDocumentLine( oDocumentLine )
   next

RETURN ( self ) 

//---------------------------------------------------------------------------//

METHOD onPreEnd() CLASS DocumentsSales
   
   ::oDocumentLines:reset() 

   ::isPrintDocument()

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD cComboRecargoValue() CLASS DocumentsSales

   Local cComboRecargoValue

   // hGet( ::oSender:hDictionaryMaster, "Pago" )

   if !empty( ::oViewEditResumen:aComboRecargo[1] )
      cComboRecargoValue    := ::oViewEditResumen:cComboRecargo[1]
   endif

Return ( ::oViewEditResumen:cComboRecargo  := cComboRecargoValue )

//---------------------------------------------------------------------------//

METHOD addDocumentLine() CLASS DocumentsSales

   local oDocumentLine  := ::getDocumentLine()

   if !empty( oDocumentLine )
      ::oDocumentLines:addLines( oDocumentLine )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD setDatasInDictionaryMaster( NumeroDocumento ) CLASS DocumentsSales

   if !empty( NumeroDocumento )
      hSet( ::hDictionaryMaster, "Numero", NumeroDocumento )
   end if 

   hSet( ::hDictionaryMaster, "TotalDocumento", ::oTotalDocument:getTotalDocument() )

   hSet( ::hDictionaryMaster, "TotalImpuesto", ::oTotalDocument:getImporteIva() )

   hSet( ::hDictionaryMaster, "TotalRecargo", ::oTotalDocument:getImporteRecargo() )

   hSet( ::hDictionaryMaster, "TotalNeto", ::oTotalDocument:getBase() )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD GetEditDetail() CLASS DocumentsSales

   if !empty( ::nPosDetail )
      ::oDocumentLineTemporal   := ::oDocumentLines:getCloneLineDetail( ::nPosDetail )
   end if

Return ( self )

//---------------------------------------------------------------------------//

METHOD setDocuments() CLASS DocumentsSales

   local cFormato
   local nFormato
   local cDocumento     := ""
   local aFormatos      := aDocs( ::getTypePrintDocuments(), D():Documentos( ::nView ), .t. )

   cFormato             := cFormatoDocumento( ::getSerie(), ::getCounterDocuments(), D():Contadores( ::nView ) )

   if empty( cFormato )
      cFormato          := cFirstDoc( ::getTypePrintDocuments(), D():Documentos( ::nView ) )
   end if

   nFormato             := aScan( aFormatos, {|x| Left( x, 3 ) == cFormato } )
   nFormato             := Max( Min( nFormato, len( aFormatos ) ), 1 )

   ::oViewEditResumen:SetImpresoras( aFormatos )
   ::oViewEditResumen:SetImpresoraDefecto( aFormatos[ nFormato ] )

return ( .t. )

//---------------------------------------------------------------------------//

METHOD Resource( nMode ) CLASS DocumentsSales

   local lResource   := .f.

   if !empty( ::oViewEdit )
      lResource      := ::oViewEdit:Resource( nMode )
   end if

Return ( lResource )   

//---------------------------------------------------------------------------//

METHOD onPreSaveAppend() CLASS DocumentsSales

   Local numeroDocumento   := nNewDoc( ::getSerie(), ::getWorkArea(), ::getCounterDocuments(), , D():Contadores( ::nView ) )
   
   if empty( numeroDocumento )
      Return ( .f. )
   end if 

Return ( ::setDatasInDictionaryMaster( numeroDocumento ) )

//---------------------------------------------------------------------------//

METHOD onPreSaveAppendDetail() CLASS DocumentsSales

   local oDocumentLine           := ::getDocumentLine()
   local cDescripcionArticulo    := alltrim( ::hGetDetail( "DescripcionArticulo" ) )

   oDocumentLine:setValue( "DescripcionAmpliada", cDescripcionArticulo )

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD onPreSaveEdit() CLASS DocumentsSales

   if ::oldSerie != ::getSerie()
      ::onPreSaveAppend()
   else
      ::setDatasInDictionaryMaster() 
   end if 

Return ( .t. )

//---------------------------------------------------------------------------//

METHOD setDatasFromClientes( CodigoCliente ) CLASS DocumentsSales

   Local lReturn           := .f.
   local AgenteIni         := GetPvProfString( "Tablet", "Agente", "", cIniAplication() )

   D():getStatusClientes( ::nView )

   ( D():Clientes( ::nView ) )->( ordsetfocus( 1 ) )

   if ( D():Clientes( ::nView ) )->( dbseek( CodigoCliente ) )

      lReturn              := .t.

      hSet( ::hDictionaryMaster, "Cliente",              ( D():Clientes( ::nView ) )->Cod )
      hSet( ::hDictionaryMaster, "NombreCliente",        ( D():Clientes( ::nView ) )->Titulo )
      hSet( ::hDictionaryMaster, "DomicilioCliente",     ( D():Clientes( ::nView ) )->Domicilio )
      hSet( ::hDictionaryMaster, "PoblacionCliente",     ( D():Clientes( ::nView ) )->Poblacion )
      hSet( ::hDictionaryMaster, "ProvinciaCliente",     ( D():Clientes( ::nView ) )->Provincia )
      hSet( ::hDictionaryMaster, "CodigoPostalCliente",  ( D():Clientes( ::nView ) )->CodPostal )
      hSet( ::hDictionaryMaster, "TelefonoCliente",      ( D():Clientes( ::nView ) )->Telefono )
      hSet( ::hDictionaryMaster, "DniCliente",           ( D():Clientes( ::nView ) )->Nif )
      hSet( ::hDictionaryMaster, "GrupoCliente",         ( D():Clientes( ::nView ) )->Nif )
      hSet( ::hDictionaryMaster, "OperarPuntoVerde",     ( D():Clientes( ::nView ) )->lPntVer )

      if ::lAppendMode() 

         if !empty( ( D():Clientes( ::nView ) )->Serie )
            hSet( ::hDictionaryMaster, "Serie", ( D():Clientes( ::nView ) )->Serie )
         end if

         hSet( ::hDictionaryMaster, "Almacen",                       ( if( empty( oUser():cAlmacen() ), ( D():Clientes( ::nView ) )->cCodAlm, oUser():cAlmacen() ) ) )
         hSet( ::hDictionaryMaster, "Pago",                          ( if( empty( ( D():Clientes( ::nView ) )->CodPago ), cDefFpg(), ( D():Clientes( ::nView ) )->CodPago ) ) )
         hSet( ::hDictionaryMaster, "Agente",                        ( if( empty( AgenteIni ), ( D():Clientes( ::nView ) )->cAgente, AgenteIni ) ) )

         hSet( ::hDictionaryMaster, "TipoImpuesto",                  ( D():Clientes( ::nView ) )->nRegIva )
         hSet( ::hDictionaryMaster, "Tarifa",                        ( D():Clientes( ::nView ) )->cCodTar )
         hSet( ::hDictionaryMaster, "Ruta",                          ( D():Clientes( ::nView ) )->cCodRut )
         hSet( ::hDictionaryMaster, "NumeroTarifa",                  ( D():Clientes( ::nView ) )->nTarifa )
         hSet( ::hDictionaryMaster, "DescuentoTarifa",               ( D():Clientes( ::nView ) )->nDtoArt )
         hSet( ::hDictionaryMaster, "Transportista",                 ( D():Clientes( ::nView ) )->cCodTrn )
         hSet( ::hDictionaryMaster, "DescripcionDescuento1",         ( D():Clientes( ::nView ) )->cDtoEsp )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento1",          ( D():Clientes( ::nView ) )->nDtoEsp )
         hSet( ::hDictionaryMaster, "DescripcionDescuento2",         ( D():Clientes( ::nView ) )->cDpp )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento2",          ( D():Clientes( ::nView ) )->nDpp )
         hSet( ::hDictionaryMaster, "DescripcionDescuento3",         ( D():Clientes( ::nView ) )->cDtoUno )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento3",          ( D():Clientes( ::nView ) )->nDtoCnt )
         hSet( ::hDictionaryMaster, "DescripcionDescuento4",         ( D():Clientes( ::nView ) )->cDtoDos )
         hSet( ::hDictionaryMaster, "PorcentajeDescuento4",          ( D():Clientes( ::nView ) )->nDtoRap )
         hSet( ::hDictionaryMaster, "DescuentoAtipico",              ( D():Clientes( ::nView ) )->nDtoAtp )
         hSet( ::hDictionaryMaster, "LugarAplicarDescuentoAtipico",  ( D():Clientes( ::nView ) )->nSbrAtp )
         hSet( ::hDictionaryMaster, "RecargoEquivalencia",           ( D():Clientes( ::nView ) )->lReq )

      end if

   end if

   D():setStatusClientes( ::nView )

Return( lReturn ) 

//---------------------------------------------------------------------------//

METHOD runGridPayment() CLASS DocumentsSales

   if ::lZoomMode()
      Return ( self )
   end if 

   ::oViewEditResumen:oCodigoFormaPago:Disable()

   if !empty( ::oPayment:oGridPayment )

      ::oPayment:oGridPayment:showView()

      if ::oPayment:oGridPayment:isEndOk()
         ::oViewEditResumen:SetGetValue( ( D():FormasPago( ::nView ) )->cCodPago, "Pago" )
      end if

      ::lValidPayment()

   end if

   ::oViewEditResumen:oCodigoFormaPago:Enable()

Return ( self )

//---------------------------------------------------------------------------//

METHOD runGridCustomer() CLASS DocumentsSales

   if ::lZoomMode()
      Return ( self )
   end if

   ::oViewEdit:getCodigoCliente:Disable()

   if !empty( ::oCliente:oGridCustomer )

      ::oCliente:oGridCustomer:showView()

      if ::oCliente:oGridCustomer:IsEndOk()
         ::oViewEdit:SetGetValue( ( D():Clientes( ::nView ) )->Cod, "Cliente" )
      end if

      ::lValidCliente()

   end if

   ::oViewEdit:getCodigoCliente:Enable()

Return ( self )

//---------------------------------------------------------------------------//

METHOD runGridDirections() CLASS DocumentsSales

   local codigoCliente     

   if ::lZoomMode()
      Return ( self )
   end if

   codigoCliente           := hGet( ::hDictionaryMaster, "Cliente" )

   if empty( codigoCliente )
      ApoloMsgStop( "No puede seleccionar una direcci�n con cliente vac�o" )
      Return ( self )
   end if

   ::oViewEdit:getCodigoDireccion:Disable()

   if !empty( ::oDirections:oGridDirections )

      ::oDirections:setIdCustomer( codigoCliente )

      ::oDirections:putFilter()

      ::oDirections:oGridDirections:showView()

      if ::oDirections:oGridDirections:IsEndOk()
         ::oViewEdit:SetGetValue( ( D():ClientesDirecciones( ::nView ) )->cCodObr, "Direccion" )
      end if

      ::lValidDireccion()

      ::oDirections:quitFilter()

   end if

   ::oViewEdit:getCodigoDireccion:Enable()

Return ( self )

//---------------------------------------------------------------------------//

