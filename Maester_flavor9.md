# Maester Tests

This is a starter repository of Maester tests that you can clone to get started with Maester.

## Installation
To get started, install the Maester module, sign into your tenant and run Invoke-Maester to run the tests we've created for you.

```powershell
Install-Module Maester -Scope CurrentUser

Connect-Maester

Invoke-Maester
```

See [Maester.dev](https://maester.dev) to learn more about writing your own tenant specific tests, setting up continous monitoring of your tenant and more.

## Updating your Maester tests

The Maester team will add new tests over time. To get the latest updates, use the commands below to update your GitHub repository with the latest tests.

### Step 1: Change to the folder with your tests

Open a command prompt and navigate to the folder where you have your Maester tests.

```powershell
cd maester-tests\tests
```

### Step 2: Update the Maester module

Update the **Maester** PowerShell module to the latest version and load it.

```powershell
Update-Module Maester -Force
Import-Module Maester
```

### Step 3: Update the tests folder

You will be prompted to confirm changes to the tests folder.

* All of your custom tests in the `/Custom` folder will be preserved.
* The test files in the other folders including `/EIDSCA`, `/Maester` and `/CISA` will be overwritten with the latest tests.

```powershell
Update-MaesterTests
```

_If you are not seeing the latests tests, try closing and reopening your PowerShell session after completing **Step 2** (`Update-Module`)._

## Windows Installation 
You can install PowerShell 7 using either winget or a direct web download script.
Option 1: Using WinGet (Recommended)
1. Open your existing Windows PowerShell or Command Prompt.
2. Execute the following command to download and install the latest stable version:

> Powershell
 
```
winget install Microsoft.PowerShell
```
3. Restart your terminal. Launch it by running
```
pwsh
```
Option 2: Using the MSDN Web Download Script
If winget is unavailable on your system, you can use a single-line script inside Windows PowerShell to fetch and execute the MSI installer silently
```
Invoke-Expression (& { $(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1
```


> [!NOTE]  
> This repository is a copy of the `/tests` folder from the main https://github.com/maester365/maester repository.
> Please open pull-requests and open issues in the main repository.
