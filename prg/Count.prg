#include "FiveWin.Ch"
#include "Factu.ch" 

static aDoc          := {  {"NPEDPRV", "Pedido a proveedores"                    , .t., .t., .t., .f. },;
                           {"NALBPRV", "Albaran de proveedores"                  , .t., .t., .t., .f. },;
                           {"NFACPRV", "Facturas de proveedores"                 , .t., .t., .t., .t. },;
                           {"NRCTPRV", "Facturas rectificativas de proveedores"  , .t., .t., .t., .t. },;
                           {"NSATCLI", "S.A.T. a clientes"                       , .t., .t., .t., .f. },;
                           {"NPRECLI", "Presupuestos a clientes"                 , .t., .t., .t., .f. },;
                           {"NPEDCLI", "Pedido de clientes"                      , .t., .t., .t., .f. },;
                           {"NALBCLI", "Albaranes de clientes"                   , .t., .t., .t., .f. },;
                           {"NFACCLI", "Facturas a clientes"                     , .t., .t., .t., .t. },;
                           {"NANTCLI", "Anticipos de facturas clientes"          , .t., .t., .t., .f. },;
                           {"NFACREC", "Facturas rectificativas"                 , .t., .t., .t., .t. },;
                           {"NDEPAGE", "Introducci�n dep�sitos"                  , .t., .t., .t., .f. },;
                           {"NEXTAGE", "Estado dep�sitos"                        , .t., .t., .t., .f. },;
                           {"NTIKCLI", "Tickets a clientes"                      , .t., .f., .t., .f. },;
                           {"NPARPRD", "Partes de producci�n"                    , .t., .t., .t., .f. },;
                           {"NMOVALM", "Movimientos de almac�n"                  , .f., .t., .t., .f. },;
                           {"NSESION", "Sesi�nes"                                , .f., .f., .t., .f. },;
                           {"NREMESA", "Remesas bancarias"                       , .f., .f., .t., .f. },;
                           {"NORDCAR", "Ordenes de carga"                        , .f., .f., .t., .f. },;
                           {"NCOBCLI", "Cobros de clientes"                      , .f., .f., .t., .f. },;
                           {"NRECPRV", "Recibos de proveedor"                    , .t., .t., .f., .f. },;
                           {"NRECCLI", "Recibos de clientes"                     , .t., .t., .t., .f. },;
                           {"NEXPEDI", "Expedientes"                             , .t., .t., .t., .f. },;
                           {"NCOBAGE", "Liquidaci�n de agentes"                  , .f., .t., .t., .f. },;
                           {"NENTPED", "Entrega a cuenta pedido"                 , .f., .t., .f., .f. },;
                           {"NENTALB", "Entrega a cuenta albar�n"                , .f., .t., .f., .f. } }


//--------------------------------------------------------------------------//
//Funciones del programa
//--------------------------------------------------------------------------//

/*
Cambia el numero del contados
*/

function putCount( cPath, cField, cSerDoc, nNewNum )

   local nPos

   DEFAULT cPath  := cPatEmp()

   dbUseArea( .t., cDriver(), cPath + "nCount.Dbf", "COUNT", .t. )
   COUNT->( ordListAdd( cPath + "nCount.Cdx"  ) )

   if COUNT->( dbSeek( cField ) )

      nPos        := COUNT->( fieldpos( cSerDoc ) )

      if nPos     != 0
         COUNT->( FieldPut( nPos, nNewNum ) )
      end if

   end if

   COUNT->( dbCloseArea() )

Return ( nil )

//--------------------------------------------------------------------------//

