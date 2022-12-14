# Deploy V Rising to ACI
## About this repo
Deploys the bare minimum infra necessary to host a v rising container in Azure.

## Things you'll need
1. An Azure Subscription
2. A Github Account

## Create a service principle
Github Actions need a way to authenticate to Azure. We're going to provide a service principle.
1. Get your subscription ID
    1. Head to Azure Portal and copy it or
    2. run ```az account show``` in powershell while logged into your azure account
2. Create a service principle
    1. Run ``` az ad sp create-for-rbac --name GithubActions --role Contributor --scopes /subscriptions/<yourSubscriptionId> --sdk-auth```
        2. If you're having trouble logging in, try running ```az login --use-device-code``` to authorize that session
    2. Copy the entire json response
    3. Head to your Repo -> Settings -> Security -> Secrets -> Actions
    4. Click ```New Repositiory Secret``` 
    5. Give it a name (ex: AZURE_CREDENTIALS)
    6. Paste the json as the value ex:
         ```
        {
            "clientId": "<GUID>",
            "clientSecret": "<GUID>",
            "subscriptionId": "<GUID>",
            "tenantId": "<GUID>",
            "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
            "resourceManagerEndpointUrl": "https://management.azure.com/",
            "activeDirectoryGraphResourceId": "https://graph.windows.net/",
            "sqlManagementEndpointUrl": "https://management.core.windows.net:<PORT>/",
            "galleryEndpointUrl": "https://gallery.azure.com/",
            "managementEndpointUrl": "https://management.core.windows.net/"
        }
## Personalize
Review the environment variables in the yaml file.  Change the names or specs of anything you rather see. 

## 
Once the storage is created, you may want to secure/personalize your server. Head to aka.ms/portal and login. Go to your storage account and update the ServerHostSettings.json to your preferred server name and password. 
```
{
  "Name": "Example Server",
  "Description": "",
  "Port": 9876,
  "QueryPort": 9877,
  "MaxConnectedUsers": 40,
  "MaxConnectedAdmins": 4,
  "ServerFps": 30,
  "SaveName": "world1",
  "Password": "example_password",
  "Secure": true,
  "ListOnMasterServer": true,
  "AutoSaveCount": 50,
  "AutoSaveInterval": 600,
  "GameSettingsPreset": "",
  "AdminOnlyDebugEvents": true,
  "DisableDebugEvents": false
}
```

