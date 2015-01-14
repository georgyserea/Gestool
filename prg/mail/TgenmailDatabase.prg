#include "FiveWin.Ch"
#include "Factu.ch" 

//--------------------------------*-------------------------------------------//

CLASS TGenMailingDatabase FROM TGenMailing 

   DATA oFilter

   DATA oBrwDatabase

   DATA oBntCreateFilter
   DATA oBntQuitFilter

   DATA cBmpDatabase
   METHOD setBmpDatabase( cBmpDatabase )  INLINE   ( ::cBmpDatabase := cBmpDatabase )

   DATA oOrderDatabase 
   DATA cOrderDatabase 
   DATA aOrderDatabase                    INIT     { "C�digo", "Nombre", "Correo electr�nico" }

   METHOD buildPageDatabase( oDlg )
   METHOD columnPageDatabase( oDlg )   
   METHOD selectColumn( oCombo )
   METHOD freeResources() 

   METHOD selMailing()
   METHOD selAllMailing()

   METHOD getDatabaseList()              
   METHOD addDatabaseList()               INLINE   ( iif( ( ::getWorkArea() )->lMail .and. !empty( ( ::getWorkArea() )->cMeiInt ),;
                                                      aAdd( ::aMailingList, ::hashDatabaseList() ),;
                                                   ) )
   METHOD hashDatabaseList()        

   METHOD dialogFilter()
      METHOD buildFilter()
      METHOD quitFilter()

   METHOD setOrderDatabase( aOrderDatabase ) ;
                                          INLINE   ( ::aOrderDatabase := aOrderDatabase )

END CLASS

//---------------------------------------------------------------------------//

METHOD buildPageDatabase( oDlg, aCbxOrd ) CLASS TGenMailingDatabase

   local oGetOrd
   local cGetOrd     := Space( 100 )
   local oCbxOrd
   local cCbxOrd  

   ::cOrderDatabase  := ::aOrderDatabase[ 1 ]

   REDEFINE BITMAP   ::oBmpDatabase ;
      ID             500 ;
      RESOURCE       ::cBmpDatabase ;
      TRANSPARENT ;
      OF             oDlg

   REDEFINE GET      oGetOrd ;
      VAR            cGetOrd;
      ID             100 ;
      BITMAP         "FIND" ;
      OF             oDlg

   oGetOrd:bChange   := {| nKey, nFlags, oGet | AutoSeek( nKey, nFlags, oGet, ::oBrwDatabase, ::getWorkArea() ) }

   REDEFINE COMBOBOX ::oOrderDatabase ;
      VAR            ::cOrderDatabase ;
      ID             110 ;
      ITEMS          ::aOrderDatabase ;
      OF             oDlg

   ::oOrderDatabase:bChange   := {|| ::selectColumn() }

   REDEFINE BUTTON ;
      ID             130 ;
      OF             oDlg ;
      ACTION         ( ::selMailing() )

   REDEFINE BUTTON ;
      ID             140 ;
      OF             oDlg ;
      ACTION         ( ::selAllMailing( .t. ) )

   REDEFINE BUTTON ;
      ID             150 ;
      OF             oDlg ;
      ACTION         ( ::selAllMailing( .f. ) )

   REDEFINE BUTTON ::oBntCreateFilter ;
      ID             170 ;
      OF             oDlg ;
      ACTION         ( ::dialogFilter() )

   ::oBntQuitFilter  := TBtnBmp():ReDefine( 180, "Del16", , , , , {|| ::quitFilter() }, oDlg, .f., , .f., "Quitar filtro" )

   // Browse-------------------------------------------------------------------

   ::oBrwDatabase                 := IXBrowse():New( oDlg )

   ::oBrwDatabase:bClrSel         := {|| { CLR_BLACK, Rgb( 229, 229, 229 ) } }
   ::oBrwDatabase:bClrSelFocus    := {|| { CLR_BLACK, Rgb( 167, 205, 240 ) } }

   ::oBrwDatabase:cAlias          := ::getWorkArea()

   ::oBrwDatabase:nMarqueeStyle   := 5

   ::oBrwDatabase:CreateFromResource( 160 )

   ::oBrwDatabase:bLDblClick      := {|| ::SelMailing() }

   // A�ade las columnas-------------------------------------------------------

   ::columnPageDatabase( oDlg )

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD columnPageDatabase( oDlg ) CLASS TGenMailingDatabase

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "Se. seleccionado"
      :bStrData         := {|| "" }
      :bEditValue       := {|| ( ::getWorkArea() )->lMail }
      :nWidth           := 20
      :SetCheck( { "Sel16", "Nil16" } )
   end with

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "C�digo"
      :cSortOrder       := "Cod"
      :bEditValue       := {|| ( ::getWorkArea() )->Cod }
      :nWidth           := 70
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oOrderDatabase:Set( oCol:cHeader ) }
   end with

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "Nombre"
      :cSortOrder       := "Titulo"
      :bEditValue       := {|| ( ::getWorkArea() )->Titulo }
      :nWidth           := 300
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oOrderDatabase:Set( oCol:cHeader ) }
   end with

   with object ( ::oBrwDatabase:AddCol() )
      :cHeader          := "Correo electr�nico"
      :cSortOrder       := "cMeiInt"
      :bEditValue       := {|| ( ::getWorkArea() )->cMeiInt }
      :nWidth           := 260
      :bLClickHeader    := {| nMRow, nMCol, nFlags, oCol | ::oOrderDatabase:Set( oCol:cHeader ) }
   end with

