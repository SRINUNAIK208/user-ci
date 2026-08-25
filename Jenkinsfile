pipeline {
    agent {
        label 'AGENT-1'
    }
    options {
        timeout(time: '30', unit: 'MINUTES')
        disableConcurrentBuilds();
    }
    environment{
        appVersion = ''
        project = "roboshop"
        component = 'user'
        region = 'us-east-1'
        ACC_ID = '388343452532'
    }
    stages {
        stage('read the package json'){
            steps{
                script{
                    def packageJson = readJSON file: 'package.json'
                    appVersion = packageJson.version
                    echo "application version is ${appVersion}"
                }
            }
        }
        
        stage('install dependencies'){
            steps{
                sh """
                npm install
                """
            }
        }
        // stage('scan libraries alerts'){
        //     steps{
        //         script{
        //             def alerts = readJSON text: response

        //             def highCriticalOpen = alerts.findAll { alert ->

        //                 def severity = alert.security_advisory?.severity?.toLowerCase()
        //                 def state = alert.state?.toLowerCase()

        //                 state == 'open' &&
        //                 (severity == 'high' || severity == 'critical')
        //             }

        //             if (highCriticalOpen.size() > 0) {

        //                 echo "❌ Found ${highCriticalOpen.size()} OPEN HIGH/CRITICAL Dependabot alerts"

        //                 highCriticalOpen.each { alert ->
        //                     echo "Package: ${alert.dependency.package.name}"
        //                     echo "Severity: ${alert.security_advisory.severity}"
        //                     echo "State: ${alert.state}"
        //                 }

        //                 error("Dependabot quality gate failed")

        //             } else {

        //                 echo "✅ No OPEN HIGH/CRITICAL Dependabot alerts found."

        //             }
        //         }
        //     }
        // }
        // stage('scan the source code'){
        //     environment {
        //         scannerHome = tool 'sonar'
        //     }
        //     steps{
        //         withSonarQubeEnv('sonar' ){
        //             sh """
        //                ${scannerHome}/bin/sonar-scanner
        //             """
        //         }

        //     }
        // }
        //  stage("Quality Gate") {
        //     steps {
        //         waitForQualityGate abortPipeline: true
        //     }
        // }
        stages('Build the docker image'){
            steps{
            withAWS(credentials: 'aws-cred', region: 'us-east-1'){
                sh """
                    aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com
                    docker build -t ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${project}/${component}:${appVersion} .
                    docker push ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${project}/${component}:${appVersion}
                """
            }
            }
        }
        stage('scan ecr image'){
            steps{
                withAWS(credentials: 'aws-cred', region: 'us-east-1'){
                    sh """
                        aws ecr describe-image-scan-findings \
                            --repository-name roboshop/user \
                            --image-id imageTag=${appVersion} \
                            --region us-east-1 \
                            --query 'imageScanFindings.findingSeverityCounts'
                    """

                }
            }
        }
    }
    // stage('trigger deployment'){
    //     steps{
    //         build job: 'user-cd',
    //         parameters: [
    //             string(name: 'appVersion', value: "${appVersion}")
    //             string(name: 'deploy_to', value:'dev')
    //         ]
    //         wait: false,
    //         propagate: false
    //     }
    // }
    post{
        always {
            echo "i am always block"
        }
        success {
            echo "i am success"
        }
        failed {
            echo "i am failed"
        }
    }
}