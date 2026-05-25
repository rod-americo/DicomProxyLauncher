#define AppName "mCockpit External Viewer Bridge"
#define AppVersion "1.0.0"

[Setup]
AppId={{9A81414E-C041-43C8-9D12-262AB1E7497B}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher=MDMV
DefaultDirName={sd}\Program Files\Intrasense\Myrian
DisableDirPage=yes
DisableProgramGroupPage=yes
InfoBeforeFile=before-install.txt
OutputDir=output
OutputBaseFilename=mCockpitExternalViewerBridgeSetup
Compression=lzma2
SolidCompression=yes
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64compatible
UninstallDisplayName={#AppName}

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Files]
Source: "payload\MDMV\mCockpit\Plugin\*"; DestDir: "{sd}\MDMV\mCockpit\Plugin"; Flags: ignoreversion recursesubdirs createallsubdirs; BeforeInstall: SetInstallStatus('Copiando arquivos do plugin para C:\MDMV\mCockpit\Plugin...')
Source: "payload\Intrasense\Myrian\*"; DestDir: "{sd}\Program Files\Intrasense\Myrian"; Flags: ignoreversion recursesubdirs createallsubdirs; BeforeInstall: SetInstallStatus('Copiando bridge para C:\Program Files\Intrasense\Myrian...')

[Code]
var
  RadiAntPage: TInputFileWizardPage;
  RadiAntDetected: Boolean;

procedure SetInstallStatus(Message: String);
begin
  WizardForm.StatusLabel.Caption := Message;
end;

function FindRadiAntViewer(): String;
var
  Candidate: String;
begin
  RadiAntDetected := False;

  Candidate := ExpandConstant('{sd}\Program Files\RadiAntViewer64bit\RadiAntViewer.exe');
  if FileExists(Candidate) then
  begin
    RadiAntDetected := True;
    Result := Candidate;
    exit;
  end;

  Candidate := ExpandConstant('{sd}\Program Files\RadiAntViewer64bitARM\RadiAntViewer.exe');
  if FileExists(Candidate) then
  begin
    RadiAntDetected := True;
    Result := Candidate;
    exit;
  end;

  Candidate := ExpandConstant('{sd}\Program Files\RadiAntViewer\RadiAntViewer.exe');
  if FileExists(Candidate) then
  begin
    RadiAntDetected := True;
    Result := Candidate;
    exit;
  end;

  Candidate := ExpandConstant('{sd}\Program Files\RadiAntViewer32bit\RadiAntViewer.exe');
  if FileExists(Candidate) then
  begin
    RadiAntDetected := True;
    Result := Candidate;
    exit;
  end;

  Candidate := ExpandConstant('{sd}\Program Files (x86)\RadiAntViewer32bit\RadiAntViewer.exe');
  if FileExists(Candidate) then
  begin
    RadiAntDetected := True;
    Result := Candidate;
    exit;
  end;

  Result := ExpandConstant('{sd}\Program Files\RadiAntViewer64bit\RadiAntViewer.exe');
end;

procedure InitializeWizard();
begin
  RadiAntPage := CreateInputFilePage(
    wpInfoBefore,
    'Configuração do RadiAnt',
    'Confirme o caminho do RadiAntViewer.exe',
    'Se o RadiAnt for encontrado, ele será usado como viewer padrão. Se não for encontrado, a configuração continuará usando OsiriX/Horos.'
  );
  RadiAntPage.Add('RadiAntViewer.exe:', 'Executáveis (*.exe)|*.exe|Todos os arquivos (*.*)|*.*', '.exe');
  RadiAntPage.Values[0] := FindRadiAntViewer();
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ConfigFile: String;
  RadiAntExe: String;
begin
  if CurStep = ssPostInstall then
  begin
    ConfigFile := ExpandConstant('{sd}\Program Files\Intrasense\Myrian\config.ini');
    RadiAntExe := RadiAntPage.Values[0];
    if FileExists(ConfigFile) then
    begin
      if RadiAntExe <> '' then
      begin
        SetIniString('RadiAnt', 'radiant_exe', RadiAntExe, ConfigFile);
        if RadiAntDetected or FileExists(RadiAntExe) then
        begin
          SetIniString('General', 'viewer', 'radiant', ConfigFile);
        end;
      end;
    end;
  end;
end;
