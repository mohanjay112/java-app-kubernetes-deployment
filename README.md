#  Java App Deployment on Kubernetes Cluster

This project demonstrates how to containerize a Java web application and deploy it to a **Kubernetes cluster** using `deployment.yaml` and `service.yaml`. The app runs on a Tomcat server and is accessible via a NodePort service.

---

# Tools & Technologies Used

- Java (Maven)
- Docker
- Kubernetes (Minikube or k3s)
- kubectl
- Tomcat 8
- GitHub


---

## Screenshots

## ✅ Kubernetes Service Created
![K8s Service](Screenshots/k8s-service-created.png)

## ✅ Java App Login Page
![Login](Screenshots/app-login-page.png)

## ✅ Java App After Login
![Logged In](Screenshots/app-loggedin-page.png)

## ✅ RabbitMQ Dashboard
![RabbitMQ](Screenshots/rabbitmq-dashboard.png)

## ✅ Memcached Status Page
![Memcached](Screenshots/memcached-status.png)

---

## Learning Outcome

- Learned Kubernetes concepts: Pods, Deployments, Services
- Created deployment.yaml and service.yaml for app deployment
- Exposed Java app via NodePort on local Kubernetes cluster
- Deployed Dockerized Java WAR app to Kubernetes successfully
- Managed app lifecycle using `kubectl` commands



