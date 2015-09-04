#include "FiveWin.Ch"
#include "Factu.ch" 

CLASS DirectionsViewSearchNavigator FROM ViewSearchNavigator

   METHOD setItemsBusqueda()           INLINE ( ::aItemsBusqueda := { "C�digo", "Nombre" } )

   METHOD setColumns()

   METHOD botonesAcciones()            INLINE ( self )

   METHOD validBarraBusqueda()         INLINE ( ::oSender:oSender:FilterDirections() )

END CLASS

//---------------------------------------------------------------------------//

METHOD setColumns() CLASS DirectionsViewSearchNavigator

   ::setBrowseConfigurationName( "Grid direcciones" )

   with object ( ::addColumn() )
      :cHeader          := "Cliente"
      :bEditValue       := {|| ( D():ClientesDirecciones( ::getView() ) )->cCodCli }
      :nWidth           := 200
   end with

   with object ( ::addColumn() )
      :cHeader          := "Direcci�n"
      :bEditValue       := {|| ( ( D():ClientesDirecciones( ::getView() ) )->cCodObr + CRLF + ( D():ClientesDirecciones( ::getView() ) )->cNomObr )  }
      :nWidth           := 900
   end with

Return ( self )

//---------------------------------------------------------------------------//