Function synCount( cPath, nSemilla )

   local cDoc
   local dbf
   local oError
   local oBlock

   DEFAULT cPath     := cPatEmp()
   DEFAULT nSemilla  := 1 

   oBlock            := ErrorBlock( {| oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      /*
      Deben de existir todos los tipos de documentos------------------------------
      */

      USE ( cPath + "NCOUNT.DBF" ) NEW SHARED VIA ( cDriver() ) ALIAS ( cCheckArea( "NCOUNT", @dbf ) )
      SET ADSINDEX TO ( cPath + "NCOUNT.CDX" ) ADDITIVE

      if !( dbf )->( neterr() )

         ( dbf )->( ordsetfocus( "Doc" ) )

         for each cDoc in aDoc

            if !( dbf )->( dbSeek( cDoc[ 1 ] ) )

               if dbAppe( dbf )
                  ( dbf )->Doc   := cDoc[ 1 ]
                  ( dbf )->Des   := cDoc[ 2 ]
                  ( dbf )->lSerie:= cDoc[ 3 ]
                  ( dbf )->lDoc  := cDoc[ 4 ]
                  ( dbf )->lCon  := cDoc[ 5 ]
                  ( dbf )->lNFC  := cDoc[ 6 ]

                  if cDoc[ 1 ] == "NSESION"
                  
                     ( dbf )->A     := 1
                     ( dbf )->B     := 1
                     ( dbf )->C     := 1
                     ( dbf )->D     := 1
                     ( dbf )->E     := 1
                     ( dbf )->H     := 1
                     ( dbf )->I     := 1
                     ( dbf )->J     := 1
                     ( dbf )->K     := 1
                     ( dbf )->L     := 1
                     ( dbf )->M     := 1
                     ( dbf )->N     := 1
                     ( dbf )->O     := 1
                     ( dbf )->P     := 1
                     ( dbf )->Q     := 1
                     ( dbf )->R     := 1
                     ( dbf )->S     := 1
                     ( dbf )->T     := 1
                     ( dbf )->U     := 1
                     ( dbf )->V     := 1
                     ( dbf )->W     := 1
                     ( dbf )->X     := 1
                     ( dbf )->Y     := 1
                     ( dbf )->Z     := 1
                  
                  else

                     ( dbf )->A     := nSemilla
                     ( dbf )->B     := nSemilla
                     ( dbf )->C     := nSemilla
                     ( dbf )->D     := nSemilla
                     ( dbf )->E     := nSemilla
                     ( dbf )->H     := nSemilla
                     ( dbf )->I     := nSemilla
                     ( dbf )->J     := nSemilla
                     ( dbf )->K     := nSemilla
                     ( dbf )->L     := nSemilla
                     ( dbf )->M     := nSemilla
                     ( dbf )->N     := nSemilla
                     ( dbf )->O     := nSemilla
                     ( dbf )->P     := nSemilla
                     ( dbf )->Q     := nSemilla
                     ( dbf )->R     := nSemilla
                     ( dbf )->S     := nSemilla
                     ( dbf )->T     := nSemilla
                     ( dbf )->U     := nSemilla
                     ( dbf )->V     := nSemilla
                     ( dbf )->W     := nSemilla
                     ( dbf )->X     := nSemilla
                     ( dbf )->Y     := nSemilla
                     ( dbf )->Z     := nSemilla

                  end if

                  ( dbf )->( dbUnLock() )
               end if

            else

               if ( dbf )->( dbRLock() )
                  ( dbf )->lSerie:= cDoc[ 3 ]
                  ( dbf )->lDoc  := cDoc[ 4 ]
                  ( dbf )->lCon  := cDoc[ 5 ]
                  ( dbf )->lNFC  := cDoc[ 6 ]
                  ( dbf )->( dbUnLock() )
               end if

            end if

         next 

      end if 

   RECOVER USING oError

      msgStop( ErrorMessage( oError ), "Imposible abrir la tabla de contadores" )

   END SEQUENCE
   
   ErrorBlock( oBlock )

   CLOSE ( dbf )

Return nil

//---------------------------------------------------------------------------//
//Funciones comunes del programa y pda
//---------------------------------------------------------------------------//

Function IsCount()

   if !lExistTable( cPatEmp() + "nCount.Dbf" )
      mkCount( cPatEmp() )
   end if

   if !lExistIndex( cPatEmp() + "nCount.Cdx" )
      rxCount( cPatEmp() )
   end if

   synCount( cPatEmp() )

Return ( .t. )

//----------------------------------------------------------------------------//

FUNCTION mkCount( cPath, oMeter, nSemilla )

   DEFAULT cPath     := cPatEmp()

   if !lExistTable( cPath + "nCount.Dbf" )
      CreateFiles( cPath, oMeter, nSemilla )
   end if

   if !lExistIndex( cPath + "nCount.Cdx" )
      rxCount( cPath )
   end if

RETURN .t.

//--------------------------------------------------------------------------//

FUNCTION rxCount( cPath, oMeter )

   local n
   local dbf

   DEFAULT cPath  := cPatEmp()

   if !lExistTable( cPath + "nCount.Dbf" )
      CreateFiles( cPath, oMeter )
   end if

   // Comprobamos que los campos que tenemos son lo mismos q debemos tener--------

   dbUseArea( .t., cDriver(), cPath + "nCount.Dbf", cCheckArea( "nCount", @dbf ), .f. )

   if !( dbf )->( netErr() )
      
      n           := ( dbf )->( fCount() )
      
      ( dbf )->( dbCloseArea() )

      if n < len( aItmCount() )

         dbCreate( cPatEmpTmp() + "nCount.Dbf", aSqlStruct( aItmCount() ), cDriver() )
         appDbf( cPath, cPatEmpTmp(), "nCount" )

         fEraseTable( cPath + "nCount.Dbf" )
         fRenameTable( cPatEmpTmp() + "nCount.Dbf", cPath + "nCount.Dbf" )

      end if

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de contadores", "Reindexando contadores" )

      return nil

   end if

   fErase( cPath + "nCount.Cdx" )

   dbUseArea( .t., cDriver(), cPath + "nCount.Dbf", cCheckArea( "NCOUNT", @dbf ), .f. )

   if !( dbf )->( neterr() )

      ( dbf )->( __dbPack() )

      ( dbf )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbf )->( ordCreate( cPath + "nCount.Cdx", "Doc", "Upper( Doc )", {|| Upper( Field->Doc ) } ) )

      ( dbf )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbf )->( ordCreate( cPath + "nCount.Cdx", "Des", "Upper( Des )", {|| Upper( Field->Des ) } ) )

      ( dbf )->( ordCondSet( "!Deleted()", {|| !Deleted() } ) )
      ( dbf )->( ordCreate( cPath + "nCount.Cdx", "cCodDlg", "cCodDlg", {|| Field->cCodDlg } ) )

      ( dbf )->( dbCloseArea() )

   else

      msgStop( "Imposible abrir en modo exclusivo la tabla de contadores", "Reindexando contadores" )

   end if

