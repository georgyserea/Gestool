#include "hbclass.ch"

#define CRLF chr( 13 ) + chr( 10 )

//---------------------------------------------------------------------------//

Function Inicio()

   local oFacturasClientesRisi

   oFacturasClientesRisi    := FacturasClientesRisi():New()

Return ( nil )

//---------------------------------------------------------------------------//

CREATE CLASS FacturasClientesRisi

   DATA nView

   DATA oUve

   DATA oFtp

   DATA hProducto

   DATA dInicio            INIT  ( BoM( Date() ) ) 
   DATA dFin               INIT  ( EoM( Date() ) ) 

   CLASSDATA aProductos    INIT  {  { "Codigo" => "V001004", "Nombre" => "GUSANITOS 35 g x 30 u",                   "Codigo unidades" => "8411859550103",     "Codigo cajas" => "18411859550100" },;
                                    { "Codigo" => "V001005", "Nombre" => "GUSANITOS  KETCHUP 35 g x 30 u",          "Codigo unidades" => "8411859550110",     "Codigo cajas" => "18411859550117" },;
                                    { "Codigo" => "V001007", "Nombre" => "GUSANITOS 18 g x 40 u",                   "Codigo unidades" => "8411859550134",     "Codigo cajas" => "18411859550131" },;
                                    { "Codigo" => "V001009", "Nombre" => "GUSANITOS KETCHUP 85 g x 8 u",            "Codigo unidades" => "8411859553258",     "Codigo cajas" => "18411859553255" },;
                                    { "Codigo" => "V001010", "Nombre" => "GUSANITOS 85 g x 8 u",                    "Codigo unidades" => "8411859553180",     "Codigo cajas" => "18411859553187" },;
                                    { "Codigo" => "V001012", "Nombre" => "GUSANITOS 85 g x 16 u",                   "Codigo unidades" => "8411859553180",     "Codigo cajas" => "28411859553184" },;
                                    { "Codigo" => "V002010", "Nombre" => "TEJITAS 35 g x 30 u",                     "Codigo unidades" => "8411859550233",     "Codigo cajas" => "18411859550230" },;
                                    { "Codigo" => "V002011", "Nombre" => "TEJITAS 100 g. x 8 u.",                   "Codigo unidades" => "8411859553111",     "Codigo cajas" => "18411859553118" },;
                                    { "Codigo" => "V003002", "Nombre" => "SURTIS 35 g x 30 u",                      "Codigo unidades" => "8411859550097",     "Codigo cajas" => "18411859550094" },;
                                    { "Codigo" => "V003005", "Nombre" => "SURTIS 4U 37 g x 40 u",                   "Codigo unidades" => "8411859550080",     "Codigo cajas" => "18411859550087" },;
                                    { "Codigo" => "V003007", "Nombre" => "SURTIS 4U 37  G. x 30 u.",                "Codigo unidades" => "8411859550080",     "Codigo cajas" => "38411859550081" },;
                                    { "Codigo" => "V003009", "Nombre" => "SURTIS TOTAL 30 G. x 25 U.",              "Codigo unidades" => "8411859550264",     "Codigo cajas" => "18411859550261" },;
                                    { "Codigo" => "V004001", "Nombre" => "PALOMITAS 35 g x 30 u",                   "Codigo unidades" => "8411859550073",     "Codigo cajas" => "18411859550070" },;
                                    { "Codigo" => "V004002", "Nombre" => "PALOMITAS KET-MOSTAZA 35gx30 u",          "Codigo unidades" => "8411859550561",     "Codigo cajas" => "18411859550568" },;
                                    { "Codigo" => "V004003", "Nombre" => "PALOMITAS XTRA SABOR 35g x 30u",          "Codigo unidades" => "8411859550554",     "Codigo cajas" => "18411859550551" },;
                                    { "Codigo" => "V004005", "Nombre" => "PALOMITAS 90 g x 8 u",                    "Codigo unidades" => "8411859553173",     "Codigo cajas" => "18411859553170" },;
                                    { "Codigo" => "V004009", "Nombre" => "PALOMITAS KET-MOSTAZA 90gx8 u",           "Codigo unidades" => "8411859553265",     "Codigo cajas" => "18411859553262" },;
                                    { "Codigo" => "V004011", "Nombre" => "PALOMITAS CHOCOLATE 30 g x40 u",          "Codigo unidades" => "8411859550578",     "Codigo cajas" => "18411859550575" },;
                                    { "Codigo" => "V004012", "Nombre" => "PALOMITAS  CHOC.BLANCO 30gx40u",          "Codigo unidades" => "8411859550585",     "Codigo cajas" => "18411859550582" },;
                                    { "Codigo" => "V004013", "Nombre" => "PALOMITAS CHOC.BLANCO 120gx16u",          "Codigo unidades" => "8411859553241",     "Codigo cajas" => "18411859553248" },;
                                    { "Codigo" => "V004014", "Nombre" => "PALOMITAS CHOCOLATE 120 g x16u",          "Codigo unidades" => "8411859553234",     "Codigo cajas" => "18411859553231" },;
                                    { "Codigo" => "V004016", "Nombre" => "PALOMITAS 90 g x 16 u.",                  "Codigo unidades" => "8411859553173",     "Codigo cajas" => "28411859553177" },;
                                    { "Codigo" => "V004017", "Nombre" => "PALOMITAS KET.MOSTAZ.90g x 16u",          "Codigo unidades" => "8411859553265",     "Codigo cajas" => "28411859553269" },;
                                    { "Codigo" => "V004018", "Nombre" => "LINKS 30 g x 30 u.",                      "Codigo unidades" => "8411859550639",     "Codigo cajas" => "18411859550636" },;
                                    { "Codigo" => "V004019", "Nombre" => "LINKS 140 g x 15 u.",                     "Codigo unidades" => "8411859553531",     "Codigo cajas" => "18411859553538" },;
                                    { "Codigo" => "V004020", "Nombre" => "LINKS 95 g x 16 u.",                      "Codigo unidades" => "8411859553524",     "Codigo cajas" => "18411859553521" },;
                                    { "Codigo" => "V004024", "Nombre" => "PALOMIT.SABOR RISKET.105 G x12",          "Codigo unidades" => "8411859553371",     "Codigo cajas" => "18411859553378" },;
                                    { "Codigo" => "V004025", "Nombre" => "LINKS 95 +RISKETOS 40 x 12 u.",           "Codigo unidades" => "8411859553524",     "Codigo cajas" => "88411859553520" },;
                                    { "Codigo" => "V006001", "Nombre" => "TRISKY 20 g x 70 u",                      "Codigo unidades" => "8411859551087",     "Codigo cajas" => "18411859551084" },;
                                    { "Codigo" => "V006002", "Nombre" => "TRISKY 35 g x 40 u",                      "Codigo unidades" => "8411859551124",     "Codigo cajas" => "18411859551121" },;
                                    { "Codigo" => "V006006", "Nombre" => "TRISKYS 85 g x 28 u",                     "Codigo unidades" => "8411859553159",     "Codigo cajas" => "18411859553156" },;
                                    { "Codigo" => "V006007", "Nombre" => "TRISKYS JAMON 35 g x 40 u",               "Codigo unidades" => "8411859551117",     "Codigo cajas" => "18411859551114" },;
                                    { "Codigo" => "V006010", "Nombre" => "TRISKYS 115 g x 16 u",                    "Codigo unidades" => "8411859553074",     "Codigo cajas" => "18411859553071" },;
                                    { "Codigo" => "V006011", "Nombre" => "TRISKYS JAMON 115 g X 16 u",              "Codigo unidades" => "8411859553401",     "Codigo cajas" => "18411859553408" },;
                                    { "Codigo" => "V006013", "Nombre" => "TRISKYS 115 g x 24 u",                    "Codigo unidades" => "8411859553074",     "Codigo cajas" => "28411859553078" },;
                                    { "Codigo" => "V007001", "Nombre" => "PAJITAS 20 g x 40 u",                     "Codigo unidades" => "8411859551001",     "Codigo cajas" => "18411859551008" },;
                                    { "Codigo" => "V007002", "Nombre" => "PAJITAS KETCHUP 12 g x 60 u",             "Codigo unidades" => "8411859551018",     "Codigo cajas" => "18411859551015" },;
                                    { "Codigo" => "V007004", "Nombre" => "PAJITAS KETCHUP 20 g x 40 u",             "Codigo unidades" => "8411859552244",     "Codigo cajas" => "18411859552241" },;
                                    { "Codigo" => "V007015", "Nombre" => "PAJITAS KET 20G +TRIDENTx 20 U",          "Codigo unidades" => "8411859551179",     "Codigo cajas" => "18411859551176" },;
                                    { "Codigo" => "V008005", "Nombre" => "RISKETOS 40 g x 40 u",                    "Codigo unidades" => "8411859552756",     "Codigo cajas" => "18411859552753" },;
                                    { "Codigo" => "V008007", "Nombre" => "RISKETOS KETCHUP 40 g x 40 u",            "Codigo unidades" => "8411859551056",     "Codigo cajas" => "18411859551053" },;
                                    { "Codigo" => "V008010", "Nombre" => "RISKETOS 120 g x 16 u.",                  "Codigo unidades" => "8411859553081",     "Codigo cajas" => "18411859553088" },;
                                    { "Codigo" => "V008013", "Nombre" => "RISKETOS LIGHT 105 g x 16 u",             "Codigo unidades" => "8411859553098",     "Codigo cajas" => "18411859553095" },;
                                    { "Codigo" => "V008015", "Nombre" => "RISKETOS 80 g x 28 u.",                   "Codigo unidades" => "8411859554606",     "Codigo cajas" => "18411859554603" },;
                                    { "Codigo" => "V008018", "Nombre" => "RISKETOS 80 g x 30 u.",                   "Codigo unidades" => "8411859554606",     "Codigo cajas" => "28411859554600" },;
                                    { "Codigo" => "V008019", "Nombre" => "RISKETOS 120 g x 24 u.",                  "Codigo unidades" => "8411859553081",     "Codigo cajas" => "28411859553085" },;
                                    { "Codigo" => "V008022", "Nombre" => "RISKETOS40+LINKS12 8 tirasx14u",          "Codigo unidades" => "8411859551438",     "Codigo cajas" => "18411859551435" },;
                                    { "Codigo" => "V016002", "Nombre" => "FRITOS KETCHUP 25 g x 40 u",              "Codigo unidades" => "8411859551261",     "Codigo cajas" => "18411859551268" },;
                                    { "Codigo" => "V017001", "Nombre" => "CUCURUCHIS 25 g x 40 u",                  "Codigo unidades" => "8411859552855",     "Codigo cajas" => "18411859552852" },;
                                    { "Codigo" => "V018001", "Nombre" => "RISIBOL 110 g x 8 u",                     "Codigo unidades" => "8411859553340",     "Codigo cajas" => "18411859553347" },;
                                    { "Codigo" => "V018002", "Nombre" => "TAPITAS 100 g x 8 u",                     "Codigo unidades" => "8411859553128",     "Codigo cajas" => "18411859553125" },;
                                    { "Codigo" => "V018003", "Nombre" => "SURTIS 100 g x 8 u",                      "Codigo unidades" => "8411859553104",     "Codigo cajas" => "18411859553101" },;
                                    { "Codigo" => "V018008", "Nombre" => "BUSCALIOS BBQ 110 g x 16 u",              "Codigo unidades" => "8411859553296",     "Codigo cajas" => "18411859553293" },;
                                    { "Codigo" => "V018010", "Nombre" => "PAJITAS KETCHUP 100 g x 9 u",             "Codigo unidades" => "8411859553500",     "Codigo cajas" => "18411859553507" },;
                                    { "Codigo" => "V018011", "Nombre" => "FRITOS PAPRIKA 95 g x 16 u",              "Codigo unidades" => "8411859553517",     "Codigo cajas" => "18411859553514" },;
                                    { "Codigo" => "V018012", "Nombre" => "PAJITAS DE PATATA 100 g.x 9 u",           "Codigo unidades" => "8411859553395",     "Codigo cajas" => "18411859553392" },;
                                    { "Codigo" => "V018013", "Nombre" => "SURTIS 4U 110 g  x 16 u",                 "Codigo unidades" => "8411859553418",     "Codigo cajas" => "18411859553415" },;
                                    { "Codigo" => "V018014", "Nombre" => "BUSCALIOS BBQ 140 g x 12 u.",             "Codigo unidades" => "8411859553425",     "Codigo cajas" => "18411859553422" },;
                                    { "Codigo" => "V018016", "Nombre" => "MATCHBALL 90 g x 12 u.",                  "Codigo unidades" => "8411859553210",     "Codigo cajas" => "18411859553217" },;
                                    { "Codigo" => "V018017", "Nombre" => "SURTIS TOTAL 70 G x 12 u.",               "Codigo unidades" => "8411859553432",     "Codigo cajas" => "18411859553439" },;
                                    { "Codigo" => "V022006", "Nombre" => "PATATAS ONDULADAS 50 g x 20 u",           "Codigo unidades" => "8411859554507",     "Codigo cajas" => "18411859554504" },;
                                    { "Codigo" => "V022007", "Nombre" => "PATATAS ONDUL.JAMON 50 g x 20u",          "Codigo unidades" => "8411859554514",     "Codigo cajas" => "18411859554511" },;
                                    { "Codigo" => "V022008", "Nombre" => "PATATAS CASERAS 50 g x 20 u",             "Codigo unidades" => "8411859554521",     "Codigo cajas" => "18411859554528" },;
                                    { "Codigo" => "V022014", "Nombre" => "PATATAS OND.CAMPESINA 50 G X20",          "Codigo unidades" => "8411859554538",     "Codigo cajas" => "18411859554535" },;
                                    { "Codigo" => "V023001", "Nombre" => "CORAZONCITOS 25 g x 40 u",                "Codigo unidades" => "8411859551353",     "Codigo cajas" => "18411859551350" },;
                                    { "Codigo" => "V025001", "Nombre" => "ONDULADAS ORIGINALES 100gX8 u",           "Codigo unidades" => "8411859553012",     "Codigo cajas" => "18411859553019" },;
                                    { "Codigo" => "V025002", "Nombre" => "PATATAS CASERAS 100 g x 8 u",             "Codigo unidades" => "8411859553050",     "Codigo cajas" => "18411859553057" },;
                                    { "Codigo" => "V025006", "Nombre" => "PATATAS ONDUL.JAMON 100 g x 8u",          "Codigo unidades" => "8411859553029",     "Codigo cajas" => "18411859553026" },;
                                    { "Codigo" => "V025010", "Nombre" => "PATATAS CASERAS B.PAPEL 120X8u",          "Codigo unidades" => "8411859553043",     "Codigo cajas" => "18411859553040" },;
                                    { "Codigo" => "V025012", "Nombre" => "PATATAS CASERAS 30 g x 35 u",             "Codigo unidades" => "8411859552114",     "Codigo cajas" => "18411859552111" },;
                                    { "Codigo" => "V025013", "Nombre" => "PATATAS O.CAMPESINA 30g.x 35 u",          "Codigo unidades" => "8411859552176",     "Codigo cajas" => "18411859552173" },;
                                    { "Codigo" => "V025014", "Nombre" => "PATATAS OND.IBERICOS 100g x 8u",          "Codigo unidades" => "8411859553036",     "Codigo cajas" => "18411859553033" },;
                                    { "Codigo" => "V025017", "Nombre" => "PATATAS ONDULADAS 30 g. x 35 u",          "Codigo unidades" => "8411859552152",     "Codigo cajas" => "18411859552159" },;
                                    { "Codigo" => "V025018", "Nombre" => "PATATAS OND.JAMON 30 g. x 35 u",          "Codigo unidades" => "8411859552169",     "Codigo cajas" => "18411859552166" },;
                                    { "Codigo" => "V025023", "Nombre" => "PATATAS O.CAMPESINA 100g.x 8 u",          "Codigo unidades" => "8411859553005",     "Codigo cajas" => "18411859553002" },;
                                    { "Codigo" => "V025024", "Nombre" => "PATATA FRITA ARTESANA 90gx12u",           "Codigo unidades" => "8411859553326",     "Codigo cajas" => "18411859553323" },;
                                    { "Codigo" => "V025025", "Nombre" => "PATATAS O.VINAGRETA 30g x 35 u",          "Codigo unidades" => "8411859552183",     "Codigo cajas" => "18411859552180" },;
                                    { "Codigo" => "V025026", "Nombre" => "PATATAS O.VINAGRETA 100g x 8 u",          "Codigo unidades" => "8411859553319",     "Codigo cajas" => "18411859553316" },;
                                    { "Codigo" => "V025027", "Nombre" => "ONDULADA CHEESE&ONION 30gx35u",           "Codigo unidades" => "8411859552193",     "Codigo cajas" => "18411859552197" },;
                                    { "Codigo" => "V025028", "Nombre" => "ONDULADA CHEESE&ONION 100gx8u",           "Codigo unidades" => "8411859553286",     "Codigo cajas" => "18411859553286" },;
                                    { "Codigo" => "V025034", "Nombre" => "ONDUL. TANGY TOMATO 100g. x 8u",          "Codigo unidades" => "8411859553357",     "Codigo cajas" => "18411859553354" },;
                                    { "Codigo" => "V025042", "Nombre" => "PATATAS CASERAS 30 g x 30 u.",            "Codigo unidades" => "8411859552114",     "Codigo cajas" => "38411859552115" },;
                                    { "Codigo" => "V025043", "Nombre" => "PATATA OND.ORIGNAL 30 g x 30 u",          "Codigo unidades" => "8411859552152",     "Codigo cajas" => "28411859552156" },;
                                    { "Codigo" => "V025044", "Nombre" => "PATATAS OND.CAMPES.30 g x 30 u",          "Codigo unidades" => "8411859552176",     "Codigo cajas" => "28411859552170" },;
                                    { "Codigo" => "V025045", "Nombre" => "PATATAS OND.JAM�N 30 g x 30 u.",          "Codigo unidades" => "8411859552169",     "Codigo cajas" => "28411859552163" },;
                                    { "Codigo" => "V025046", "Nombre" => "PATATA OND.VINAGRETA 30g x 30u",          "Codigo unidades" => "8411859552183",     "Codigo cajas" => "28411859552187" },;
                                    { "Codigo" => "V025047", "Nombre" => "PATATA OND.CHEESE&ONION30gx30u",          "Codigo unidades" => "8411859552193",     "Codigo cajas" => "28411859552194" },;
                                    { "Codigo" => "V025048", "Nombre" => "PATATAS CASERAS 100g x 9u +30%",          "Codigo unidades" => "8411859553050",     "Codigo cajas" => "88411859553056" },;
                                    { "Codigo" => "V025049", "Nombre" => "PATATA OND.JAMON 100g x 9u+30%",          "Codigo unidades" => "8411859553029",     "Codigo cajas" => "88411859553025" },;
                                    { "Codigo" => "V025050", "Nombre" => "PATATA OND.CAMP.100g x 9u +30%",          "Codigo unidades" => "8411859553005",     "Codigo cajas" => "88411859553001" },;
                                    { "Codigo" => "V025035", "Nombre" => "ONDUL.TANGY TOMATO 30g. x 35u.",          "Codigo unidades" => "8411859552251",     "Codigo cajas" => "18411859552258" },;
                                    { "Codigo" => "V026004", "Nombre" => "CUT THE ROPE 30 g x 40",                  "Codigo unidades" => "8411859550622",     "Codigo cajas" => "18411859550629" },;
                                    { "Codigo" => "V027001", "Nombre" => "RISIBOL 35 g x 35 u",                     "Codigo unidades" => "8411859550516",     "Codigo cajas" => "28411859550513" },;
                                    { "Codigo" => "V027003", "Nombre" => "MATCHBALL 30 g. x 30 unid.",              "Codigo unidades" => "8411859550516",     "Codigo cajas" => "18411859550513" },;
                                    { "Codigo" => "V028003", "Nombre" => "GUSANITOS SUPER  3 g x 75 u",             "Codigo unidades" => "8411859550158",     "Codigo cajas" => "18411859550155" },;
                                    { "Codigo" => "V032005", "Nombre" => "BUSCALIOS BBQ  35 g x 40u",               "Codigo unidades" => "8411859551445",     "Codigo cajas" => "18411859551442" },;
                                    { "Codigo" => "V040004", "Nombre" => "PATATAS CASERAS 450 g x 4 u",             "Codigo unidades" => "8411859556129",     "Codigo cajas" => "18411859556126" },;
                                    { "Codigo" => "V046004", "Nombre" => "TU PACK GUSANITOS x 14 u.",               "Codigo unidades" => "8411859556075",     "Codigo cajas" => "18411859556072" },;
                                    { "Codigo" => "V046011", "Nombre" => "RISKETOS 120 G.BOX 144 unidade",          "Codigo unidades" => "8411859553081B",    "Codigo cajas" => "48411859553089" },;
                                    { "Codigo" => "V046013", "Nombre" => "TU PACK ESTRELLA x 10 Bolsas",            "Codigo unidades" => "8411859556105",     "Codigo cajas" => "18411859556102" },;
                                    { "Codigo" => "V046025", "Nombre" => "TU PACK LANZAMIENTO x 6 u.",              "Codigo unidades" => "8411859556013",     "Codigo cajas" => "18411859556010" },;
                                    { "Codigo" => "V046026", "Nombre" => "TU PACK LANZAMIENTO BOX x 87 u",          "Codigo unidades" => "8411859556013B",    "Codigo cajas" => "38411859556014" },;
                                    { "Codigo" => "V046050", "Nombre" => "RISKETO 120+LINKS 12 g.x 24 u.",          "Codigo unidades" => "8411859553081",     "Codigo cajas" => "18411859555877" },;
                                    { "Codigo" => "V060006", "Nombre" => "PICARITAS 200 UNDS.",                     "Codigo unidades" => "8411859557027",     "Codigo cajas" => "18411859557024" },;
                                    { "Codigo" => "V060007", "Nombre" => "PICARITAS FRESA 200 UNDS.",               "Codigo unidades" => "8411859557041",     "Codigo cajas" => "18411859557048" },;
                                    { "Codigo" => "V060008", "Nombre" => "PICARITAS BLANCAS 200 UNDS",              "Codigo unidades" => "8411859557034",     "Codigo cajas" => "18411859557031" },;
                                    { "Codigo" => "V800101", "Nombre" => "Exp. 4 Modulos",                          "Codigo unidades" => "8411859559946",     "Codigo cajas" => "18411859559943" },;
                                    { "Codigo" => "V800201", "Nombre" => "Exp. Mostrador 5 bandejas alim",          "Codigo unidades" => "8411859559939",     "Codigo cajas" => "18411859559936" },;
                                    { "Codigo" => "V800303", "Nombre" => "Exp.fam.5 bandejas grand.plast",          "Codigo unidades" => "8411859559915",     "Codigo cajas" => "18411859559912" },;
                                    { "Codigo" => "V800402", "Nombre" => "Exp.Mixto 4 bandejas Plastico",           "Codigo unidades" => "",                  "Codigo cajas" => "" },; 
                                    { "Codigo" => "V800403", "Nombre" => "Exp.Cajas 2 Bandejas plastico",           "Codigo unidades" => "8411859559922",     "Codigo cajas" => "18411859559929" },;
                                    { "Codigo" => "V800404", "Nombre" => "Exp.ruedas familiar Plastico",            "Codigo unidades" => "8411859559960",     "Codigo cajas" => "18411859559967" },;
                                    { "Codigo" => "V800501", "Nombre" => "Exp. Extrusi�n",                          "Codigo unidades" => "8411859559977",     "Codigo cajas" => "18411859559974" } }

   METHOD New()         CONSTRUCTOR

   METHOD Dialog()

   METHOD OpenFiles()
   METHOD CloseFiles()  INLINE ( D():DeleteView( ::nView ) )

   METHOD UploadFile()
      METHOD moveToDirectory( cDirectory ) ;
                        INLINE ( ::oFtp:MKD( cDirectory ), ::oFtp:CWD( cDirectory ) )

   METHOD processFile()

   METHOD findCodeBarInHash( cCodigoBarra )

   METHOD getAgente()   INLINE ( "067" )
   METHOD getMes()      INLINE ( strzero( month( ::dInicio ), 2 ) )

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New() CLASS FacturasClientesRisi

   ::oUve               := Uve():New()

   if !::Dialog() 
      Return ( Self )
   end if 

   if !::OpenFiles()
      Return ( Self )
   end if 

   // Con envio
  
   MsgRun( "Porcesando facturas", "Espere por favor...", {|| iif( ::ProcessFile(), ::UploadFile(), ) } )

   // Sin envio

   // MsgRun( "Porcesando facturas", "Espere por favor...", {|| ::ProcessFile() ) } )

  ::CloseFiles()

  msgInfo( "Porceso finalizado" )

