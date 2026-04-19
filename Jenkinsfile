@Library('jenkins-shared-libraries')_ 

def configMap = [
    project : "roboshop",
    component : "user"
]

nodeEkspipeline.call(configMap)

// if(! env.BRANCH_NAME.equalsIgnoreCase='main')
// {
//    nodeEkspipeline.call(configMap)
// }
// else{
//     echo "proced with deployment"
// }