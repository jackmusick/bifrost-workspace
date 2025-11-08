# Bifrost Workspace

Local development environment for building and debugging Bifrost workflows.

## What is Bifrost?

Bifrost is an open-source automation platform for MSPs, enabling workflow creation and execution with a Python-based SDK.

## Prerequisites

-   **Docker Desktop** (or Docker Engine + Docker Compose)
-   **VS Code** with Python extension (for debugging)
-   **Azure Entra ID app registration** (for authentication)
-   **Key Vault Secrets Officer** permissions for your App Registration
-   **Azure CLI or PowerShell Module** for Key Vault, will use your logged-in identity

## Quick Start

### 1. Set Up Environment Variables

Copy the example environment file and fill in your credentials:

```bash
cp .env.example .env
```

Edit `.env` and provide:

-   `ENTRA_CLIENT_ID` - Your Azure AD app client ID
-   `ENTRA_CLIENT_SECRET` - Your Azure AD app client secret
-   `AZURE_KEY_VAULT_URL` - Your Azure Key Vault URL
-   `WebPubSubConnectionString` - Optional but recommended for real-time updates, free tier is enough

### 2. Execute Permissions

```
chmod +x ./start.sh ./stop.sh
```

### 3. Start Services

```bash
./start.sh
```

Or manually:

```bash
docker-compose up
```

This will start three services:

-   **Azurite** - Azure Storage emulator (ports 10000-10002)
-   **API** - Bifrost Functions API (port 7071, debugpy on 5678)
-   **Client** - Bifrost web interface (port 4280)

### 4. Access the Application

Once all services are healthy (check logs), open:

**Web Interface:** http://localhost:4280

The web interface will redirect you to authenticate with Azure AD.

## Creating Workflows

See the [documentation](https://docs.gobifrost.com) for more information.

### Example Workflow

Create a Python file in the `/workspace` directory (e.g., `my_workflow.py`):

```python
def run(context):
    """
    Simple workflow example

    Args:
        context: OrganizationContext containing org, caller, execution_id
    """
    print(f"Hello from workflow!")
    print(f"Organization: {context.org.name if context.org else 'No org'}")
    print(f"Caller: {context.caller.email}")

    return {
        "status": "success",
        "message": "Workflow completed successfully"
    }
```

## Debugging Workflows

### Setting Up VS Code Debugger

1. Start the application with `start.sh`
1. **Open this workspace in VS Code**
1. **Set breakpoints** in your Python workflow files
1. **Start debugging**: Press `F5` or click "Run and Debug" → "Attach to Docker Functions"
1. **Trigger your workflow** from the web interface

The debugger will pause at your breakpoints, allowing you to:

-   Inspect variables
-   Step through code line by line
-   Evaluate expressions in the Debug Console

### Debugger Configuration

The `.vscode/launch.json` file is pre-configured to attach to the Python debugger (debugpy) running on port 5678.

**Path Mappings:**

-   Local workspace: `${workspaceFolder}`
-   Remote container: `/workspace`
