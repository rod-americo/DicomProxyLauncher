# DicomProxyLauncher

Uma ferramenta "proxy" leve para redirecionar chamadas de visualização DICOM. Originalmente projetada para interceptar chamadas do mCockpit (plugin Vida/Myrian) e redirecioná-las para visualizadores modernos como **RadiAnt** ou **OsiriX**.

## Funcionalidades

*   **Interceptação Transparente**: Compila-se como `ispilot.exe` para substituir o executável original sem alterar o software chamador.
*   **Suporte Dual**:
    *   **OsiriX/Horos**: Redireciona via protocolo URL (`osirix://`).
    *   **RadiAnt**: Redireciona via linha de comando (`RadiAntViewer.exe -d PATH`).
*   **Configuração via INI**: Alterne entre visualizadores ou ajuste caminhos sem recompilar.
*   **Parser INI Embutido**: Sem dependências externas (.NET Framework nativo).

## Arquivos

*   `DicomProxyLauncher.cs`: Código fonte principal.
*   `config.ini`: Arquivo de configuração.

## Como Usar

### 1. Compilação

Compile o código para gerar o executável final (que deve se chamar `ispilot.exe` para o mCockpit).

**No Windows (PowerShell):**
```powershell
& "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe" /target:winexe /out:ispilot.exe DicomProxyLauncher.cs
```

### 2. Configuração

Edite o `config.ini`:

```ini
[General]
viewer=radiant ; ou osirix

[RadiAnt]
radiant_exe=C:\Program Files\RadiAntViewer64bitARM\RadiAntViewer.exe
radiant_dicom=C:\DICOM
```

### 3. Instalação

Copie `ispilot.exe` e `config.ini` para a pasta do visualizador original (substituindo o executável antigo).