Return ( Self )

//---------------------------------------------------------------------------//

METHOD Dialog() CLASS FacturasClientesRisi

      local oDlg
      local oBtn
      local getFechaFin

      oDlg 						:= TDialog():New( 5, 5, 15, 40, "Exportacion Risi" )

      TSay():New( 1, 1, {|| "Desde" }, oDlg )      

      TGetHlp():New( 1, 4, { | u | if( pcount() == 0, ::dInicio, ::dInicio := u ) }, , 40, 10 )

      TSay():New( 2, 1, {|| "Hasta" }, oDlg )      

      TGetHlp():New( 2, 4, { | u | if( pcount() == 0, ::dFin, ::dFin := u ) }, , 40, 10 )

      TButton():New( 3, 4, "&Aceptar", oDlg, {|| ( oDlg:End(1) ) }, 40, 12 )

      TButton():New( 3, 12, "&Cancel", oDlg, {|| oDlg:End() }, 40, 12 )

      oDlg:Activate( , , , .t. )

Return ( oDlg:nResult == 1 )

//---------------------------------------------------------------------------//

METHOD OpenFiles() CLASS FacturasClientesRisi

   local oError
   local oBlock
   local lOpenFiles     := .t.

   oBlock               := ErrorBlock( { | oError | ApoloBreak( oError ) } )
   BEGIN SEQUENCE

      ::nView           := D():CreateView()

      D():FacturasClientes( ::nView )
      ( D():FacturasClientes( ::nView ) )->( ordsetfocus( "dFecFac" ) )

      D():FacturasClientesLineas( ::nView )    

      D():Clientes( ::nView )

      D():Articulos( ::nView )

      D():GruposClientes( ::nView )

      D():Get( "ArtCodebar", ::nView )  

      D():Get( "Ruta", ::nView )

      D():Get( "Agentes", ::nView )

   RECOVER USING oError

      lOpenFiles        := .f.

      msgStop( "Imposible abrir todas las bases de datos" + CRLF + ErrorMessage( oError ) )

   END SEQUENCE

   ErrorBlock( oBlock )

