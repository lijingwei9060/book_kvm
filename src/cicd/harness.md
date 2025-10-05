

## install

mkdir /opt/data

docker run -d \
  -p 80:3000 \
  -p 3022:3022 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GITNESS_URL_BASE=http://10.97.6.64.nip.io \
  -e GITNESS_URL_CONTAINER=http://10.97.6.64.nip.io \
  -e GITNESS_URL_REGISTRY=http://10.97.6.64.nip.io \
  -e GITNESS_DEBUG=true \
  -v /opt/data/harness:/data \
  --name harness \
  --restart always \
  harness/harness:3.2.0


## 功能列表

Overview

Pipeline

Executions:
  列表： 
  Execution详情：
    Pipeline： Stage、Metric、Log
    Inputs
    Policy Evaluations
    Artifacts
    Commits
    Supply Chain
    Tests
    Security Tests： Issue
    Resilience
    Resources
    IaCM Cost Change Estimation
    Console View 



DevOps Modernzation
  Continuous Delivery & Gitops
  Continuous Integration
  Feature Management & Experimentation
  Chaos Engineeriing
  Infrastructure as Code Management
  Database DevOps
  Artifact Registry
Developer Experience
  Software Engineering Insights
  Code Repository
  Internal Developer Portal
  Cloud Development Environments
Secure Software Delivery
  Security Testing Orchestration
  Supply Chain Security


Developer Portal
Cloud Development
Code Repository
Builds
Security Tests
Aitifact Registry
Deployments
  Overview
  Get Started
  Services
  Enviromnents
  Monitored Services
  Overrides
  GitOps
  Product Usage
Infrastructure