# Cadalys Concierge Chatbot with LiveAgent SFDX  App

## Dev, Build and Test
```
git clone https://github.com/stevecorbelsfdc/nightfall-employee-engagement-concierge-bot
```
Use your favorite IDE Code editor (I am using Visual Studio Code with ForceCode extension)
Test your code against scratch orgs
When you want to deploy it to your target org
Login to your target Org with associated credentials

```
sfdx force:auth:web:login -a targetorg
````
Convert your source in a format that works with the Metadata API
```
sfdx force:source:convert -d mdapioutput/
```
Deploy it to your target Org
```
sfdx force:mdapi:deploy -d mdapioutput/ -u targetorg -w 100
```



## Resources


## Description of Files and Directories


## Issues
Need to assign the Knowledge feature license to your scratch org user
Need to create manually a community to test the bot component

