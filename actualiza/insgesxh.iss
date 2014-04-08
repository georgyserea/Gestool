  ; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
AppName=MK Shop Gesti�n 2010
AppVerName=MK Shop Gesti�n 2010
AppPublisher=Micro K Inform�tica
AppPublisherURL=http://www.microkinformatica.es
AppSupportURL=http://www.microkinformatica.es
AppUpdatesURL=http://www.microkinformatica.es
DefaultDirName={pf}\Micro K Inform�tica\MK Shop Gesti�n
DefaultGroupName=MK Shop Gesti�n
AllowNoIcons=yes
OutputDir=c:\Ftproot\Instalacion
OutputBaseFilename=MkShopInstalacion
WizardImageFile=C:\Fw195\Camero\WizardImageMk.bmp
WizardSmallImageFile=C:\Fw195\Camero\WizardSmallImageMk.bmp
; DiskSpanning=yes
; uncomment the following line if you want your installation to run on NT 3.51 too.
; MinVersion=4,3.51

[Tasks]
Name: "desktopicon"; Description: "&Crear acceso directo en escritorio"; GroupDescription: "Iconos adicionales:"; MinVersion: 4,4

[Files]
;Source: "C:\Fw195\Camero\Gestion.ini";            DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Fw195\Camero\ChkEmp.nil";             DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Fw195\Camero\MkGestion.exe";          DestDir: "{app}"; Flags: ignoreversion;
Source: "C:\Fw195\Camero\RptApolo.exe";           DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Fw195\Camero\LogoMk.ico";             DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Image2Pdf StdCall.Dll";  DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Fw195\Camero\LibMySql.Dll";           DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Fw195\Camero\FreeImage.Dll";          DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Fw195\Camero\FrSystH.Dll";            DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Fw195\Camero\jMail.Dll";              DestDir: "{app}"; Flags: ignoreversion regserver

Source: "C:\Fw195\Camero\Bmp\Apolo.bmp";          DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\MkWellcome.bmp";     DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\GstWellcome.bmp";    DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\Bye.bmp";            DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\NoImage.bmp";        DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\ImgFacCli.bmp";      DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\ImgAlbCli.bmp";      DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\ImgPedCli.bmp";      DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\ImgPreCli.bmp";      DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\ImgFacPrv.bmp";      DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\ImgAlbPrv.bmp";      DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\ImgPedPrv.bmp";      DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\ImgSndInt.bmp";      DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\IniRotor.bmp";       DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\IniMicroK.bmp";      DestDir: "{app}\Bmp"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Bmp\ImgPleaseWait.bmp";  DestDir: "{app}\Bmp"; Flags: ignoreversion

;Source: "C:\Fw195\Camero\Bmp\GstRotor*.bmp";      DestDir: "{app}\Bmp"; Flags: ignoreversion

;Source: "C:\Fw195\Camero\Help\Help.chm";          DestDir: "{app}\Help";      Flags: ignoreversion
;Source: "C:\Fw195\Camero\Tutorial\*.*";           DestDir: "{app}\Tutorial";  Flags: ignoreversion onlyifdoesntexist

Source: "C:\Fw195\Actualiza\In\*.*";              DestDir: "{app}\In";        Flags: ignoreversion onlyifdoesntexist
Source: "C:\Fw195\Actualiza\Out\*.*";             DestDir: "{app}\Out";       Flags: ignoreversion onlyifdoesntexist
Source: "C:\Fw195\Actualiza\Log\*.*";             DestDir: "{app}\Log";       Flags: ignoreversion onlyifdoesntexist
Source: "C:\Fw195\Actualiza\Htm\*.*";             DestDir: "{app}\Htm";       Flags: ignoreversion onlyifdoesntexist
Source: "C:\Fw195\Actualiza\Tmp\*.*";             DestDir: "{app}\Tmp";       Flags: ignoreversion onlyifdoesntexist
Source: "C:\Fw195\Actualiza\EmpTmp\*.*";          DestDir: "{app}\EmpTmp";    Flags: ignoreversion onlyifdoesntexist
Source: "C:\Fw195\Actualiza\Safe\*.*";            DestDir: "{app}\Safe";      Flags: ignoreversion onlyifdoesntexist
Source: "C:\Fw195\Actualiza\EmpAP\*.*";           DestDir: "{app}\EmpAp";     Flags: ignoreversion onlyifdoesntexist
Source: "C:\Fw195\Actualiza\Datos\*.*";           DestDir: "{app}\Datos";     Flags: ignoreversion onlyifdoesntexist
Source: "C:\Fw195\Actualiza\Psion\*.*";           DestDir: "{app}\Psion";     Flags: ignoreversion onlyifdoesntexist

; P�ginas html

Source: "C:\Fw195\Camero\Htm\Visor.htm";          DestDir: "{app}\Htm"; Flags: ignoreversion
Source: "C:\Fw195\Camero\Htm\Gmap.htm";           DestDir: "{app}\Htm"; Flags: ignoreversion

; Fichero de imagenes

Source: "C:\Fw195\Actualiza\Imagen\*.*";          DestDir: "{app}\Imagen";    Flags: ignoreversion onlyifdoesntexist recursesubdirs

; Asistencia remota

Source: "C:\Fw195\Camero\Client\Client.Exe";      DestDir: "{app}\Client";    Flags: ignoreversion

; Control de nueva versi�n

Source: "C:\Fw195\Actualiza\ChkEmp.nil";          DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\MK Shop Gesti�n";                  Filename: "{app}\MkGestion.exe";       WorkingDir: "{app}"; IconFilename: "{app}\LogoMk.Ico"
Name: "{userdesktop}\MK Shop Gesti�n";            Filename: "{app}\MkGestion.exe";       WorkingDir: "{app}"; IconFilename: "{app}\LogoMk.Ico"

[Run]
Filename: "{app}\MkGestion.exe";                  Description: "Iniciar MK Shop Gesti�n 2010"; Flags: nowait postinstall skipifsilent