Return ( lOpenFiles )

//---------------------------------------------------------------------------//

METHOD ProcessFile() CLASS FacturasClientesRisi

   local cCodigoRuta    := ""
   local cCodigoAgente  := ""
   local cCodigoGrupo   := ""
   local cNombreGrupo   := ""
   local cCodigoBarra   := ""
   local nUnidades      := 0
   local nCajas         := 0

   CursorWait()

   ( D():FacturasClientes( ::nView ) )->( dbgotop() )

//   ( D():FacturasClientes( ::nView ) )->( dbseek( ::dInicio, .t. ) )
/*
   msgAlert( "Fecha Inicio" )
   msgAlert( ( D():FacturasClientes( ::nView ) )->dFecFac <= ::dFin )
   msgAlert( ( D():FacturasClientes( ::nView ) )->dFecFac,  )
   msgAlert( ::dFin )
*/

   while ( D():FacturasClientes( ::nView ) )->dFecFac <= ::dFin .and. ( D():FacturasClientes( ::nView ) )->( !eof() )

      if ( D():FacturasClientesLineas( ::nView ) )->( dbSeek( D():FacturasClientesId( ::nView ) ) )

         while ( D():FacturasClientesId( ::nView ) == D():FacturasClientesLineasId( ::nView ) ) .and. ( D():FacturasClientesLineas( ::nView ) )->( !eof() ) 

            if ( D():Articulos( ::nView ) )->( dbSeek( ( D():FacturasClientesLineas( ::nView ) )->cRef ) )

               // Codigo de la familia-----------------------------------------

               cCodigoBarra              := ( D():Articulos( ::nView ) )->CodeBar
               nCajas                    := ( D():Articulos( ::nView ) )->nUniCaja

               if ::findCodeBarInHash( cCodigoBarra )

                  // Codigo del grupo-------------------------------------------

                  if ( D():Clientes( ::nView ) )->( dbSeek( ( D():FacturasClientes( ::nView ) )->cCodCli ) )
                     cCodigoGrupo         := ( D():Clientes( ::nView ) )->cCodGrp
                     if !empty(cCodigoGrupo)
                        cNombreGrupo      := oRetFld( cCodigoGrupo, D():Get( "GruposClientes", ::nView ):oDbf, "cNomGrp" )
                     end if
                  end if 

                  // Codigo de la ruta--------------------------------------------

                  cCodigoRuta             := ( D():Clientes( ::nView ) )->cCodRut

                  // Codigo del agente-------------------------------------------

                  cCodigoAgente           := ( D():FacturasClientes( ::nView ) )->cCodAge
                  if empty( cCodigoAgente )
                     cCodigoAgente        := ( D():Clientes( ::nView ) )->cAgente
                  end if  

                  // Unidades de venta-----------------------------------------

                  nUnidades               := nTotNFacCli( D():FacturasClientesLineas( ::nView ) )

                  if ( D():FacturasClientesLineas( ::nView ) )->nCanEnt != 0
                        nUnidades         := nUnidades / ( D():FacturasClientesLineas( ::nView ) )->nCanEnt
                  end if

                  ::oUve:NumFactura(      D():FacturasClientesLineasId( ::nView ) ) 
                  ::oUve:NumLinea(        ( D():FacturasClientesLineas( ::nView ) )->nNumLin ) 
                  ::oUve:CodigoProducto(  ::hProducto[ "Codigo" ] ) 
                  ::oUve:DescProducto(    ::hProducto[ "Nombre" ] )
                  ::oUve:Fabricante(      'RISI' )
                  ::oUve:CodigoProdFab(   ::hProducto[ "Codigo unidades" ] ) // RetFld( ( D():FacturasClientesLineas( ::nView ) )->cRef, D():Get( "ArtCodebar", ::nView ), "cCodBar", "cDefArt" )
                  ::oUve:EAN13(           ::hProducto[ "Codigo unidades" ] ) // RetFld( ( D():FacturasClientesLineas( ::nView ) )->cRef, D():Get( "ArtCodebar", ::nView ), "cCodBar", "cDefArt" )
                  
                  if nCajas > 0
                        ::oUve:Cantidad(  nTotNFacCli( D():FacturasClientesLineas( ::nView ) ) / nCajas )
                        ::oUve:PrecioBase( nTotUFacCli( D():FacturasClientesLineas( ::nView ) ) * nCajas ) // nTotUFacCli( D():FacturasClientesLineas( ::nView ) ) ) // 
                  else
                        ::oUve:Cantidad(  nTotNFacCli( D():FacturasClientesLineas( ::nView ) ) )
                        ::oUve:PrecioBase( nTotUFacCli( D():FacturasClientesLineas( ::nView ) ) ) // nTotUFacCli( D():FacturasClientesLineas( ::nView ) ) ) // 
                  end if 

                  ::oUve:UM(              'UN' )
                  ::oUve:Descuentos(      nTotDtoLFacCli( D():FacturasClientesLineas( ::nView ) ) )
                  ::oUve:PrecioBrutoTotal( nTotLFacCli( D():FacturasClientesLineas( ::nView ) ) )
                  ::oUve:FechaFra(        ( D():FacturasClientes( ::nView ) )->dFecFac )
                  ::oUve:Ejercicio(       Year( ( D():FacturasClientes( ::nView ) )->dFecFac ) )
                  ::oUve:CodigoCliente(   ( D():FacturasClientes( ::nView ) )->cCodCli )
                  ::oUve:RazonSocial(     ( D():FacturasClientes( ::nView ) )->cNomCli )
                  ::oUve:Nombre(          ( D():Clientes( ::nView ) )->NbrEst )
                  ::oUve:CIF(             ( D():FacturasClientes( ::nView ) )->cDniCli )
                  ::oUve:Direccion(       ( D():FacturasClientes( ::nView ) )->cDirCli )
                  ::oUve:Poblacion(       ( D():FacturasClientes( ::nView ) )->cPobCli )
                  ::oUve:CodigoPostal(    ( D():FacturasClientes( ::nView ) )->cPosCli )
                  ::oUve:Ruta(            cCodigoRuta )
                  ::oUve:NombreRuta(      RetFld( cCodigoRuta, D():Get( "Ruta", ::nView ), "cDesRut" ) )
                  ::oUve:CodigoComercial( cCodigoAgente )
                  ::oUve:NombreComercial( RetNbrAge( cCodigoAgente, D():Get( "Agentes", ::nView ) ) )
                  ::oUve:Peso()
                  ::oUve:UMPeso()
                  ::oUve:TipoCliente(     cCodigoGrupo )
                  ::oUve:Telefono(        ( D():FacturasClientes( ::nView ) )->cTlfCli ) 
                  ::oUve:DescTipoCliente( cNombreGrupo )

                  ::oUve:SerializeASCII()

                  // msgWait( "procesando registro " + str( ( D():FacturasClientes( ::nView ) )->( ordkeyno() ) ), "", 0.1 ) 

               end if 

            end if 

            ( D():FacturasClientesLineas( ::nView ) )->( dbSkip() ) 
      
         end while
   
      end if 

      sysRefresh()

      ( D():FacturasClientes( ::nView ) )->( dbskip() )

   end while

   ::oUve:WriteASCII()

   CursorWE()

