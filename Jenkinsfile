@Library('jenkins-shared-libraries')_ 

if(! env.BRANCH_NAME.equalsIgnoreCase='main')
{
   nodeEkspipeline.call(configMap)
}
else{
    echo "proced with deployment"
}