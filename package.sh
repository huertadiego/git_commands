#!/bin/bash

##
## script para generar los archivos xml que se usan en workbench en la opcion retrieve
## parte del proceso de api update
##

cd azusgb01/src/ ## hay que ajustar este path a la ubicacion del branch para cada usuario que lo ejecute !


[ -d "/home/dhuerta/azusgb01/src/extras" ] &&  echo "Directory found." || (echo "Directory not found."; mkdir extras)


VERSION=58.0 ## para cuando cambie la version
IFS=$'\n'


for f in $(ls -d */ | sed 's/\///' ); do   ## recorremos las carpetas de SRC en el branch

  echo "Working on [ $f ] ... ";
  echo -e "<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\"> \n \t<types>" > extras/$f.xml;  ## encabezado del archivo xml

  if [[ $f == *"approvalProcesses"* || $f == *"customMetadata"* || $f == *"duplicateRules"* || $f == *"quickActions"* ]]; then
   echo -e "\t\t<members>*</members>" >> extras/$f.xml;
  else

     sleep 0
      for i in $(ls $f); do
      echo -e "\t\t<members>$( echo $i| cut -d "." -f1)</members>" >> extras/$f.xml;  ## agregando members del archivo
      #tail -n 1 extras/$f.xml
      done ;
  fi

if [[ $f == "applications" ]]; then
name=CustomApplication
elif [[ $f == "appMenus" ]]; then
name=AppMenu
elif [[ $f == "approvalProcesses" ]]; then
name=ApprovalProcess
elif [[ $f == "assignmentRules" ]]; then
name=AssignmentRules
elif [[ $f == "aura" ]]; then
name=AuraDefinitionBundle
elif [[ $f == "classes" ]]; then
name=ApexClass
elif [[ $f == "communities" ]]; then
name=Community
elif [[ $f == "components" ]]; then
name=ApexComponent
elif [[ $f == "contentassets" ]]; then
name=ContentAsset
elif [[ $f == "customMetadata" ]]; then
name=CustomMetadata
elif [[ $f == "customPermissions" ]]; then
name=CustomPermission
elif [[ $f == "dashboards" ]]; then
name=Dashboard
elif [[ $f == "documents" ]]; then
name=Document
elif [[ $f == "duplicateRules" ]]; then
name=DuplicateRule
elif [[ $f == "email" ]]; then
name=EmailTemplate
elif [[ $f == "flexipages" ]]; then
name=FlexiPage
elif [[ $f == "flowDefinitions" ]]; then
name=FlowDefinition
elif [[ $f == "flows" ]]; then
name=Flow
elif [[ $f == "globalValueSets" ]]; then
name=GlobalValueSet
elif [[ $f == "groups" ]]; then
name=Group
elif [[ $f == "homePageLayouts" ]]; then
name=HomePageLayout
elif [[ $f == "labels" ]]; then
name=CustomLabels
elif [[ $f == "layouts" ]]; then
name=Layout
elif [[ $f == "letterhead" ]]; then
name=Letterhead
elif [[ $f == "lwc" ]]; then
name=LightningComponentBundle
elif [[ $f == "matchingRules" ]]; then
name=MatchingRules
elif [[ $f == "namedCredentials" ]]; then
name=NamedCredential
elif [[ $f == "networks" ]]; then
name=Network
elif [[ $f == "objects" ]]; then
name=CustomObject
elif [[ $f == "objectTranslations" ]]; then
name=CustomObjectTranslation
elif [[ $f == "pages" ]]; then
name=ApexPage
elif [[ $f == "pathAssistants" ]]; then
name=PathAssistant
elif [[ $f == "permissionsets" ]]; then
name=PermissionSet
elif [[ $f == "profiles" ]]; then
name=Profile
elif [[ $f == "queues" ]]; then
name=Queue
elif [[ $f == "quickActions" ]]; then
name=QuickAction
elif [[ $f == "reports" ]]; then
name=Report
elif [[ $f == "reportTypes" ]]; then
name=ReportType
elif [[ $f == "roles" ]]; then
name=Role
elif [[ $f == "settings" ]]; then
name=Settings
elif [[ $f == "sharingRules" ]]; then
name=SharingRules
elif [[ $f == "sites" ]]; then
name=CustomSite
elif [[ $f == "standardValueSets" ]]; then
name=StandardValueSet
elif [[ $f == "StandardValueSetTranslations" ]]; then
name=StandardValueSetTranslation
elif [[ $f == "staticresources" ]]; then
name=StaticResource
elif [[ $f == "tabs" ]]; then
name=CustomTab
elif [[ $f == "translations" ]]; then
name=Translations
elif [[ $f == "triggers" ]]; then
name=ApexTrigger
elif [[ $f == "workflows" ]]; then
name=Workflow
fi

echo -e "NAME = $name \n";
echo -e "\t\t<name>$name</name>\n\t</types> \n\t<version>$VERSION</version> \n</Package>" >> extras/$f.xml; ## final del archivo ( se esta usando el nombre de la carpeta como el nombre del archivo xml, esto debe revisarse como se muestra mas abajo )

        uniq extras/$f.xml > extras/$f.xml_NO_DUPLICATES;  ## nos aseguramos que no haya repetidos
        mv extras/$f.xml_NO_DUPLICATES extras/$f.xml;
        rm -f extras/$f.xml_NO_DUPLICATES;

done
unset IFS

echo "FINISHED !!!"

########################################
#
#
# corre la siguiente linea para comprobar los nombres correctos
# en el script de arriba se usa el nombre de la carpeta original en el branch
# pero esta puede cambiar segun el contenido que estan en package.xml
# (y deberia ser comprobada en workbench)
#
# $ for f in $(ls -d */ | sed 's/\///' ); do echo $f; string=$(echo $f | sed 's/.$//') ;echo $string ;grep -i $string package.xml; sleep 2; done
#
#
# comando para limpiar la lista de packages copiada del workbench
# sed -i 's/<option\ value="//g' lista_raw.txt && sed -i 's/">.*//g' lista_raw.txt