Return ( file( ::oUve:cFile ) )

//---------------------------------------------------------------------------//

   METHOD UploadFile() CLASS FacturasClientesRisi

      local oInt
      local cUrl
      local cUserFtp          := "manolo"
      local cPasswdFtp        := "123Ab456"
      local cHostFtp          := "ftp.gestool.es"

      if !file( ::oUve:getFile() )
         msgStop( "No existe el fichero : " + ::oUve:getFile() )
         Return .f.
      end if

      cUrl                    := "ftp://" + cUserFtp + ":" + cPasswdFtp + "@" + cHostFtp

      oInt                    := TUrl():New( cUrl )

      ::oFTP                  := TIPClientFTP():New( oInt, .t. )
      ::oFTP:nConnTimeout     := 20000

      if !( ::oFTP:Open( oInt ) )
         msgWait( "Imposible crear la conexi�n", "Error", 1 )
         Return .f.
      end if   

      // ruta para el ftp-----------------------------------------------------

      ::moveToDirectory( "httpdocs" )

      ::moveToDirectory( "uve" )

      ::moveToDirectory( ::getAgente() )

      ::moveToDirectory( ::getMes() )

      // subimos el fichero----------------------------------------------------

      if isTrue( ::oFtp:UploadFile( ::oUve:getFile() ) ) // 
         msgWait( "Fichero " + ::oUve:getFile() + "subido al ftp.", "Informaci�n", 1 )
      else
         msgStop( ::oFtp:lastErrorCode(), "Error al subir el fichero.")
      end if 

      if !empty( ::oFTP )
         ::oFTP:Close()
      end if

   RETURN ( .t. )

