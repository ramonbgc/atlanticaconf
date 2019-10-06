resource "azurerm_template_deployment" "pipe" {
  name                = "copy_data"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  template_body = <<DEPLOY
  {
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "factoryName": {
            "type": "string",
            "metadata": "Data Factory name",
            "defaultValue": "atlantica-conf-df-01"
        },
        "AzureBlobStorageSource_connectionString": {
            "type": "secureString",
            "metadata": "Secure string for 'connectionString' of 'AzureBlobStorageSource'"
        },
        "AzureBlobStorageDest_servicePrincipalKey": {
            "type": "secureString",
            "metadata": "Secure string for 'servicePrincipalKey' of 'AzureBlobStorageDest'"
        },
        "AzureBlobStorageDest_properties_typeProperties_serviceEndpoint": {
            "type": "string",
            "defaultValue": "https://rcgsa.blob.core.windows.net/"
        },
        "AzureBlobStorageDest_properties_typeProperties_tenant": {
            "type": "string",
            "defaultValue": "CHANGE THIS TENANT ID"
        },
        "AzureBlobStorageDest_properties_typeProperties_servicePrincipalId": {
            "type": "string",
            "defaultValue": "CHANGE THIS SPN ID"
        }
    },
    "variables": {
        "factoryId": "[concat('Microsoft.DataFactory/factories/', parameters('factoryName'))]"
    },
    "resources": [
        {
            "name": "[concat(parameters('factoryName'), '/copy files')]",
            "type": "Microsoft.DataFactory/factories/pipelines",
            "apiVersion": "2018-06-01",
            "properties": {
                "activities": [
                    {
                        "name": "copy_files",
                        "type": "Copy",
                        "dependsOn": [],
                        "policy": {
                            "timeout": "7.00:00:00",
                            "retry": 0,
                            "retryIntervalInSeconds": 30,
                            "secureOutput": false,
                            "secureInput": false
                        },
                        "userProperties": [
                            {
                                "name": "Source",
                                "value": "sourcefiles//"
                            },
                            {
                                "name": "Destination",
                                "value": "destination//"
                            }
                        ],
                        "typeProperties": {
                            "source": {
                                "type": "BinarySource",
                                "storeSettings": {
                                    "type": "AzureBlobStorageReadSettings",
                                    "recursive": true,
                                    "wildcardFileName": "*.*"
                                }
                            },
                            "sink": {
                                "type": "BinarySink",
                                "storeSettings": {
                                    "type": "AzureBlobStorageWriteSettings"
                                }
                            },
                            "enableStaging": false
                        },
                        "inputs": [
                            {
                                "referenceName": "SourceDataset",
                                "type": "DatasetReference",
                                "parameters": {}
                            }
                        ],
                        "outputs": [
                            {
                                "referenceName": "DestinationDataset",
                                "type": "DatasetReference",
                                "parameters": {}
                            }
                        ]
                    }
                ],
                "annotations": []
            },
            "dependsOn": [
                "[concat(variables('factoryId'), '/datasets/SourceDataset')]",
                "[concat(variables('factoryId'), '/datasets/DestinationDataset')]"
            ]
        },
        {
            "name": "[concat(parameters('factoryName'), '/AzureBlobStorageSource')]",
            "type": "Microsoft.DataFactory/factories/linkedServices",
            "apiVersion": "2018-06-01",
            "properties": {
                "annotations": [],
                "type": "AzureBlobStorage",
                "typeProperties": {
                    "connectionString": "[parameters('AzureBlobStorageSource_connectionString')]"
                }
            },
            "dependsOn": []
        },
        {
            "name": "[concat(parameters('factoryName'), '/SourceDataset')]",
            "type": "Microsoft.DataFactory/factories/datasets",
            "apiVersion": "2018-06-01",
            "properties": {
                "linkedServiceName": {
                    "referenceName": "AzureBlobStorageSource",
                    "type": "LinkedServiceReference"
                },
                "annotations": [],
                "type": "Binary",
                "typeProperties": {
                    "location": {
                        "type": "AzureBlobStorageLocation",
                        "container": "sourcefiles"
                    }
                },
                "schema": []
            },
            "dependsOn": [
                "[concat(variables('factoryId'), '/linkedServices/AzureBlobStorageSource')]"
            ]
        },
        {
            "name": "[concat(parameters('factoryName'), '/DestinationDataset')]",
            "type": "Microsoft.DataFactory/factories/datasets",
            "apiVersion": "2018-06-01",
            "properties": {
                "linkedServiceName": {
                    "referenceName": "AzureBlobStorageDest",
                    "type": "LinkedServiceReference"
                },
                "annotations": [],
                "type": "Binary",
                "typeProperties": {
                    "location": {
                        "type": "AzureBlobStorageLocation",
                        "container": "destination"
                    }
                },
                "schema": []
            },
            "dependsOn": [
                "[concat(variables('factoryId'), '/linkedServices/AzureBlobStorageDest')]"
            ]
        },
        {
            "name": "[concat(parameters('factoryName'), '/AzureBlobStorageDest')]",
            "type": "Microsoft.DataFactory/factories/linkedServices",
            "apiVersion": "2018-06-01",
            "properties": {
                "annotations": [],
                "type": "AzureBlobStorage",
                "typeProperties": {
                    "serviceEndpoint": "[parameters('AzureBlobStorageDest_properties_typeProperties_serviceEndpoint')]",
                    "tenant": "[parameters('AzureBlobStorageDest_properties_typeProperties_tenant')]",
                    "servicePrincipalId": "[parameters('AzureBlobStorageDest_properties_typeProperties_servicePrincipalId')]",
                    "servicePrincipalKey": {
                        "type": "SecureString",
                        "value": "[parameters('AzureBlobStorageDest_servicePrincipalKey')]"
                    }
                }
            },
            "dependsOn": []
        }
    ]
}
DEPLOY

  # these key-value pairs are passed into the ARM Template's `parameters` block
  parameters = {
    "AzureBlobStorageSource_connectionString" = var.dsConnectionString
    "AzureBlobStorageDest_servicePrincipalKey" = var.servicePrincipalKey
    "AzureBlobStorageDest_properties_typeProperties_serviceEndpoint" = azurerm_storage_account.sac.primary_blob_endpoint
    "AzureBlobStorageDest_properties_typeProperties_tenant" = var.tenantId
    "AzureBlobStorageDest_properties_typeProperties_servicePrincipalId" = var.servicePrincipalId
  }

  deployment_mode = "Incremental"
}