Return ( nil )

//---------------------------------------------------------------------------//

Static Function CreateFiles( cPath, oMeter, nSemilla, cPathOld )

   DEFAULT cPath           := cPatEmp()
   DEFAULT nSemilla        := 1

   if !lExistTable( cPath + "nCount.Dbf" )
      dbCreate( cPath + "nCount.Dbf", aSqlStruct( aItmCount() ), cDriver() )
   end if

   rxCount( cPath )

Return nil

//--------------------------------------------------------------------------//

Function aItmCount()

   local aItmCount   := {}

   aAdd( aItmCount,  {  "cCodDlg", "C",  2, 0 } )
   aAdd( aItmCount,  {  "Doc",     "C", 10, 0 } )
   aAdd( aItmCount,  {  "Des",     "C", 30, 0 } )
   aAdd( aItmCount,  {  "lSerie",  "L",  1, 0 } )
   aAdd( aItmCount,  {  "cSerie",  "C",  1, 0 } )
   aAdd( aItmCount,  {  "A",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "B",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "C",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "D",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "E",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "F",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "G",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "H",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "I",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "J",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "K",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "L",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "M",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "N",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "O",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "P",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "Q",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "R",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "S",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "T",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "U",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "V",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "W",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "X",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "Y",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "Z",       "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasA", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasB", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasC", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasD", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasE", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasF", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasG", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasH", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasI", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasJ", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasK", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasL", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasM", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasN", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasO", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasP", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasQ", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasR", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasS", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasT", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasU", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasV", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasW", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasX", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasY", "N",  9, 0 } )
   aAdd( aItmCount,  {  "CopiasZ", "N",  9, 0 } )
   aAdd( aItmCount,  {  "lDoc",    "L",  1, 0 } )
   aAdd( aItmCount,  {  "DocA",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocB",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocC",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocD",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocE",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocF",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocG",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocH",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocI",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocJ",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocK",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocL",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocM",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocN",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocO",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocP",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocQ",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocR",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocS",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocT",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocU",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocV",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocW",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocX",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocY",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "DocZ",    "C",  3, 0 } )
   aAdd( aItmCount,  {  "cNFCA",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCB",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCC",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCD",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCE",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCF",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCG",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCH",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCI",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCJ",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCK",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCL",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCM",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCN",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCO",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCP",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCQ",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCR",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCS",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCT",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCU",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCV",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCW",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCX",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCY",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "cNFCZ",   "C", 20, 0 } )
   aAdd( aItmCount,  {  "nNFCA",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCB",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCC",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCD",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCE",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCF",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCG",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCH",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCI",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCJ",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCK",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCL",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCM",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCN",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCO",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCP",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCQ",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCR",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCS",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCT",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCU",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCV",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCW",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCX",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCY",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "nNFCZ",   "C",  9, 0 } )
   aAdd( aItmCount,  {  "lNFC",    "L",  1, 0 } )
   aAdd( aItmCount,  {  "lCon",    "L",  1, 0 } )
   aAdd( aItmCount,  {  "cPltDfl", "C",250, 0 } )

Return ( aItmCount )

//--------------------------------------------------------------------------//