//---------------------------------------------------------------------------//

   METHOD findCodeBarInHash( cCodigoBarra ) CLASS FacturasClientesRisi

      local hProducto

      ::hProducto             := nil

      for each hProducto in ::aProductos

         if hProducto[ "Codigo" ] == alltrim( cCodigoBarra )
            ::hProducto       := hProducto
         end if 

      next 

   RETURN ( ::hProducto != nil )

//---------------------------------------------------------------------------//

CLASS Uve FROM Cuaderno

   DATA cFile                       
   DATA cBuffer                     INIT ''

   METHOD New()                     INLINE ( ::cFile := FullCurDir() + "Log\VentasDistribuidor" + dtos( date() ) + timeToString() + ".csv", Self )
   METHOD Separator()               INLINE ( ';' )

   METHOD getFile()                 INLINE ( ::cFile )

   METHOD WriteASCII()
   METHOD SerializeASCII()

   DATA cNumFactura                 INIT ''
   METHOD NumFactura(uValue)        INLINE ( if( !Empty(uValue), ::cNumFactura         := uValue, trimpadr( strtran( ::cNumFactura, " ", "" ), 20 ) ) )
   DATA nNumLinea                   INIT 0
   METHOD NumLinea(uValue)          INLINE ( if( !Empty(uValue), ::nNumLinea           := uValue, trimpadr( trans( ::nNumLinea, "@E 9999999.99" ), 10 ) ) )
   DATA cCodigoProducto             INIT ''
   METHOD CodigoProducto(uValue)    INLINE ( if( !Empty(uValue), ::cCodigoProducto     := uValue, trimpadr( ::cCodigoProducto, 18 ) ) )
   DATA cDescProducto               INIT ''
   METHOD DescProducto(uValue)      INLINE ( if( !Empty(uValue), ::cDescProducto       := uValue, trimpadr( ::cDescProducto, 50 ) ) )
   DATA cFabricante                 INIT ''
   METHOD Fabricante(uValue)        INLINE ( if( !Empty(uValue), ::cFabricante         := uValue, trimpadr( ::cFabricante, 10 ) ) )
   DATA cCodigoProdFab              INIT ''
   METHOD CodigoProdFab(uValue)     INLINE ( if( !Empty(uValue), ::cCodigoProdFab      := uValue, trimpadr( ::cCodigoProdFab, 18 ) ) )
   DATA cEAN13                      INIT ''
   METHOD EAN13(uValue)             INLINE ( if( !Empty(uValue), ::cEAN13              := uValue, trimpadr( ::cEAN13, 13 ) ) )
   DATA nCantidad                   INIT 0
   METHOD Cantidad(uValue)          INLINE ( if( !Empty(uValue), ::nCantidad           := uValue, trimpadr( trans( ::nCantidad, "@E 9999999999.999" ), 14 ) ) )
   DATA cUM                         INIT ''
   METHOD UM(uValue)                INLINE ( if( !Empty(uValue), ::cUM                 := uValue, trimpadr( ::cUM, 5 ) ) )
   DATA nPrecioBase                 INIT 0
   METHOD PrecioBase(uValue)        INLINE ( if( !Empty(uValue), ::nPrecioBase         := uValue, trimpadr( trans( ::nPrecioBase, "@E 9999999999.999" ), 14 ) ) )
   DATA nDescuentos                 INIT 0
   METHOD Descuentos(uValue)        INLINE ( if( !Empty(uValue), ::nDescuentos         := uValue, trimpadr( trans( ::nDescuentos, "@E 9999999999.999" ), 14 ) ) )
   DATA nPrecioBrutoTotal           INIT 0
   METHOD PrecioBrutoTotal(uValue)  INLINE ( if( !Empty(uValue), ::nPrecioBrutoTotal   := uValue, trimpadr( trans( ::nPrecioBrutoTotal, "@E 9999999999.999" ), 14 ) ) )
   DATA dFechaFra                   INIT date()
   METHOD FechaFra(uValue)          INLINE ( if( !Empty(uValue), ::dFechaFra           := uValue, dtos( ::dFechaFra ) ) )
   DATA nEjercicio                  INIT 0
   METHOD Ejercicio(uValue)         INLINE ( if( !Empty(uValue), ::nEjercicio          := uValue, str( ::nEjercicio, 4 ) ) )
   DATA cCodigoCliente              INIT ''
   METHOD CodigoCliente(uValue)     INLINE ( if( !Empty(uValue), ::cCodigoCliente      := uValue, trimpadr( ::cCodigoCliente, 15 ) ) )
   DATA cNombre                     INIT ''
   METHOD Nombre(uValue)            INLINE ( if( !Empty(uValue), ::cNombre             := uValue, trimpadr( ::cNombre, 50 ) ) )
   DATA cRazonSocial                INIT ''
   METHOD RazonSocial(uValue)       INLINE ( if( !Empty(uValue), ::cRazonSocial        := uValue, trimpadr( ::cRazonSocial, 50 ) ) )
   DATA cCIF                        INIT ''
   METHOD CIF(uValue)               INLINE ( if( !Empty(uValue), ::cCIF                := uValue, trimpadr( ::cCIF, 15 ) ) )
   DATA cDireccion                  INIT ''
   METHOD Direccion(uValue)         INLINE ( if( !Empty(uValue), ::cDireccion          := uValue, trimpadr( ::cDireccion, 100 ) ) ) 
   DATA cPoblacion                  INIT ''
   METHOD Poblacion(uValue)         INLINE ( if( !Empty(uValue), ::cPoblacion          := uValue, trimpadr( ::cPoblacion, 50 ) ) )
   DATA cCodigoPostal               INIT ''
   METHOD CodigoPostal(uValue)      INLINE ( if( !Empty(uValue), ::cCodigoPostal       := uValue, trimpadr( ::cCodigoPostal, 5 ) ) )
   DATA cRuta                       INIT ''
   METHOD Ruta(uValue)              INLINE ( if( !Empty(uValue), ::cRuta               := uValue, trimpadr( ::cRuta, 10 ) ) )
   DATA cNombreRuta                 INIT ''
   METHOD NombreRuta(uValue)        INLINE ( if( !Empty(uValue), ::cNombreRuta         := uValue, trimpadr( ::cNombreRuta, 50 ) ) )
   DATA cCodigoComercial            INIT ''
   METHOD CodigoComercial(uValue)   INLINE ( if( !Empty(uValue), ::cCodigoComercial    := uValue, trimpadr( ::cCodigoComercial, 10 ) ) )
   DATA cNombreComercial            INIT ''
   METHOD NombreComercial(uValue)   INLINE ( if( !Empty(uValue), ::cNombreComercial    := uValue, trimpadr( ::cNombreComercial, 50 ) ) )
   DATA nPeso                       INIT 0
   METHOD Peso(uValue)              INLINE ( if( !Empty(uValue), ::nPeso               := uValue, trimpadr( trans( ::nPeso, "@E 9999999999.999" ), 14 ) ) )
   DATA cUMPeso                     INIT ''
   METHOD UMPeso(uValue)            INLINE ( if( !Empty(uValue), ::cUMPeso             := uValue, trimpadr( ::cUMPeso, 5 ) ) )
   DATA cTipoCliente                INIT ''
   METHOD TipoCliente(uValue)       INLINE ( if( !Empty(uValue), ::cTipoCliente        := uValue, trimpadr( ::cTipoCliente, 6 ) ) )
   DATA cTelefono                   INIT ''
   METHOD Telefono(uValue)          INLINE ( if( !Empty(uValue), ::cTelefono           := uValue, trimpadr( ::cTelefono, 11 ) ) )
   DATA cDescTipoCliente            INIT ''
   METHOD DescTipoCliente(uValue)   INLINE ( if( !Empty(uValue), ::cDescTipoCliente    := uValue, trimpadr( ::cDescTipoCliente, 50 ) ) )

