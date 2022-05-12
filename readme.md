## Oauth Apim Example

This repo contains a simple demonstration of using Oauth and JWT tokens in Azure API Management and Terraform

This is based on a combination of the API Management Hands on labs found here:
https://azure.github.io/apim-lab/

And a walkthrough here:
https://platform.deloitte.com.au/articles/oauth2-client-credentials-flow-on-azure-api-management

## Details
This sample deploys an Developer tier API Management instance with a single API configured.  API used is the public used in the Serverless Open Hack labs.

There is a single operation configured that validates the JWT token

Terraform is used to deploy the all the services, the app registrations and the APIM policy.

There are REST tests configured to test from within VS Code

Services deployed:
* Azure resource group         - rg-uks-oauth-demo-apim-dev
* Azure API Managment Instance - apim-ais-demo-dev
* Azure Application Insights   - apimappinsightsdev
* AAD App Registration         - oathapim-demo
* AAD App Registration         - oauthapim-demo-client 

### Notes
The API is deployed from a separate file and uses a data reference to the API Management instance.  This represents organisations that have different teams for infrastructure and API developers.

The JWT token only has an audience check, it does not check that the caller has permissions on the client app registration.  The article linked above shows how to add that.  This sample will run in a tenant where you do not have AAD admin access.

The client app registration does not contain code to create the secret, this needs to be created manually after deployment.

### Running the sample
Once deployed it will be necessary to get the various Ids and the client secret value and put them in the oauth-requests.http file, placeholders are provided.  Once the REST Client extension is installed there will be a 'Send' link that appears above each request, simply click it.  Run the top POST once first, this should return a token, copy the token and paste it into the Authorization header for the next GET request.  A successful call will return details of an Ice Cream product.  If there any failures there should be a link in the response to the APIM log which provides details of the error.

### VS Code
This sample was created in Visual Studio Code and takes advantage of the REST Client extension which allows you to make test REST or HTTP type calls all from within the VS Code environment:
https://marketplace.visualstudio.com/items?itemName=humao.rest-client  

### Terraform

There are terraform configuration files, values will need to be changed to match Azure subscription and state storage.  To set up and deploy the sample use the following commands:
```bash
    terraform init -backend-config=backend-dev.hcl   
    terraform plan -var-file=dev.tfvars -out=tf.plan
    terraform apply tf.plan
```
Environment specific values are kept in the dev.tfvars file or can be passed on the command line.

### Issues
This is a work in progress and this is a first cut. Things to change include:

* Remove hard coded guids
* Add permissions
* Check if the consumption tier will work for faster deployment
* Use keyvault for secrets



