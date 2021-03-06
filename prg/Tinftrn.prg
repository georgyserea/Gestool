#include "FiveWin.Ch"
#include "Font.ch"
#include "Factu.ch" 
#include "MesDbf.ch"

//---------------------------------------------------------------------------//

CLASS TInfTrn FROM TInfGen

   METHOD DetCreateFields()

   METHOD RentCreateFields()

   METHOD AnuTrnFields()

   METHOD AcuCreate()

   METHOD AddPre( lAcumula )

   METHOD AddPed( lAcumula )

   METHOD AddAlb( lAcumula )

   METHOD AddFac( lAcumula )

   METHOD AddFacRec( lAcumula )

   METHOD AddFacRecVta( lAcumula )

   METHOD AddRAlb()

   METHOD AddRFac()

   METHOD AddRFacRec()

   METHOD IncluyeCero()

   METHOD NewGroup()

   METHOD QuiGroup()

END CLASS

//---------------------------------------------------------------------------//

METHOD DetCreateFields()

   ::AddField ( "cCodTrn", "C",  9, 0, {|| "@!" },        "Cod. Trn.",                 .f., "C�d. transportista",           4, .f. )
   ::AddField ( "cNomTrn", "C", 50, 0, {|| "@!" },        "Transportista",             .f., "Transportista",               20, .f. )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },        "Cod. articulo",             .f., "Cod. art�culo",               10, .f. )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },        "Descripci�n",               .f., "Descripci�n",                 15, .f. )
   ::FldPropiedades()
   ::AddField ( "cLote",   "C", 14, 0, ,                  "Lote",                      .f., "N�mero de lote",              10, .f. )
   ::FldCliente()
   ::AddField ( "nNumCaj", "N", 16, 6, {|| MasUnd() },    cNombreCajas(),              .f., cNombreCajas(),                12, .t. )
   ::AddField ( "nUniDad", "N", 16, 6, {|| MasUnd() },    cNombreUnidades(),           .f., cNombreUnidades(),             12, .t. )
   ::AddField ( "nNumUni", "N", 16, 6, {|| MasUnd() },    "Tot. " + cNombreUnidades(), .t., "Total " + cNombreUnidades(),  12, .t. )
   ::AddField ( "nImpArt", "N", 16, 6, {|| ::cPicImp },   "Precio",                    .t., "Precio",                      12, .f. )
   ::AddField ( "nPntVer", "N", 16, 6, {|| ::cPicImp },   "Pnt. ver.",                 .f., "Punto verde",                 10, .f. )
   ::AddField ( "nImpTrn", "N", 16, 6, {|| ::cPicImp },   "Portes",                    .f., "Portes",                      10, .f. )
   ::AddField ( "nImpTot", "N", 16, 6, {|| ::cPicOut },   "Base",                      .t., "Base",                        12, .t. )
   ::AddField ( "nTotPes", "N", 16, 6, {|| MasUnd() },    "Tot. peso",                 .f., "Total peso",                  12, .t. )
   ::AddField ( "nPreKgr", "N", 16, 6, {|| ::cPicImp },   "Pre. Kg.",                  .f., "Precio kilo",                 12, .f. )
   ::AddField ( "nTotVol", "N", 16, 6, {|| MasUnd() },    "Tot. volumen",              .f., "Total volumen",               12, .t. )
   ::AddField ( "nPreVol", "N", 16, 6, {|| ::cPicImp },   "Pre. vol.",                 .f., "Precio volumen",              12, .f. )
   ::AddField ( "nIvaTot", "N", 16, 6, {|| ::cPicOut },   cImp(),                    .t., cImp(),                      12, .t. )
   ::AddField ( "nTotFin", "N", 16, 6, {|| ::cPicOut },   "Total",                     .t., "Total",                       12, .t. )
   ::AddField ( "cDocMov", "C", 14, 0, {|| "@!" },        "Doc.",                      .t., "Documento",                    8, .f. )
   ::AddField ( "cTipDoc", "C", 20, 0, {|| "@!" },        "Tipo",                      .f., "Tipo de documento",           10, .f. )
   ::AddField ( "dFecMov", "D",  8, 0, {|| "@!" },        "Fecha",                     .t., "Fecha",                       10, .f. )
   ::AddField ( "cTipVen", "C", 20, 0, {|| "@!" },        "Venta",                     .f., "Tipo de venta",               10, .f. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AnuTrnFields()


   ::AddField ( "cCodTrn", "C",  4, 0, {|| "@!" },         "Cod. Trn.",       .t., "C�d. Transportista",      4 )
   ::AddField ( "cNomTrn", "C", 50, 0, {|| "@!" },         "Transportista",   .t., "Transportista",          20 )
   ::AddField ( "nImpEne", "N", 16, 6, {|| ::cPicOut },    "Ene",             .t., "Enero",                  12 )
   ::AddField ( "nImpFeb", "N", 16, 6, {|| ::cPicOut },    "Feb",             .t., "Febrero",                12 )
   ::AddField ( "nImpMar", "N", 16, 6, {|| ::cPicOut },    "Mar",             .t., "Marzo",                  12 )
   ::AddField ( "nImpAbr", "N", 16, 6, {|| ::cPicOut },    "Abr",             .t., "Abril",                  12 )
   ::AddField ( "nImpMay", "N", 16, 6, {|| ::cPicOut },    "May",             .t., "Mayo",                   12 )
   ::AddField ( "nImpJun", "N", 16, 6, {|| ::cPicOut },    "Jun",             .t., "Junio",                  12 )
   ::AddField ( "nImpJul", "N", 16, 6, {|| ::cPicOut },    "Jul",             .t., "Julio",                  12 )
   ::AddField ( "nImpAgo", "N", 16, 6, {|| ::cPicOut },    "Ago",             .t., "Agosto",                 12 )
   ::AddField ( "nImpSep", "N", 16, 6, {|| ::cPicOut },    "Sep",             .t., "Septiembre",             12 )
   ::AddField ( "nImpOct", "N", 16, 6, {|| ::cPicOut },    "Oct",             .t., "Octubre",                12 )
   ::AddField ( "nImpNov", "N", 16, 6, {|| ::cPicOut },    "Nov",             .t., "Noviembre",              12 )
   ::AddField ( "nImpDic", "N", 16, 6, {|| ::cPicOut },    "Dic",             .t., "Diciembre",              12 )
   ::AddField ( "nImpTot", "N", 16, 6, {|| ::cPicOut },    "Tot",             .t., "Total",                  12 )
   ::AddField ( "nMedia",  "N", 16, 6, {|| ::cPicOut },    "Media",           .t., "Media",                  12 )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD RentCreateFields()

   ::AddField ( "cCodTrn", "C",  4, 0, {|| "@!" },       "Cod. Trn.",      .f., "C�d. Transportista",      4, .f. )
   ::AddField ( "cNomTrn", "C", 50, 0, {|| "@!" },       "Transportista",  .f., "Transportista",          20, .f. )
   ::AddField ( "cCodArt", "C", 18, 0, {|| "@!" },       "C�digo art�culo",      .f., "Codigo art�culo",        14, .f. )
   ::AddField ( "cNomArt", "C",100, 0, {|| "@!" },       "Descripci�n",    .f., "Descripci�n",            35, .f. )
   ::FldPropiedades()
   ::AddField ( "cLote",   "C", 14, 0, ,                 "Lote",           .f., "N�mero de lote",         10, .f. )
   ::FldCliente()
   ::AddField ( "nTotCaj", "N", 16, 6, {|| MasUnd() },   cNombreCajas(),   .f., cNombreCajas(),           12, .t. )
   ::AddField ( "nTotUni", "N", 16, 6, {|| MasUnd() },   cNombreUnidades(),.t., cNombreUnidades(),        12, .t. )
   ::AddField ( "nTotImp", "N", 16, 6, {|| ::cPicOut },  "Tot. importe",   .t., "Tot. importe",           12, .t. )
   ::AddField ( "nTotPes", "N", 16, 6, {|| MasUnd() },   "Tot. peso",      .f., "Total peso",             12, .t. )
   ::AddField ( "nPreKgr", "N", 16, 6, {|| ::cPicImp },  "Pre. Kg.",       .f., "Precio kilo",            12, .f. )
   ::AddField ( "nTotVol", "N", 16, 6, {|| MasUnd() },   "Tot. volumen",   .f., "Total volumen",          12, .t. )
   ::AddField ( "nPreVol", "N", 16, 6, {|| ::cPicImp },  "Pre. vol.",      .f., "Precio volumen",         12, .f. )
   ::AddField ( "nTotCos", "N", 16, 6, {|| ::cPicOut },  "Tot. costo",     .t., "Total costo",            12, .f. )
   ::AddField ( "nMarGen", "N", 16, 6, {|| ::cPicOut },  "Margen",         .t., "Margen",                 12, .f. )
   ::AddField ( "nDtoAtp", "N", 16, 6, {|| ::cPicOut },  "Dto. Atipico",   .f., "Importe dto. atipico",   12, .t. )
   ::AddField ( "nRenTab", "N", 16, 6, {|| ::cPicOut },  "%Rent.",         .t., "Rentabilidad",           12, .f. )
   ::AddField ( "nPreMed", "N", 16, 6, {|| ::cPicImp },  "Precio medio",   .f., "Precio medio",           12, .f. )
   ::AddField ( "nCosMed", "N", 16, 6, {|| ::cPicOut },  "Costo medio",    .t., "Costo medio",            12, .f. )
   ::AddField ( "cNumDoc", "C", 14, 0, {|| "@!" },       "Documento",      .t., "Documento",              12, .f. )
   ::AddField ( "cTipDoc", "C", 20, 0, {|| "@!" },       "Tip. Doc.",      .f., "Tipo de documento",      15, .f. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AcuCreate()

   ::AddField ( "cCodTrn", "C",  4, 0, {|| "@!" },           "Cod. Trn.",        .t., "C�d. Transportista" ,  4, .f. )
   ::AddField ( "cNomTrn", "C", 50, 0, {|| "@!" },           "Transportista",    .t., "Transportista"      , 20, .f. )
   ::AddField ( "nNumUni", "N", 16, 6, {|| MasUnd() },       cNombreUnidades(),  .t., cNombreUnidades()    , 12, .t. )
   ::AddField ( "nImpArt", "N", 16, 6, {|| ::cPicImp },      "Precio",           .f., "Precio"             , 12, .f. )
   ::AddField ( "nPntVer", "N", 16, 6, {|| ::cPicImp },      "Pnt. ver.",        .f., "Punto verde"        , 10, .f. )
   ::AddField ( "nImpTrn", "N", 16, 6, {|| ::cPicImp },      "Portes",           .f., "Portes"             , 10, .f. )
   ::AddField ( "nImpTot", "N", 16, 6, {|| ::cPicOut },      "Base",             .t., "Base"               , 12, .t. )
   ::AddField ( "nTotPes", "N", 16, 6, {|| MasUnd() },       "Tot. peso",        .f., "Total peso"         , 12, .t. )
   ::AddField ( "nPreKgr", "N", 16, 6, {|| ::cPicOut },      "Pre. Kg.",         .f., "Precio kilo"        , 12, .f. )
   ::AddField ( "nTotVol", "N", 16, 6, {|| MasUnd() },       "Tot. volumen",     .f., "Total volumen"      , 12, .t. )
   ::AddField ( "nPreVol", "N", 16, 6, {|| ::cPicImp },      "Pre. vol.",        .f., "Precio volumen"     , 12, .f. )
   ::AddField ( "nPreMed", "N", 16, 6, {|| ::cPicImp },      "Pre. Med.",        .t., "Precio medio"       , 12, .f. )
   ::AddField ( "nIvaTot", "N", 16, 6, {|| ::cPicOut },      "Tot. " + cImp(),   .t., "Total " + cImp()       , 12, .t. )
   ::AddField ( "nTotFin", "N", 16, 6, {|| ::cPicOut },      "Total",            .t., "Total"              , 12, .t. )

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddPre( lAcumula )

   DEFAULT lAcumula     := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oPreCliT:cCodTrn )

      ::oDbf:Append()

      ::oDbf:cCodTrn    := ::oPreCliT:cCodTrn
      ::oDbf:cNomTrn    := oRetFld( ::oDbf:cCodTrn, ::oDbfTrn:oDbf )
      ::oDbf:nNumUni    := nTotNPreCli( ::oPreCliL )
      ::oDbf:nImpArt    := nTotUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nIvaTot    := nIvaLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oPreCliL:cRef, nTotNPreCli( ::oPreCliL ), ::oDbf:nImpTot, .f. )

      if !lAcumula

         ::AddCliente( ::oPreCliT:cCodCli, ::oPreCliT, .f. )
         ::oDbf:cCodArt := ::oPreCliL:cRef
         ::oDbf:cNomArt := ::oPreCliL:cDetalle
         ::oDbf:cCodPr1 := ::oPreCliL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oPreCliL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oPreCliL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oPreCliL:cCodPr2 )
         ::oDbf:cValPr1 := ::oPreCliL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oPreCliL:cCodPr1 + ::oPreCliL:cValPr1 )
         ::oDbf:cValPr2 := ::oPreCliL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oPreCliL:cCodPr2 + ::oPreCliL:cValPr2 )
         ::oDbf:cLote   := ::oPreCliL:cLote
         ::oDbf:nNumCaj := ::oPreCliL:nCanPre
         ::oDbf:nUniDad := ::oPreCliL:nUniCaja
         ::oDbf:cDocMov := ::oPreCliL:cSerPre + "/" + lTrim( Str( ::oPreCliL:nNumPre ) ) + "/" + lTrim( ::oPreCliL:cSufPre )
         ::oDbf:dFecMov := ::oPreCliT:dFecPre

         if ::oDbfTvta:Seek( ::oPreCliL:cTipMov )
            ::oDbf:cTipVen := ::oDbfTvta:cDesMov
         end if

      end if

      ::oDbf:Save()

   else

      ::oDbf:Load()
      ::oDbf:nNumUni    += nTotNPreCli( ::oPreCliL )
      ::oDbf:nImpArt    += nTotUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLPreCli( ::oPreCliT:cAlias, ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nTotFin    += nIvaLPreCli( ::oPreCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oPreCliL:cRef, nTotNPreCli( ::oPreCliL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddPed( lAcumula )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oPedCliT:cCodTrn )

      ::oDbf:Append()

      ::oDbf:cCodTrn    := ::oPedCliT:cCodTrn
      ::oDbf:cNomTrn    := oRetFld( ::oDbf:cCodTrn, ::oDbfTrn:oDbf )
      ::oDbf:nNumUni    := nTotNPedCli( ::oPedCliL )
      ::oDbf:nImpArt    := nTotUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nIvaTot    := nIvaLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oPedCliL:cRef, nTotNPedCli( ::oPedCliL ), ::oDbf:nImpTot, .f. )

      if !lAcumula
         ::AddCliente( ::oPedCliT:cCodCli, ::oPedCliT, .f. )
         ::oDbf:cCodArt := ::oPedCliL:cRef
         ::oDbf:cNomArt := ::oPedCliL:cDetalle
         ::oDbf:cCodPr1 := ::oPedCliL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oPedCliL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oPedCliL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oPedCliL:cCodPr2 )
         ::oDbf:cValPr1 := ::oPedCliL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oPedCliL:cCodPr1 + ::oPedCliL:cValPr1 )
         ::oDbf:cValPr2 := ::oPedCliL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oPedCliL:cCodPr2 + ::oPedCliL:cValPr2 )
         ::oDbf:cLote   := ::oPedCliL:cLote
         ::oDbf:nNumCaj := ::oPedCliL:nCanPed
         ::oDbf:nUniDad := ::oPedCliL:nUniCaja
         ::oDbf:cDocMov := lTrim( ::oPedCliL:cSerPed ) + "/" + lTrim ( Str( ::oPedCliL:nNumPed ) ) + "/" + lTrim ( ::oPedCliL:cSufPed )
         ::oDbf:dFecMov := ::oPedCliT:dFecPed

         if ::oDbfTvta:Seek( ::oPedCliL:cTipMov )
            ::oDbf:cTipVen := ::oDbfTvta:cDesMov
         end if

      end if

   else

      ::oDbf:Load()
      ::oDbf:nNumUni    += nTotNPedCli( ::oPedCliL )
      ::oDbf:nImpArt    += nTotUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLPedCli( ::oPedCliT:cAlias, ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nTotFin    += nIvaLPedCli( ::oPedCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oPedCliL:cRef, nTotNPedCli( ::oPedCliL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddAlb( lAcumula )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oAlbCliT:cCodTrn )

      ::oDbf:Append()

      ::oDbf:cCodTrn    := ::oAlbCliT:cCodTrn
      ::oDbf:cNomTrn    := oRetFld( ::oDbf:cCodTrn, ::oDbfTrn:oDbf )
      ::oDbf:nNumUni    := nTotNAlbCli( ::oAlbCliL )
      ::oDbf:nImpArt    := nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nIvaTot    := nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .f. )

      if !lAcumula
         ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )
         ::oDbf:cCodArt := ::oAlbCliL:cRef
         ::oDbf:cNomArt := ::oAlbCliL:cDetalle
         ::oDbf:cCodPr1 := ::oAlbCliL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oAlbCliL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oAlbCliL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oAlbCliL:cCodPr2 )
         ::oDbf:cValPr1 := ::oAlbCliL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oAlbCliL:cCodPr1 + ::oAlbCliL:cValPr1 )
         ::oDbf:cValPr2 := ::oAlbCliL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oAlbCliL:cCodPr2 + ::oAlbCliL:cValPr2 )
         ::oDbf:cLote   := ::oAlbCliL:cLote
         ::oDbf:nNumCaj := ::oAlbCliL:nCanEnt
         ::oDbf:nUniDad := ::oAlbCliL:nUniCaja
         ::oDbf:cDocMov := ::oAlbCliL:cSerAlb + "/" + lTrim ( Str( ::oAlbCliL:nNumAlb ) ) + "/" + lTrim ( ::oAlbCliL:cSufAlb )
         ::oDbf:dFecMov := ::oAlbCliT:dFecAlb

         if ::oDbfTvta:Seek( ::oAlbCliL:cTipMov )
            ::oDbf:cTipVen := ::oDbfTvta:cDesMov
         end if

      end if

   else

      ::oDbf:Load()
      ::oDbf:nNumUni    += nTotNAlbCli( ::oAlbCliL )
      ::oDbf:nImpArt    += nTotUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nTotFin    += nIvaLAlbCli( ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oAlbCliL:cRef, nTotNAlbCli( ::oAlbCliL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFac( lAcumula )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oFacCliT:cCodTrn )

      ::oDbf:Append()

      ::oDbf:cCodTrn    := ::oFacCliT:cCodTrn
      ::oDbf:cNomTrn    := oRetFld( ::oDbf:cCodTrn, ::oDbfTrn:oDbf )
      ::oDbf:nNumUni    := nTotNFacCli( ::oFacCliL )
      ::oDbf:nImpArt    := nImpUFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nIvaTot    := nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .f. )

      if !lAcumula
         ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )
         ::oDbf:cCodArt := ::oFacCliL:cRef
         ::oDbf:cNomArt := ::oFacCliL:cDetalle
         ::oDbf:cCodPr1 := ::oFacCliL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oFacCliL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oFacCliL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oFacCliL:cCodPr2 )
         ::oDbf:cValPr1 := ::oFacCliL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oFacCliL:cCodPr1 + ::oFacCliL:cValPr1 )
         ::oDbf:cValPr2 := ::oFacCliL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oFacCliL:cCodPr2 + ::oFacCliL:cValPr2 )
         ::oDbf:cLote   := ::oFacCliL:cLote
         ::oDbf:nNumCaj := ::oFacCliL:nCanEnt
         ::oDbf:nUniDad := ::oFacCliL:nUniCaja
         ::oDbf:cDocMov := ::oFacCliL:cSerie + "/" + lTrim ( Str( ::oFacCliL:nNumFac ) ) + "/" + lTrim ( ::oFacCliL:cSufFac )
         ::oDbf:dFecMov := ::oFacCliT:dFecFac

         if ::oDbfTvta:Seek( ::oFacCliL:cTipMov )
            ::oDbf:cTipVen := ::oDbfTvta:cDesMov
         end if

      end if

   else

      ::oDbf:Load()
      ::oDbf:nNumUni    += nTotNFacCli( ::oFacCliL )
      ::oDbf:nImpArt    += nImpUFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nTotFin    += nIvaLFacCli( ::oFacCliL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oFacCliL:cRef, nTotNFacCli( ::oFacCliL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFacRec( lAcumula )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oFacRecT:cCodTrn )

      ::oDbf:Append()

      ::oDbf:cCodTrn    := ::oFacRecT:cCodTrn
      ::oDbf:cNomTrn    := oRetFld( ::oDbf:cCodTrn, ::oDbfTrn:oDbf )
      ::oDbf:nNumUni    := nTotNFacRec( ::oFacRecL )
      ::oDbf:nImpArt    := nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nIvaTot    := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .f. )

      if !lAcumula
         ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )
         ::oDbf:cCodArt := ::oFacRecL:cRef
         ::oDbf:cNomArt := ::oFacRecL:cDetalle
         ::oDbf:cCodPr1 := ::oFacRecL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oFacRecL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oFacRecL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oFacRecL:cCodPr2 )
         ::oDbf:cValPr1 := ::oFacRecL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oFacRecL:cCodPr1 + ::oFacRecL:cValPr1 )
         ::oDbf:cValPr2 := ::oFacRecL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oFacRecL:cCodPr2 + ::oFacRecL:cValPr2 )
         ::oDbf:cLote   := ::oFacRecL:cLote
         ::oDbf:nNumCaj := ::oFacRecL:nCanEnt
         ::oDbf:nUniDad := ::oFacRecL:nUniCaja
         ::oDbf:cDocMov := ::oFacRecL:cSerie + "/" + lTrim ( Str( ::oFacRecL:nNumFac ) ) + "/" + lTrim ( ::oFacRecL:cSufFac )
         ::oDbf:dFecMov := ::oFacRecT:dFecFac

         if ::oDbfTvta:Seek( ::oFacRecL:cTipMov )
            ::oDbf:cTipVen := ::oDbfTvta:cDesMov
         end if

      end if

   else

      ::oDbf:Load()
      ::oDbf:nNumUni    += nTotNFacRec( ::oFacRecL )
      ::oDbf:nImpArt    += nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nTotFin    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddFacRecVta( lAcumula )

   DEFAULT lAcumula  := .f.

   if !lAcumula .or. !::oDbf:Seek( ::oFacRecT:cCodTrn )

      ::oDbf:Append()

      ::oDbf:cCodTrn    := ::oFacRecT:cCodTrn
      ::oDbf:cNomTrn    := oRetFld( ::oDbf:cCodTrn, ::oDbfTrn:oDbf )
      ::oDbf:nNumUni    := nTotNFacRec( ::oFacRecL )
      ::oDbf:nImpArt    := nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    := nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    := nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    := nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nIvaTot    := nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    := ::oDbf:nImpTot + ::oDbf:nIvaTot

      ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .f. )

      if !lAcumula
         ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )
         ::oDbf:cCodArt := ::oFacRecL:cRef
         ::oDbf:cNomArt := ::oFacRecL:cDetalle
         ::oDbf:cCodPr1 := ::oFacRecL:cCodPr1
         ::oDbf:cNomPr1 := retProp( ::oFacRecL:cCodPr1 )
         ::oDbf:cCodPr2 := ::oFacRecL:cCodPr2
         ::oDbf:cNomPr2 := retProp( ::oFacRecL:cCodPr2 )
         ::oDbf:cValPr1 := ::oFacRecL:cValPr1
         ::oDbf:cNomVl1 := retValProp( ::oFacRecL:cCodPr1 + ::oFacRecL:cValPr1 )
         ::oDbf:cValPr2 := ::oFacRecL:cValPr2
         ::oDbf:cNomVl2 := retValProp( ::oFacRecL:cCodPr2 + ::oFacRecL:cValPr2 )
         ::oDbf:cLote   := ::oFacRecL:cLote
         ::oDbf:nNumCaj := ::oFacRecL:nCanEnt
         ::oDbf:nUniDad := ::oFacRecL:nUniCaja
         ::oDbf:cDocMov := ::oFacRecL:cSerie + "/" + lTrim ( Str( ::oFacRecL:nNumFac ) ) + "/" + lTrim ( ::oFacRecL:cSufFac )
         ::oDbf:dFecMov := ::oFacRecT:dFecFac

         if ::oDbfTvta:Seek( ::oFacRecL:cTipMov )
            ::oDbf:cTipVen := ::oDbfTvta:cDesMov
         end if

      end if

   else

      ::oDbf:Load()
      ::oDbf:nNumUni    += nTotNFacRec( ::oFacRecL )
      ::oDbf:nImpArt    += nImpUFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTrn    += nTrnUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nPntVer    += nPntUFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nValDiv )
      ::oDbf:nImpTot    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nPreMed    := ::oDbf:nImpTot / ::oDbf:nNumUni
      ::oDbf:nIvaTot    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )
      ::oDbf:nTotFin    += nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv, , , .t., .t.  )
      ::oDbf:nTotFin    += nIvaLFacRec( ::oFacRecL:cAlias, ::nDecOut, ::nDerOut, ::nValDiv )

      ::AcuPesVol( ::oFacRecL:cRef, nTotNFacRec( ::oFacRecL ), ::oDbf:nImpTot, .t. )

      ::oDbf:Save()

   end if

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddRAlb()

   local nTotUni
   local nTotImpUni
   local nTotCosUni
   local nImpDtoAtp

   /*
   Calculamos las cajas en vendidas entre dos fechas
   */

   nTotUni              := nTotNAlbCli( ::oAlbCliL:cAlias )
   nTotImpUni           := nImpLAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )
   nImpDtoAtp           := nDtoAtpAlbCli( ::oAlbCliT:cAlias, ::oAlbCliL:cAlias, ::nDecOut, ::nDerOut )

   if ::lCosAct .or. ::oAlbCliL:nCosDiv == 0
      nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oAlbCliL:cRef ) * nTotUni
   else
      nTotCosUni        := ::oAlbCliL:nCosDiv * nTotUni
   end if

   ::oDbf:Append()

   ::oDbf:cCodTrn    := ::oAlbCliT:cCodTrn
   ::oDbf:cNomTrn    := oRetFld( ::oDbf:cCodTrn, ::oDbfTrn:oDbf )
   ::oDbf:cCodArt    := ::oAlbCliL:cRef
   ::oDbf:cNomArt    := ::oAlbCliL:cDetalle
   ::oDbf:cCodPr1    := ::oAlbCliL:cCodPr1
   ::oDbf:cNomPr1    := retProp( ::oAlbCliL:cCodPr1 )
   ::oDbf:cCodPr2    := ::oAlbCliL:cCodPr2
   ::oDbf:cNomPr2    := retProp( ::oAlbCliL:cCodPr2 )
   ::oDbf:cValPr1    := ::oAlbCliL:cValPr1
   ::oDbf:cNomVl1    := retValProp( ::oAlbCliL:cCodPr1 + ::oAlbCliL:cValPr1 )
   ::oDbf:cValPr2    := ::oAlbCliL:cValPr2
   ::oDbf:cNomVl2    := retValProp( ::oAlbCliL:cCodPr2 + ::oAlbCliL:cValPr2 )
   ::oDbf:cLote      := ::oAlbCliL:cLote

   ::AddCliente( ::oAlbCliT:cCodCli, ::oAlbCliT, .f. )

   ::oDbf:nTotCaj    := ::oAlbCliL:nCanEnt
   ::oDbf:nTotUni    := nTotUni
   ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nPesoKg" )
   ::oDbf:nTotImp    := nTotImpUni
   ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
   ::oDbf:nTotVol    := ::oDbf:nTotUni * oRetFld( ::oAlbCliL:cRef, ::oDbfArt, "nVolumen" )
   ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
   ::oDbf:nTotCos    := nTotCosUni
   ::oDbf:nMargen    := nTotImpUni - nTotCosUni
   ::oDbf:nDtoAtp    := nImpDtoAtp

   if nTotUni != 0 .and. nTotCosUni != 0
      ::oDbf:nRentab := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
      ::oDbf:nPreMed := nTotImpUni / nTotUni
      ::oDbf:nCosMed := nTotCosUni / nTotUni
   else
      ::oDbf:nRentab := 0
      ::oDbf:nPreMed := 0
      ::oDbf:nCosMed := 0
   end if

   ::oDbf:cNumDoc    := ::oAlbCliL:cSerAlb + "/" + Alltrim( Str( ::oAlbCliL:nNumAlb ) ) + "/" + ::oAlbCliL:cSufAlb

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddRFac()

   local nTotUni
   local nTotImpUni
   local nTotCosUni
   local nImpDtoAtp

   /*
   Calculamos las cajas en vendidas entre dos fechas
   */

   nTotUni              := nTotNFacCli( ::oFacCliL:cAlias )
   nTotImpUni           := nImpLFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )
   nImpDtoAtp           := nDtoAtpFacCli( ::oFacCliT:cAlias, ::oFacCliL:cAlias, ::nDecOut, ::nDerOut )

   if ::lCosAct .or. ::oFacCliL:nCosDiv == 0
      nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oFacCliL:cRef ) * nTotUni
   else
      nTotCosUni        := ::oFacCliL:nCosDiv * nTotUni
   end if

   ::oDbf:Append()

   ::oDbf:cCodTrn    := ::oFacCliT:cCodTrn
   ::oDbf:cNomTrn    := oRetFld( ::oDbf:cCodTrn, ::oDbfTrn:oDbf )
   ::oDbf:cCodArt    := ::oFacCliL:cRef
   ::oDbf:cNomArt    := ::oFacCliL:cDetalle
   ::oDbf:cCodPr1    := ::oFacCliL:cCodPr1
   ::oDbf:cNomPr1    := retProp( ::oFacCliL:cCodPr1 )
   ::oDbf:cCodPr2    := ::oFacCliL:cCodPr2
   ::oDbf:cNomPr2    := retProp( ::oFacCliL:cCodPr2 )
   ::oDbf:cValPr1    := ::oFacCliL:cValPr1
   ::oDbf:cNomVl1    := retValProp( ::oFacCliL:cCodPr1 + ::oFacCliL:cValPr1 )
   ::oDbf:cValPr2    := ::oFacCliL:cValPr2
   ::oDbf:cNomVl2    := retValProp( ::oFacCliL:cCodPr2 + ::oFacCliL:cValPr2 )
   ::oDbf:cLote      := ::oFacCliL:cLote

   ::AddCliente( ::oFacCliT:cCodCli, ::oFacCliT, .f. )

   ::oDbf:nTotCaj    := ::oFacCliL:nCanEnt
   ::oDbf:nTotUni    := nTotUni
   ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nPesoKg" )
   ::oDbf:nTotImp    := nTotImpUni
   ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
   ::oDbf:nTotVol    := ::oDbf:nTotUni * oRetFld( ::oFacCliL:cRef, ::oDbfArt, "nVolumen" )
   ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
   ::oDbf:nTotCos    := nTotCosUni
   ::oDbf:nMargen    := nTotImpUni - nTotCosUni
   ::oDbf:nDtoAtp    := nImpDtoAtp

   if nTotUni != 0 .and. nTotCosUni != 0
      ::oDbf:nRentab := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
      ::oDbf:nPreMed := nTotImpUni / nTotUni
      ::oDbf:nCosMed := nTotCosUni / nTotUni
   else
      ::oDbf:nRentab := 0
      ::oDbf:nPreMed := 0
      ::oDbf:nCosMed := 0
   end if

   ::oDbf:cNumDoc    := ::oFacCliL:cSerie + "/" + Alltrim( Str( ::oFacCliL:nNumFac ) ) + "/" + ::oFacCliL:cSufFac

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD AddRFacRec()

   local nTotUni
   local nTotImpUni
   local nTotCosUni
   local nImpDtoAtp

   /*
   Calculamos las cajas en vendidas entre dos fechas
   */

   nTotUni              := -( nTotNFacRec( ::oFacRecL:cAlias ) )
   nTotImpUni           := -( nImpLFacRec( ::oFacRecT:cAlias, ::oFacRecL:cAlias, ::nDecOut, ::nDerOut ) )
   nImpDtoAtp           := 0

   if ::lCosAct .or. ::oFacRecL:nCosDiv == 0
      nTotCosUni        := nRetPreCosto( ::oDbfArt:cAlias, ::oFacRecL:cRef ) * nTotUni
   else
      nTotCosUni        := ::oFacRecL:nCosDiv * nTotUni
   end if

   ::oDbf:Append()

   ::oDbf:cCodTrn    := ::oFacRecT:cCodTrn
   ::oDbf:cNomTrn    := oRetFld( ::oDbf:cCodTrn, ::oDbfTrn:oDbf )
   ::oDbf:cCodArt    := ::oFacRecL:cRef
   ::oDbf:cNomArt    := ::oFacRecL:cDetalle
   ::oDbf:cCodPr1    := ::oFacRecL:cCodPr1
   ::oDbf:cNomPr1    := retProp( ::oFacRecL:cCodPr1 )
   ::oDbf:cCodPr2    := ::oFacRecL:cCodPr2
   ::oDbf:cNomPr2    := retProp( ::oFacRecL:cCodPr2 )
   ::oDbf:cValPr1    := ::oFacRecL:cValPr1
   ::oDbf:cNomVl1    := retValProp( ::oFacRecL:cCodPr1 + ::oFacRecL:cValPr1 )
   ::oDbf:cValPr2    := ::oFacRecL:cValPr2
   ::oDbf:cNomVl2    := retValProp( ::oFacRecL:cCodPr2 + ::oFacRecL:cValPr2 )
   ::oDbf:cLote      := ::oFacRecL:cLote

   ::AddCliente( ::oFacRecT:cCodCli, ::oFacRecT, .f. )

   ::oDbf:nTotCaj    := ::oFacRecL:nCanEnt
   ::oDbf:nTotUni    := nTotUni
   ::oDbf:nTotPes    := ::oDbf:nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nPesoKg" )
   ::oDbf:nTotImp    := nTotImpUni
   ::oDbf:nPreKgr    := if( ::oDbf:nTotPes != 0, ::oDbf:nTotImp / ::oDbf:nTotPes, 0 )
   ::oDbf:nTotVol    := ::oDbf:nTotUni * oRetFld( ::oFacRecL:cRef, ::oDbfArt, "nVolumen" )
   ::oDbf:nPreVol    := if( ::oDbf:nTotVol != 0, ::oDbf:nTotImp / ::oDbf:nTotVol, 0 )
   ::oDbf:nTotCos    := nTotCosUni
   ::oDbf:nMargen    := nTotImpUni - nTotCosUni
   ::oDbf:nDtoAtp    := nImpDtoAtp

   if nTotUni != 0 .and. nTotCosUni != 0
      ::oDbf:nRentab := nRentabilidad( nTotImpUni, nImpDtoAtp, nTotCosUni )
      ::oDbf:nPreMed := nTotImpUni / nTotUni
      ::oDbf:nCosMed := nTotCosUni / nTotUni
   else
      ::oDbf:nRentab := 0
      ::oDbf:nPreMed := 0
      ::oDbf:nCosMed := 0
   end if

   ::oDbf:cNumDoc    := ::oFacRecL:cSerie + "/" + Alltrim( Str( ::oFacRecL:nNumFac ) ) + "/" + ::oFacRecL:cSufFac

   ::oDbf:Save()

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD IncluyeCero()

   /*
   Repaso de todas los transportistas------------------------------------------
   */

   ::oDbfTrn:oDbf:GoTop()
   while !::oDbfTrn:oDbf:Eof()

      if ( ::lAllTrn .or. ( ::oDbfTrn:oDbf:cCodTrn >= ::cTrnOrg .AND. ::oDbfTrn:oDbf:cCodTRn <= ::cTrnDes ) ) .AND.;
         !::oDbf:Seek( ::oDbfTrn:oDbf:cCodTrn )

         ::oDbf:Append()
         ::oDbf:Blank()
         ::oDbf:cCodTrn    := ::oDbfTrn:oDbf:cCodTrn
         ::oDbf:cNomTrn    := ::oDbfTrn:oDbf:cNomTrn
         ::oDbf:Save()

      end if

      ::oDbfTrn:oDbf:Skip()

   end while

RETURN ( self )

//---------------------------------------------------------------------------//

METHOD NewGroup( lDesPrp )

   if lDesPrp
      ::AddGroup( {|| ::oDbf:cCodTrn + ::oDbf:cCodArt + ::oDbf:cCodPr1 + ::oDbf:cCodPr2 + ::oDbf:cValPr1 + ::oDbf:cValPr2 + ::oDbf:cLote },;
      {||   if( !Empty( ::oDbf:cValPr1 ), AllTrim( ::oDbf:cNomPr1 ) + ": " + AllTrim( ::oDbf:cNomVl1 ) + " - ", "" ) + ;
            if( !Empty( ::oDbf:cValPr2 ), AllTrim( ::oDbf:cNomPr2 ) + ": " + AllTrim( ::oDbf:cNomVl2 ) + " - ", "" ) + ;
            if( !Empty( ::oDbf:cLote ), "Lote:" + AllTrim( ::oDbf:cLote ), Space(1) ) },;
      {|| Space(1) } )
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//

METHOD QuiGroup( lDesPrp )

   if lDesPrp
      ::DelGroup()
   end if

RETURN ( Self )

//---------------------------------------------------------------------------//