ENDCLASS

   //------------------------------------------------------------------------//

   METHOD SerializeASCII() CLASS Uve 

      ::cBuffer         += ::NumFactura()       + ::Separator()
      ::cBuffer         += ::NumLinea()         + ::Separator()
      ::cBuffer         += ::CodigoProducto()   + ::Separator()
      ::cBuffer         += ::DescProducto()     + ::Separator()
      ::cBuffer         += ::Fabricante()       + ::Separator()
      ::cBuffer         += ::CodigoProdFab()    + ::Separator()
      ::cBuffer         += ::EAN13()            + ::Separator()
      ::cBuffer         += ::Cantidad()         + ::Separator()
      ::cBuffer         += ::UM()               + ::Separator()
      ::cBuffer         += ::PrecioBase()       + ::Separator()
      ::cBuffer         += ::Descuentos()       + ::Separator()
      ::cBuffer         += ::PrecioBrutoTotal() + ::Separator()
      ::cBuffer         += ::FechaFra()         + ::Separator()
      ::cBuffer         += ::Ejercicio()        + ::Separator()
      ::cBuffer         += ::CodigoCliente()    + ::Separator()
      ::cBuffer         += ::Nombre()           + ::Separator()
      ::cBuffer         += ::RazonSocial()      + ::Separator()
      ::cBuffer         += ::CIF()              + ::Separator()
      ::cBuffer         += ::Direccion()        + ::Separator()
      ::cBuffer         += ::Poblacion()        + ::Separator()
      ::cBuffer         += ::CodigoPostal()     + ::Separator()
      ::cBuffer         += ::Ruta()             + ::Separator()
      ::cBuffer         += ::NombreRuta()       + ::Separator()
      ::cBuffer         += ::CodigoComercial()  + ::Separator()
      ::cBuffer         += ::NombreComercial()  + ::Separator()
      ::cBuffer         += ::Peso()             + ::Separator()
      ::cBuffer         += ::UMPeso()           + ::Separator()
      ::cBuffer         += ::TipoCliente()      + ::Separator()
      ::cBuffer         += ::Telefono()         + ::Separator()
      ::cBuffer         += ::DescTipoCliente()  + ::Separator()
      ::cBuffer         += CRLF

   Return ( ::cBuffer )

//---------------------------------------------------------------------------//

   METHOD WriteASCII() CLASS Uve

      if empty( ::cBuffer )
         Return ( .f. )
      end if

      ::hFile  := fCreate( ::cFile )

      if !Empty( ::hFile )
         fWrite( ::hFile, ::cBuffer )
         fClose( ::hFile )
      end if

   Return ( Self )

//---------------------------------------------------------------------------//

Static Function TrimPadr( cString, nLen )

Return ( alltrim( padr( cString, nLen ) ) )

//---------------------------------------------------------------------------//

