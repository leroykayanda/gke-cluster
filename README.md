

This repo contains terraform code that sets up a VPC,  GKE cluster and a demo application.

**GKE cluser components**
1.  GKE module
2.  A datadog dashboard showing key kubernetes metrics and datagog alarms.
3.  argocd for CICD. This installs the core argocd helm chart which comes bundled with argocd notifications. We also install the [argocd image updater](https://dev.to/leroykayanda/using-argocd-image-updater-with-gcp-artifact-registry-2o2l) which triggers deployments when an image is pushed to Artifact Registry. Argocd is exposed via ingress.
4.  External secrets helm chart which is used to sync secrets between GCP secrets manager and kubernetes. We use [stakater reloader](https://github.com/stakater/Reloader) to trigger a deployment whenever a secret is updated in gcp secrets manager.

This repo also sets up various components for a demo python flask app. The app code is in the demo-app folder.

**Demo app components**

We create these components via terraform.
 - app service account 
 - Artifact registy repo
 - argocd application
 - app static ip
 - app ssl cert
 - app dns name in Cloud DNS


We then create these components via Kustomize.

- deployment
- service
- secrets 
- ingress
- HPA
- app namespace

We send logs to datadog.

To set up a new application, follow these steps:
Make sure you are in the correct terraform workspace and kubernetes context.

    terraform workspace select dev
    kubectl config use-context dev

Set up the terraform kubernetes provider Create the kubernetes service account in terraform as well as the other terraform resources. We don't create the argocd application and domain name yet.

Go to the correct kustomize context locally and create the resources.

    cd manifests/overlays/dev
    kubectl apply -k .

Verify the kustomize resources have been created. Get the argocd password.

    kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode


Add the variables ARGOCD_AUTH_USERNAME (admin) and ARGOCD_AUTH_PASSWORD (gotten above) as terraform env variables. Set up the terraform provider and backend and create the argocd application. Set up the argocd domain name as well.
 Apply the changes in terraform.
Test the app.

**Misc**
When you add a new secret in AWS secrets manager or modify a secret, stakater reloader will trigger a rolling update. Keep this in mind as this can cause issues in production. You may need to update secrets during a maintenance window.. Use the command below to check when a secret was last updated.

    kubectl describe ExternalSecret -n dev-demo-app
    Events:
      Type    Reason   Age   From              Message
      ----    ------   ----  ----              -------
      Normal  Updated  23s   external-secrets  Updated Secret

The app image is pushed to Artifact Registry using a Github actions workflow.