Return ( Self )   

//---------------------------------------------------------------------------//

METHOD selectColumn() CLASS TGenMailingDatabase

   local oCol
   local cOrd                

   if empty(::oBrwDatabase)
      Return ( Self )
   end if

   cOrd                       := ::oOrderDatabase:VarGet()

   with object ::oBrwDatabase

      for each oCol in :aCols

         if Equal( cOrd, oCol:cHeader )
            oCol:cOrder       := "A"
            oCol:SetOrder()
         else
            oCol:cOrder       := " "
         end if

      next

   end with

   ::oBrwDatabase:Refresh()

Return ( Self )

//---------------------------------------------------------------------------//

METHOD selMailing( lValue ) CLASS TGenMailingDatabase

   DEFAULT lValue       := !( ::getWorkArea() )->lMail

   if dbDialogLock( ::getWorkArea() )
      ( ::getWorkArea() )->lMail   := lValue
      ( ::getWorkArea() )->( dbUnlock() )
   end if

   ::oBrwDatabase:Refresh()
   ::oBrwDatabase:SetFocus()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD selAllMailing( lValue ) CLASS TGenMailingDatabase

   local nRecord

   DEFAULT lValue  := .t.

	CursorWait()

   nRecord         := ( ::getWorkArea() )->( recno() )
   ( ::getWorkArea() )->( dbeval( {|| ::selMailing( lValue ) } ) )
   ( ::getWorkArea() )->( dbgoto( nRecord ) )

	CursorArrow()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD getDatabaseList() CLASS TGenMailingDatabase

   local nRecord

   CursorWait()

   ::aMailingList    := {}
   
   nRecord           := ( ::getWorkArea() )->( recno() )
   ( ::getWorkArea() )->( dbeval( {|| ::addDatabaseList() } ) )
   ( ::getWorkArea() )->( dbgoto( nRecord ) )

   CursorArrow()

Return ( ::aMailingList )

//--------------------------------------------------------------------------//

METHOD hashDatabaseList() CLASS TGenMailingDatabase

   local hashDatabaseList := {=>}

   hSet( hashDatabaseList, "mail", alltrim( ( ::getWorkArea() )->cMeiInt ) )
   hSet( hashDatabaseList, "mailcc", ::cGetCopia )
   hSet( hashDatabaseList, "subject", ::cSubject )
   hSet( hashDatabaseList, "attachments", ::cGetAdjunto )
   hSet( hashDatabaseList, "message", ::getMessageHTML() )

Return ( hashDatabaseList )

//---------------------------------------------------------------------------//

METHOD freeResources() CLASS TGenMailingDatabase

   ::Super:freeResources()

   if !empty(::oBmpDatabase)
      ::oBmpDatabase:end()
   end if 

   if !empty(::oFilter)
      ::oFilter:end()
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD dialogFilter() CLASS TGenMailingDatabase

   ::oFilter:Dialog()

   if !empty( ::oFilter:cExpresionFilter )
      ::buildFilter()
   else
      ::quitFilter()
   end if

Return ( Self )

//--------------------------------------------------------------------------//

METHOD buildFilter()

   createFastFilter( ::oFilter:cExpresionFilter, ::getWorkArea(), .f. )

   ::oBntCreateFilter:setText( "&Filtro activo" )

   ::oBntQuitFilter:Show()

   ::oBrwDatabase:Refresh()

Return ( Self )

//--------------------------------------------------------------------------//

METHOD quitFilter() CLASS TGenMailingDatabase

   destroyFastFilter( ::getWorkArea() )

   ::oBntCreateFilter:setText( "&Filtro" )

   ::oBntQuitFilter:Hide()

   ::oBrwDatabase:Refresh()

Return ( Self )

//--------------------------------------------------------------------------//
