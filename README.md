# DicomProxyLauncher (Antigo OsiriX Launcher)

Este projeto integra o mCockpit (plugin "Vida Avançado") com visualizadores DICOM externos (OsiriX, RadiAnt), atuando como um "proxy" que intercepta a chamada do sistema e redireciona os argumentos corretamente.

## Arquivos

*   `DicomProxyLauncher.cs`: Código fonte C#.
*   `config.ini`: Arquivo de configuração para escolher o Viewer e definir caminhos.

## Como Funciona

1.  O mCockpit chama o executável configurado no plugin (originalmente `ispilot.exe`).
2.  Nós substituímos esse executável pelo nosso `DicomProxyLauncher` compilado (renomeado para `ispilot.exe`).
3.  O Launcher lê o `config.ini` para decidir qual viewer abrir.
4.  **Se RadiAnt**: Abre o executável do RadiAnt passando a pasta do exame.
5.  **Se OsiriX**: Dispara o protocolo `osirix://` com o *Accession Number*.

## Instalação

### 1. Compilação

No Windows onde o mCockpit está rodando, compile o código para gerar o executável. Use o comando abaixo no **PowerShell**:

```powershell
& "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe" /target:winexe /out:ispilot.exe DicomProxyLauncher.cs
```

Isso gera o arquivo `ispilot.exe` (modo silencioso, sem janela preta).

### 2. Configuração do Plugin (mCockpit)

Certifique-se de que o arquivo de configuração do plugin (`Plugin\mIntegrador.Plugin.Vida.dll.config`) esteja configurado para passar os argumentos corretos. A chave `UsarUrlEspecifica` deve estar **true**. 

Isto é vital para que o mCockpit envie o argumento `-qr` que contém o Accession Number:

```xml
<configuration>
  <add key="UsarUrlEspecifica" value="true" />
  <add key="UrlEspecifica" value="..." />
</configuration>
```

### 3. Configuração do Launcher (config.ini)

Crie/edite o arquivo `config.ini` na mesma pasta do executável:

```ini
[General]
viewer=radiant  ; Opções: 'radiant' ou 'osirix'

[RadiAnt]
radiant_exe=C:\Program Files\RadiAntViewer\RadiAntViewer.exe
radiant_dicom=C:\DICOM
```

### 4. Substituição (Deploy)

1.  Localize a pasta de instalação do viewer original (geralmente `C:\Program Files\Intrasense\Myrian\` ou a pasta configurada no plugin).
2.  Faça um backup do `ispilot.exe` original se ele existir.
3.  **Copie** os arquivos `ispilot.exe` (que você compilou) e `config.ini` para esta pasta (possivelmente precisará de privilégios de administrador).

## Histórico de Desenvolvimento

1.  **Investigação (Mocking)**: Identificamos que o plugin chamava o `ispilot.exe`.
2.  **Plugin Config**: Ajustamos `UsarUrlEspecifica=true` para receber os argumentos `-qr`.
3.  **OsiriX Launcher**: Primeira versão que apenas chamava URLs `osirix://`.
4.  **DicomProxyLauncher**: Versão atual unificada. Adicionado suporte a `config.ini` e suporte nativo ao **RadiAnt**, permitindo troca dinâmica de visualizador sem recompilar.
