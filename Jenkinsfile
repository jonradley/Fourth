#!groovy
library 'sharedlib@master'
library 'SharedJenkinsPipelines@tradesimpleWebServicePipeline'

def octopusUrl = 'https://prod-deploy.fourth.com'

// Run packaging and publishing only for release branches, otherwise consider run for Pull Requests
def onReleaseBranch()
{
	return env.BRANCH_NAME == 'master'
}

node('ie1tsbld03')
{
	def wsDir = "c:/${env.JOB_NAME}"
	def source = "${wsDir}/build/Output"
	def buildVersion = "2.${env.BUILD_NUMBER}.1"
	def projectName = env.JOB_NAME.split("/")[0]
	def pack = "./${projectName}.${buildVersion}.zip"

	ws (wsDir)
	{
		stage('Get Source Code')
		{
			getSCMSourceCode()
		}
		
		stage('Build')
		{
			powershell "Build/integration_package.ps1"
		}

		if (onReleaseBranch())
		{
			if (currentBuild.result != null && currentBuild.result != "SUCCESS")
			{
				error "Aborting package and publish as build job result is '$currentBuild.result'"
			}		
		
			stage('Archive')
			{
				archiveArtifacts artifacts: "**\\Output\\**\\*", fingerprint: false
			}
			
			stage('Inject Deployment Scripts')
			{
				step ([$class: 'CopyArtifact', 
					projectName: 'Tradesimple-Hospitality.Deployment/master'])
				
				bat "copy /Y deployment\\*.psm1 build\\Output\\"
				bat "copy /Y deployment\\${projectName}\\*.ps1 build\\Output\\"
			}
			
			stage('Package Zip')
			{
				echo "Creating artifact ${pack}"
				
				zip dir: source, zipFile: pack
			}
		
			stage('Publish')
			{
				echo "Publish ${pack}"
				withCredentials([string(credentialsId: 'Octopus-Apikey', variable: 'octoApiKey')])
				{
					bat "c:\\OctopusTools\\Octo.exe push --replace-existing --package ${pack} --server ${octopusUrl} --apiKey ${octoApiKey}"
				}
				currentBuild.description = "Release $buildVersion created in Octopus"
			}

			stage('Send Notifications')
			{
				sendNotifications(projectName, buildVersion)
			}
		}
	}
}
